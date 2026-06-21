import os
import re
import json
import time
from deep_translator import GoogleTranslator

def main():
    # 1. Parse nickname_data.dart
    with open('lib/data/nickname_data.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    prefixes = re.findall(r'"([^"]+)"', content.split('nicknamePrefixes = [')[1].split('];')[0])
    suffixes = re.findall(r'"([^"]+)"', content.split('nicknameSuffixes = [')[1].split('];')[0])

    print(f'Found {len(prefixes)} prefixes and {len(suffixes)} suffixes.')

    # 2. Add them to app_ko.arb
    with open('lib/l10n/app_ko.arb', 'r', encoding='utf-8') as f:
        ko_arb = json.load(f)

    for i, p in enumerate(prefixes):
        ko_arb[f'nicknamePrefix{i}'] = p

    for i, s in enumerate(suffixes):
        ko_arb[f'nicknameSuffix{i}'] = s

    with open('lib/l10n/app_ko.arb', 'w', encoding='utf-8') as f:
        json.dump(ko_arb, f, ensure_ascii=False, indent=2)

    print('Updated app_ko.arb')

    # 3. Add to app_en.arb
    en_translator = GoogleTranslator(source='ko', target='en')
    with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        en_arb = json.load(f)

    for i, p in enumerate(prefixes):
        key = f'nicknamePrefix{i}'
        if key not in en_arb:
            try:
                en_arb[key] = en_translator.translate(p)
                print(f'Translated EN prefix: {p} -> {en_arb[key]}')
            except Exception as e:
                print(f'Error translating {p}: {e}')
                en_arb[key] = p
            time.sleep(0.1)

    for i, s in enumerate(suffixes):
        key = f'nicknameSuffix{i}'
        if key not in en_arb:
            try:
                en_arb[key] = en_translator.translate(s)
                print(f'Translated EN suffix: {s} -> {en_arb[key]}')
            except Exception as e:
                print(f'Error translating {s}: {e}')
                en_arb[key] = s
            time.sleep(0.1)

    with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
        json.dump(en_arb, f, ensure_ascii=False, indent=2)

    print('Updated app_en.arb with English translations!')

if __name__ == '__main__':
    main()
