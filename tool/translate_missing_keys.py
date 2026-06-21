import os
import json
import requests
import re
from pathlib import Path

# load .env
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

keys_to_translate = {
    'cardDetailTabUpright': '정방향 (Upright)',
    'cardDetailTabReversed': '역방향 (Reversed)',
    'pickCardsText': '{count}장의 카드를 뽑으세요',
    'layoutFan': '부채꼴',
    'layoutStacked': '겹친 모양',
    'readingFateFragments': '운명의 조각들을 읽어내고 있어요.',
    'magicDustObtained': '마력의 가루 +{amount} 획득! ✨',
    'shareResultText': '✨ 내 타로 점 결과를 확인해보세요!\\n\\n자세한 점괘를 알고 싶다면, 타로 마녀 앱을 설치하고 직접 타로 점을 확인해보세요!\\n👉 다운로드: https://play.google.com/store/apps/details?id=com.ncia.tarot_card',
    'buttonShare': '공유하기',
    'buttonSelectSpread': '스프레드 선택',
    'buttonSelectOtherWitch': '다른 마녀 선택'
}

l10n_dir = Path('lib/l10n')
for file_path in l10n_dir.glob('*.arb'):
    filename = file_path.name
    if filename in ['app_ko.arb', 'app_en.arb']:
        continue
    
    lang_code = filename.replace('app_', '').replace('.arb', '')
    print(f"Processing {lang_code}...")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        try:
            arb_data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error parsing {filename}, skipping")
            continue
            
    batch = {}
    for key, value in keys_to_translate.items():
        current_val = arb_data.get(key, '')
        has_korean = bool(re.search(r'[가-힣]', str(current_val)))
        has_question_marks = '?' in str(current_val)
        if has_korean or has_question_marks or not current_val:
            batch[key] = value
            
    if batch:
        prompt = f"""
You are a professional localization expert. Translate the following JSON object's values into the language corresponding to the locale code "{lang_code}".
Keep placeholders like {{count}} and {{amount}} exactly as they are. Keep emojis. Keep \\n as \\n.
Return ONLY valid JSON format representing the translated key-value pairs, without markdown blocks.

JSON to translate:
{json.dumps(batch, ensure_ascii=False)}
"""
        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"temperature": 0.1}
        }
        try:
            response = requests.post(url, json=payload)
            response_json = response.json()
            text = response_json['candidates'][0]['content']['parts'][0]['text']
            text = text.replace('```json', '').replace('```', '').strip()
            
            translated_dict = json.loads(text)
            for k, v in translated_dict.items():
                arb_data[k] = v
                
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_data, f, ensure_ascii=False, indent=2)
            print(f"Updated {filename}")
        except Exception as e:
            print(f"Error calling API for {lang_code}: {e}")
            if 'response_json' in locals():
                print(response_json)
    else:
        print(f"No updates needed for {filename}")
