import json
import glob
import os
import time
from deep_translator import GoogleTranslator
from deep_translator.exceptions import RequestError

def merge_extra(main_file, extra_file):
    with open(main_file, 'r', encoding='utf-8') as f:
        main_data = json.load(f)
    with open(extra_file, 'r', encoding='utf-8') as f:
        extra_data = json.load(f)
    
    for k, v in extra_data.items():
        main_data[k] = v
    
    with open(main_file, 'w', encoding='utf-8') as f:
        json.dump(main_data, f, ensure_ascii=False, indent=2)
    return main_data

# merge_extra('lib/l10n/app_en.arb', 'lib/l10n/app_en_extra.json')
# en_data = merge_extra('lib/l10n/app_ko.arb', 'lib/l10n/app_ko_extra.json')

with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

# Build a translation queue
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
        
    missing_keys = []
    for k in en_data.keys():
        if k not in data and not k.startswith('@@'):
            missing_keys.append(k)
            
    if not missing_keys:
        continue
        
    print(f"Translating {len(missing_keys)} keys for {lang_code}...")
    
    for k in missing_keys:
        if k.startswith('@'):
            data[k] = en_data[k]
        else:
            original_text = en_data[k]
            # Handle {placeholders} by replacing them temporarily or just translating directly.
            # Google Translate usually handles {placeholders} okay if they are in curly braces.
            try:
                translated_text = translator.translate(original_text)
                data[k] = translated_text
            except Exception as e:
                print(f"Translation failed for {k} to {lang_code}: {e}")
                data[k] = original_text
            time.sleep(0.1) # Be nice to the API
            
    with open(file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Translation script complete.")
