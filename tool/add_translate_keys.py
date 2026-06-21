import os
import json
import time
from pathlib import Path
import urllib.request
import urllib.parse
from urllib.error import HTTPError, URLError

API_KEY = os.environ.get("GEMINI_API_KEY")
if not API_KEY:
    try:
        from dotenv import load_dotenv
        load_dotenv()
        API_KEY = os.environ.get("GEMINI_API_KEY")
    except ImportError:
        pass

if not API_KEY:
    print("Error: GEMINI_API_KEY not found in environment")
    exit(1)

L10N_DIR = Path("lib/l10n")
KEYS_TO_TRANSLATE = {
    "buttonTranslate": "Translate",
    "translateFailed": "Translation failed: {error}"
}

def translate_with_gemini(text_dict, target_language):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}"
    prompt = f"""
Translate the following JSON dictionary values into {target_language}.
Keep the JSON keys exactly the same.
Keep any placeholders like {{error}} exactly as they are.
Respond ONLY with the raw JSON object, no markdown blocks, no code blocks, no explanations.

Input JSON:
{json.dumps(text_dict, ensure_ascii=False)}
"""
    data = {
        "contents": [{
            "parts": [{"text": prompt}]
        }],
        "generationConfig": {
            "temperature": 0.1,
            "responseMimeType": "application/json"
        }
    }
    
    req = urllib.request.Request(
        url,
        data=json.dumps(data).encode('utf-8'),
        headers={'Content-Type': 'application/json'},
        method='POST'
    )

    for attempt in range(3):
        try:
            with urllib.request.urlopen(req) as response:
                result = json.loads(response.read().decode('utf-8'))
                text = result['candidates'][0]['content']['parts'][0]['text']
                
                if text.startswith('```json'):
                    text = text[7:]
                if text.startswith('```'):
                    text = text[3:]
                if text.endswith('```'):
                    text = text[:-3]
                    
                return json.loads(text.strip())
        except HTTPError as e:
            if e.code == 429:
                print("Rate limit hit, waiting 5 seconds...")
                time.sleep(5)
            else:
                print(f"HTTP Error {e.code}: {e.read().decode('utf-8')}")
                break
        except Exception as e:
            print(f"Error: {e}")
            break
            
    return None

def main():
    # First update English
    en_file = L10N_DIR / "app_en.arb"
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
    
    updated = False
    for key, val in KEYS_TO_TRANSLATE.items():
        if key not in en_data:
            en_data[key] = val
            updated = True
            
            if "{" in val:
                en_data[f"@{key}"] = {
                    "placeholders": {
                        "error": { "type": "String" }
                    }
                }
                
    if updated:
        with open(en_file, 'w', encoding='utf-8') as f:
            json.dump(en_data, f, ensure_ascii=False, indent=2)
            f.write('\n')
        print("Updated app_en.arb")

    # Update Korean
    ko_file = L10N_DIR / "app_ko.arb"
    with open(ko_file, 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
    
    ko_updated = False
    ko_translations = {
        "buttonTranslate": "번역 보기",
        "translateFailed": "번역 실패: {error}"
    }
    
    for key, val in ko_translations.items():
        if key not in ko_data:
            ko_data[key] = val
            ko_updated = True
            
            if "{" in val:
                ko_data[f"@{key}"] = {
                    "placeholders": {
                        "error": { "type": "String" }
                    }
                }
                
    if ko_updated:
        with open(ko_file, 'w', encoding='utf-8') as f:
            json.dump(ko_data, f, ensure_ascii=False, indent=2)
            f.write('\n')
        print("Updated app_ko.arb")

    # Process other languages
    for file_path in L10N_DIR.glob("app_*.arb"):
        lang_code = file_path.stem.replace("app_", "")
        if lang_code in ["en", "ko"]:
            continue
            
        print(f"Processing {lang_code}...")
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        needs_translation = {}
        for key, val in KEYS_TO_TRANSLATE.items():
            if key not in data:
                needs_translation[key] = val
                
        if not needs_translation:
            print(f"  {lang_code} is already up to date")
            continue
            
        translated = translate_with_gemini(needs_translation, lang_code)
        if translated:
            for k, v in translated.items():
                data[k] = v
                if "{" in v:
                    data[f"@{k}"] = {
                        "placeholders": {
                            "error": { "type": "String" }
                        }
                    }
                    
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
                f.write('\n')
            print(f"  Updated {lang_code}")
        
        time.sleep(1)

if __name__ == "__main__":
    main()
