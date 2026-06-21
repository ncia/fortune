import os
import json
import time
import re
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

L10N_DIR = Path("lib/l10n")

KEYS_TO_FORCE_TRANSLATE = [
    "proceedReadingTitle",
    "proceedReadingContent",
    "dialogCancel",
    "dialogProceed",
    "coinShortageTitle",
    "coinShortageContent",
    "chatDustShortageTitle",
    "chatDustShortageContent",
    "chatStartReadingTitle",
    "chatStartReadingContent",
    "chatCancelBtn",
    "chatStartBtn",
    "chatShufflingCards",
    "chatConfirmBtn",
    "dialogOk"
]

def has_hangul(text):
    return bool(re.search(r'[\u3131-\uD79D]', text))

def is_english_fallback(text, en_text):
    # If the text is identical to English, it probably failed to translate
    return text == en_text

def translate_with_gemini(text_dict, target_language):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}"
    prompt = f"""
Translate the following JSON dictionary values from Korean to {target_language}.
Keep the JSON keys exactly the same.
Keep any placeholders exactly as they are.
Respond ONLY with the raw JSON object.

Input JSON:
{json.dumps(text_dict, ensure_ascii=False)}
"""
    data = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"temperature": 0.1, "responseMimeType": "application/json"}
    }
    req = urllib.request.Request(url, data=json.dumps(data).encode('utf-8'), headers={'Content-Type': 'application/json'}, method='POST')

    for attempt in range(3):
        try:
            with urllib.request.urlopen(req) as response:
                result = json.loads(response.read().decode('utf-8'))
                text = result['candidates'][0]['content']['parts'][0]['text']
                if text.startswith('```json'): text = text[7:]
                if text.startswith('```'): text = text[3:]
                if text.endswith('```'): text = text[:-3]
                return json.loads(text.strip())
        except HTTPError as e:
            if e.code == 429:
                time.sleep(5)
            else:
                break
        except Exception:
            break
    return None

def main():
    ko_file = L10N_DIR / "app_ko.arb"
    with open(ko_file, 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
        
    en_file = L10N_DIR / "app_en.arb"
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
        
    for file_path in L10N_DIR.glob("app_*.arb"):
        lang_code = file_path.stem.replace("app_", "")
        if lang_code in ["ko", "en"]: continue
            
        print(f"Processing {lang_code}...")
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        needs_translation = {}
        for key, val in ko_data.items():
            if key.startswith('@'): continue
            
            # Translate if missing, contains Hangul, or matches English (for non-English langs)
            # OR if it's in our force list and currently matches English or Korean
            if key not in data or has_hangul(data[key]):
                needs_translation[key] = val
            elif key in en_data and is_english_fallback(data[key], en_data[key]):
                needs_translation[key] = val
            elif key in KEYS_TO_FORCE_TRANSLATE and data[key] == val:
                needs_translation[key] = val
                
        if not needs_translation:
            continue
            
        print(f"  Translating {len(needs_translation)} keys...")
        translated = translate_with_gemini(needs_translation, lang_code)
        if translated:
            for k, v in translated.items():
                data[k] = v
                if f"@{k}" in ko_data:
                    data[f"@{k}"] = ko_data[f"@{k}"]
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
                f.write('\n')
        time.sleep(1)

if __name__ == "__main__":
    main()
