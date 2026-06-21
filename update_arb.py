import os
import json
import re

l10n_dir = 'c:/workspace/flutter_tarot/lib/l10n'

for filename in os.listdir(l10n_dir):
    if filename.startswith('app_') and filename.endswith('.arb'):
        filepath = os.path.join(l10n_dir, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        upright_raw = data.get('cardDetailTabUpright', '')
        reversed_raw = data.get('cardDetailTabReversed', '')
        
        # Extract the translated part
        def extract(text, prefix):
            if text.startswith(prefix + ' ('):
                return text[len(prefix) + 2 : -1]
            return text
            
        upright_val = extract(upright_raw, '정방향')
        reversed_val = extract(reversed_raw, '역방향')
        
        if filename == 'app_en.arb':
            data['spreadUpright'] = 'Upright'
            data['spreadReversed'] = 'Reversed'
        elif filename == 'app_ko.arb':
            data['spreadUpright'] = '정방향 (Upright)'
            data['spreadReversed'] = '역방향 (Reversed)'
        else:
            data['spreadUpright'] = f'{upright_val} (Upright)'
            data['spreadReversed'] = f'{reversed_val} (Reversed)'
            
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

print("Done updating all arb files!")
