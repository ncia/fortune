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

L10N_DIR = Path("lib/l10n")
KEYS_TO_TRANSLATE = {
    "tagLove": "Love",
    "tagMoney": "Wealth",
    "tagHealth": "Health",
    "tagCareer": "Career",
    "tagToday": "Today's Fortune",
    "tagRelationship": "Relationships",
    "tagSelfReflection": "Self-Reflection"
}

def translate_with_gemini(text_dict, target_language):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}"
    prompt = f"""
Translate the following JSON dictionary values into {target_language}.
Keep the JSON keys exactly the same.
Keep them short, like tags.
Respond ONLY with the raw JSON object, no markdown blocks, no code blocks.

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
            if e.code == 429: time.sleep(5)
            else: break
        except Exception:
            break
    return None

def main():
    en_file = L10N_DIR / "app_en.arb"
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
    for k, v in KEYS_TO_TRANSLATE.items(): en_data[k] = v
    with open(en_file, 'w', encoding='utf-8') as f:
        json.dump(en_data, f, ensure_ascii=False, indent=2)
        f.write('\n')

    ko_file = L10N_DIR / "app_ko.arb"
    with open(ko_file, 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
    ko_translations = {
        "tagLove": "연애운",
        "tagMoney": "금전운",
        "tagHealth": "건강운",
        "tagCareer": "직장운",
        "tagToday": "오늘운세",
        "tagRelationship": "인간관계",
        "tagSelfReflection": "자기성찰"
    }
    for k, v in ko_translations.items(): ko_data[k] = v
    with open(ko_file, 'w', encoding='utf-8') as f:
        json.dump(ko_data, f, ensure_ascii=False, indent=2)
        f.write('\n')

    for file_path in L10N_DIR.glob("app_*.arb"):
        lang_code = file_path.stem.replace("app_", "")
        if lang_code in ["en", "ko"]: continue
        
        print(f"Processing {lang_code}...")
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        needs_translation = {k: v for k, v in KEYS_TO_TRANSLATE.items() if k not in data}
        if not needs_translation: continue
            
        translated = translate_with_gemini(needs_translation, lang_code)
        if translated:
            for k, v in translated.items(): data[k] = v
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
                f.write('\n')
        time.sleep(1)

if __name__ == "__main__":
    main()
