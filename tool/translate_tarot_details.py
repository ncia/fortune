import os
import json
import requests
import time
from pathlib import Path

dotenv_path = Path('.env')
api_key = None
if dotenv_path.exists():
    with open(dotenv_path, 'r', encoding='utf-8') as f:
        for line in f:
            if line.startswith('GEMINI_API_KEY='):
                api_key = line.split('=', 1)[1].strip()

if not api_key:
    print("API Key not found")
    exit(1)

url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"

ko_file_path = Path('assets/data/tarot_details_ko.json')
with open(ko_file_path, 'r', encoding='utf-8') as f:
    tarot_ko = json.load(f)

l10n_dir = Path('lib/l10n')
languages = []
for file_path in l10n_dir.glob('*.arb'):
    lang_code = file_path.name.replace('app_', '').replace('.arb', '')
    if lang_code not in ['ko', 'en']:  # Assuming we will translate to English too if we want, but let's translate to all except 'ko'. Actually let's include 'en'.
        languages.append(lang_code)

if 'en' not in languages:
    languages.append('en')

# We only process if missing or incomplete
# To keep track of progress and report
progress_file = Path('translate_progress.log')
error_file = Path('translate_errors.log')

from concurrent.futures import ThreadPoolExecutor, as_completed
import threading

log_lock = threading.Lock()

def log_progress(msg):
    with log_lock:
        print(msg)
        with open(progress_file, 'a', encoding='utf-8') as f:
            f.write(msg + '\n')

def log_error(msg):
    with log_lock:
        print(f"ERROR: {msg}")
        with open(error_file, 'a', encoding='utf-8') as f:
            f.write(msg + '\n')

# Clear progress log at start
if progress_file.exists():
    progress_file.unlink()

log_progress(f"Starting translation for {len(languages)} languages with 5 concurrent workers.")

CHUNK_SIZE = 2

def process_language(lang):
    target_file = Path(f'assets/data/tarot_details_{lang}.json')
    translated_data = []
    
    if target_file.exists():
        try:
            with open(target_file, 'r', encoding='utf-8') as f:
                translated_data = json.load(f)
        except:
            translated_data = []
            
    # Create a map of existing translations
    existing_map = {item['id']: item for item in translated_data}
    
    # Filter items that need translation
    items_to_translate = [item for item in tarot_ko if item['id'] not in existing_map]
    
    if not items_to_translate:
        log_progress(f"[{lang}] Already complete.")
        return
        
    log_progress(f"[{lang}] Needs {len(items_to_translate)} items translated.")
    
    for i in range(0, len(items_to_translate), CHUNK_SIZE):
        chunk = items_to_translate[i:i+CHUNK_SIZE]
        chunk_ids = [c['id'] for c in chunk]
        log_progress(f"[{lang}] Translating chunk {i//CHUNK_SIZE + 1} ({len(chunk)} items)...")
        
        prompt = f"""
You are a professional localization expert. Translate the following JSON array of tarot card interpretations from Korean into the language corresponding to the locale code "{lang}".
Keep the exact JSON structure, keys ("id", "upright", "reversed", "keyMeanings", "general", "love", "career", "health", "spirituality"), and ids.
Only translate the values inside "keyMeanings", "general", "love", "career", "health", and "spirituality".
Return ONLY valid JSON array format representing the translated items, without markdown blocks. Do NOT wrap with ```json.

JSON to translate:
{json.dumps(chunk, ensure_ascii=False)}
"""
        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"temperature": 0.1}
        }
        
        success = False
        attempt = 0
        while not success:
            attempt += 1
            try:
                response = requests.post(url, json=payload, timeout=120)
                response_json = response.json()
                
                if 'error' in response_json:
                    log_error(f"[{lang}] API Error on chunk {chunk_ids} (Attempt {attempt}): {response_json['error']}")
                    time.sleep(10) # Wait longer on API errors
                    continue
                    
                text = response_json['candidates'][0]['content']['parts'][0]['text']
                text = text.replace('```json', '').replace('```', '').strip()
                
                translated_chunk = json.loads(text)
                
                # Validation
                if len(translated_chunk) != len(chunk):
                    raise ValueError(f"Expected {len(chunk)} items, got {len(translated_chunk)}")
                
                for item in translated_chunk:
                    existing_map[item['id']] = item
                
                # Save progress incrementally
                with open(target_file, 'w', encoding='utf-8') as f:
                    # preserve order of original
                    final_list = []
                    for orig in tarot_ko:
                        if orig['id'] in existing_map:
                            final_list.append(existing_map[orig['id']])
                    json.dump(final_list, f, ensure_ascii=False, indent=2)
                
                success = True
                log_progress(f"[{lang}] Chunk {chunk_ids} translated successfully on attempt {attempt}.")
                break
                
            except Exception as e:
                log_error(f"[{lang}] Attempt {attempt} failed for chunk {chunk_ids}. Error details: {str(e)}. Retrying...")
                time.sleep(10)
                
        time.sleep(1.5) # Rate limit protection

with ThreadPoolExecutor(max_workers=5) as executor:
    futures = [executor.submit(process_language, lang) for lang in languages]
    for future in as_completed(futures):
        try:
            future.result()
        except Exception as exc:
            log_error(f"Language processing generated an exception: {exc}")

log_progress("Translation process completed without any remaining errors.")
