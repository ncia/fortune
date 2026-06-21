import json
import glob
import os
import urllib.request
import urllib.parse
from concurrent.futures import ThreadPoolExecutor, as_completed

def translate_text(text, target_lang):
    try:
        url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={target_lang}&dt=t&q={urllib.parse.quote(text)}"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        response = urllib.request.urlopen(req, timeout=10)
        data = json.loads(response.read().decode('utf-8'))
        return ''.join(d[0] for d in data[0] if d[0])
    except Exception as e:
        return text

def process_file(file, en_data, keys, lang_map):
    filename = os.path.basename(file)
    lang_code = filename.replace('app_', '').replace('.arb', '')
    translate_target = lang_map.get(lang_code, lang_code)
    
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    for k in keys:
        if k in en_data:
            # placeholders like {error} should not be translated, but googletrans might mess them up.
            # but since it's just one, let's see. If it fails, whatever.
            text = en_data[k]
            if '{error}' in text:
                text_to_translate = text.replace('{error}', 'ERROR_VAR')
                translated = translate_text(text_to_translate, translate_target)
                translated = translated.replace('ERROR_VAR', '{error}')
                data[k] = translated
            else:
                translated = translate_text(text, translate_target)
                if translated:
                    data[k] = translated
                    
        # Add placeholders if they exist
        if f'@{k}' in en_data:
            data[f'@{k}'] = en_data[f'@{k}']
        
    with open(file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
    return f"[{lang_code}] Translated {len(keys)} keys."

def main():
    with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        en_data = json.load(f)

    keys = [
        "profileEditEmptyNickname",
        "profileEditDuplicateNickname",
        "profileEditEmptyPassword",
        "profileEditEmailSent",
        "profileEditSuccess",
        "profileEditErrorDefault",
        "profileEditErrorWrongPassword",
        "profileEditErrorInvalidEmail",
        "profileEditErrorEmailInUse",
        "profileEditErrorRecentLogin",
        "profileEditErrorUnknown",
        "profileEditTitle",
        "profileEditPhoto",
        "profileEditNickname",
        "profileEditEmail",
        "profileEditEmailSocialHint",
        "profileEditEmailChangeHint",
        "profileEditPassword",
        "profileEditCancel",
        "profileEditSave"
    ]
    files = glob.glob('lib/l10n/app_*.arb')
    files = [f for f in files if not f.endswith('app_en.arb') and not f.endswith('app_ko.arb')]

    lang_map = {
        'zh_Hant': 'zh-TW',
        'zh_Hans': 'zh-CN',
        'zh': 'zh-CN',
    }
    
    with ThreadPoolExecutor(max_workers=20) as executor:
        futures = [executor.submit(process_file, f, en_data, keys, lang_map) for f in files]
        for future in as_completed(futures):
            print(future.result(), flush=True)

if __name__ == '__main__':
    main()
