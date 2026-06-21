import json
import glob
import os
import time
from deep_translator import GoogleTranslator

# First, define English translations
en_translations = {
    "buttonShare": "Share",
    "buttonSelectSpread": "Select Spread",
    "buttonSelectOtherWitch": "Select Other Witch",
    "shareResultText": "🔮 Check out my Tarot reading results!\\n\\nIf you want to know the detailed reading, install the Tarot Witch app and check your tarot reading yourself!\\n👉 Download: https://play.google.com/store/apps/details?id=com.ncia.tarot_card"
}

# Update en.arb
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)
for k, v in en_translations.items():
    en_data[k] = v
with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en_data, f, ensure_ascii=False, indent=2)

# Update ko.arb
ko_translations = {
    "buttonShare": "공유하기",
    "buttonSelectSpread": "스프레드 선택",
    "buttonSelectOtherWitch": "다른 마녀 선택",
    "shareResultText": "🔮 내 타로 점괘 결과를 확인해보세요!\\n\\n자세한 점괘 내용이 궁금하다면 타로마녀 앱을 설치해서 직접 타로 점을 확인해 보세요!\\n👉 다운로드: https://play.google.com/store/apps/details?id=com.ncia.tarot_card"
}
with open('lib/l10n/app_ko.arb', 'r', encoding='utf-8') as f:
    ko_data = json.load(f)
for k, v in ko_translations.items():
    ko_data[k] = v
with open('lib/l10n/app_ko.arb', 'w', encoding='utf-8') as f:
    json.dump(ko_data, f, ensure_ascii=False, indent=2)

files = glob.glob('lib/l10n/app_*.arb')
files = [f for f in files if not f.endswith('app_en.arb') and not f.endswith('app_ko.arb')]

lang_map = {
    'zh_Hant': 'zh-TW',
    'zh_Hans': 'zh-CN',
    'zh': 'zh-CN',
    'ko': 'ko',
    'en': 'en'
}

for file in files:
    filename = os.path.basename(file)
    lang_code = filename.replace('app_', '').replace('.arb', '')
    
    translate_target = lang_map.get(lang_code, lang_code)
    try:
        translator = GoogleTranslator(source='en', target=translate_target)
    except Exception as e:
        print(f"Skipping {lang_code}: {e}")
        continue
    
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    missing_keys = [k for k in en_translations.keys() if k not in data]
            
    if not missing_keys:
        continue
        
    print(f"Translating {len(missing_keys)} keys for {lang_code}...")
    
    for k in missing_keys:
        original_text = en_translations[k]
        try:
            translated_text = translator.translate(original_text)
            # Fix broken download URLs caused by translator
            translated_text = translated_text.replace(' https://play', 'https://play')
            data[k] = translated_text
        except Exception as e:
            print(f"Translation failed for {k} to {lang_code}: {e}")
            data[k] = original_text
        time.sleep(0.1) # Be nice to the API
            
    with open(file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Translation script complete.")
