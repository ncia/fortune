import os
import json
import glob

files = glob.glob("lib/l10n/app_*.arb")
for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    if 'growthUpgradeButtonCost' not in data:
        if file.endswith('app_ko.arb'):
            data['growthUpgradeButtonCost'] = "수정구 강화 (가루 {amount}개)"
        else:
            data['growthUpgradeButtonCost'] = "Upgrade Crystal Ball ({amount} Dust)"
            
        data['@growthUpgradeButtonCost'] = {
            "placeholders": {
                "amount": {
                    "type": "int"
                }
            }
        }
        with open(file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

print("Added missing key to all arb files.")
