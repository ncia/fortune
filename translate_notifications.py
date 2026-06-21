import json
import glob
import os
import time
from deep_translator import GoogleTranslator

en_translations = {
    "menuNotificationCenterTitle": "Notification Center",
    "menuNotificationCenterSubtitle": "Check latest notifications and announcements"
}

ko_translations = {
    "menuNotificationCenterTitle": "알림 센터",
    "menuNotificationCenterSubtitle": "최신 알림 및 공지사항을 확인하세요"
}

# Update en.arb
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)
for k, v in en_translations.items():
    en_data[k] = v
with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en_data, f, ensure_ascii=False, indent=2)

# Update ko.arb
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
            data[k] = translated_text
        except Exception as e:
            print(f"Translation failed for {k} to {lang_code}: {e}")
            data[k] = original_text
        time.sleep(0.1) # Be nice to the API
        
    with open(file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Notification translation script complete.")
