import os
import json
import requests
from pathlib import Path

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
    'growthMagicBookLevel': 'Magic Book Level {level}',
    'growthMagicBookKnowledge': 'Knowledge: {current} / {max}',
    'growthCrystalBallMana': 'Mana: {current} / {max}',
    'growthMagicBookExpGained': 'The magic book\'s knowledge has deepened! Exp +{amount}',
    'growthUpgradeMagicBookButton': 'Upgrade Magic Book ({amount} Dust)',
    'devDustCharged': 'Dev: 1000 Magic Dust charged!'
}

l10n_dir = Path('lib/l10n')
for file_path in l10n_dir.glob('*.arb'):
    filename = file_path.name
    lang_code = filename.replace('app_', '').replace('.arb', '')
    print(f"Processing {lang_code}...")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        try:
            arb_data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error parsing {filename}, skipping")
            continue
            
    # Add metadata for placeholders
    if '@growthMagicBookLevel' not in arb_data:
        arb_data['@growthMagicBookLevel'] = {
            "placeholders": {"level": {"type": "int"}}
        }
    if '@growthMagicBookKnowledge' not in arb_data:
        arb_data['@growthMagicBookKnowledge'] = {
            "placeholders": {"current": {"type": "int"}, "max": {"type": "int"}}
        }
    if '@growthCrystalBallMana' not in arb_data:
        arb_data['@growthCrystalBallMana'] = {
            "placeholders": {"current": {"type": "int"}, "max": {"type": "int"}}
        }
    if '@growthMagicBookExpGained' not in arb_data:
        arb_data['@growthMagicBookExpGained'] = {
            "placeholders": {"amount": {"type": "int"}}
        }
    if '@growthUpgradeMagicBookButton' not in arb_data:
        arb_data['@growthUpgradeMagicBookButton'] = {
            "placeholders": {"amount": {"type": "int"}}
        }
        
    batch = {}
    for key, value in keys_to_translate.items():
        if key not in arb_data or arb_data[key] == '':
            batch[key] = value
            
    if batch:
        prompt = f"""
You are a professional localization expert. Translate the following JSON object's values into the language corresponding to the locale code "{lang_code}".
If the locale is 'ko', translate them to natural Korean exactly as follows:
'growthMagicBookLevel' -> '마법책 레벨 {{level}}'
'growthMagicBookKnowledge' -> '지식: {{current}} / {{max}}'
'growthCrystalBallMana' -> '마력: {{current}} / {{max}}'
'growthMagicBookExpGained' -> '마법책의 지식이 깊어졌습니다! Exp +{{amount}}'
'growthUpgradeMagicBookButton' -> '마법책 강화 (가루 {{amount}}개)'
'devDustCharged' -> '개발용: 마력의 가루 1000개 충전 완료!'

Keep placeholders like {{{{level}}}}, {{{{current}}}}, {{{{max}}}}, and {{{{amount}}}} exactly as they are. Keep emojis if any.
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
    else:
        print(f"No updates needed for {filename}")
