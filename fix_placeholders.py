import json
import glob
import re

files = glob.glob('lib/l10n/app_*.arb')
for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    modified = False
    if 'googleLoginError' in data:
        val = data['googleLoginError']
        # replace any {xxx} with {error}
        new_val = re.sub(r'\{[^\}]+\}', '{error}', val)
        if new_val != val:
            data['googleLoginError'] = new_val
            modified = True
            
    if modified:
        with open(file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Fixed {file}")
