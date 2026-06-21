import json
import glob
import os
import time
from deep_translator import GoogleTranslator
import concurrent.futures

faq_keys = ['myMenuContactUsSubtitle']

with open("lib/l10n/app_en.arb", "r", encoding="utf-8") as f:
    en_data = json.load(f)

en_translations = {k: en_data[k] for k in faq_keys if k in en_data}

def process_file(file):
    lang_code = os.path.basename(file).replace('app_', '').replace('.arb', '')
    if lang_code == 'zh_Hans':
        lang_code = 'zh-CN'
    elif lang_code == 'zh_Hant':
        lang_code = 'zh-TW'
    elif lang_code == 'he':
        lang_code = 'iw'
        
    try:
        translator = GoogleTranslator(source='en', target=lang_code)
    except Exception as e:
        print(f"Skipping {lang_code}: {e}")
        return
        
    print(f"[{lang_code}] Starting Subtitle translation...")
    
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    modified = False
    for key, text in en_translations.items():
        try:
            translated = translator.translate(text)
            data[key] = translated
            modified = True
            time.sleep(0.3)
        except Exception as e:
            print(f"[{lang_code}] Translation failed for {key}: {e}")
            
    if modified:
        with open(file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"[{lang_code}] Completed and saved.")
    else:
        print(f"[{lang_code}] Already up-to-date.")

def main():
    arb_files = glob.glob('lib/l10n/app_*.arb')
    arb_files = [f for f in arb_files if not f.endswith('app_en.arb') and not f.endswith('app_ko.arb')]
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        executor.map(process_file, arb_files)
    print("Subtitle Translation script complete.")

if __name__ == '__main__':
    main()
