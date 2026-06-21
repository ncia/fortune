import os
import json
import requests
from pathlib import Path

# load .env
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
    'growthPhaseFormat': '[{level} Phase: {name}]',
    'growthTabMagicBook': 'Magic Book Upgrade',
    'growthPhaseCrystal0': 'Abyssal Magic',
    'growthPhaseCrystal1': 'Opening the Spirit Eye',
    'growthPhaseCrystal2': 'Wisdom of Mother Nature',
    'growthPhaseCrystal3': 'Essence of the Sun',
    'growthPhaseCrystal4': 'Celestial Aurora',
    'growthPhaseCrystal5': 'Divine Realm',
    'growthPhaseCrystal6': 'Magic of Creation',
    'growthPhaseCrystal7': 'Breath of the Universe',
    'growthPhaseCrystal8': 'Eternal Light',
    'growthPhaseCrystal9': 'Pure White Awakening',
    'growthPhaseCrystal10': 'Transcendence',
    'growthPhaseBook0': 'Apprentice\'s Writing Tools',
    'growthPhaseBook1': 'Basic Magic Primer',
    'growthPhaseBook2': 'Ancient Rune Grammar',
    'growthPhaseBook3': 'Understanding Elemental Magic',
    'growthPhaseBook4': 'Harmony of Starlight',
    'growthPhaseBook5': 'Artifact Deciphering',
    'growthPhaseBook6': 'Forbidden Book of the Sage',
    'growthPhaseBook7': 'Communion with Spirits',
    'growthPhaseBook8': 'Grimoire of Truth',
    'growthPhaseBook9': 'Omnipotent Record'
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
            
    # Add metadata for growthPhaseFormat if it doesn't exist
    if '@growthPhaseFormat' not in arb_data:
        arb_data['@growthPhaseFormat'] = {
            "placeholders": {
                "level": {"type": "int"},
                "name": {"type": "String"}
            }
        }
        
    batch = {}
    for key, value in keys_to_translate.items():
        if key not in arb_data or arb_data[key] == '':
            batch[key] = value
            
    if batch:
        prompt = f"""
You are a professional localization expert. Translate the following JSON object's values into the language corresponding to the locale code "{lang_code}".
If the locale is 'ko', translate them to natural Korean (e.g., 'growthPhaseCrystal0' -> '심연의 마력', 'growthPhaseFormat' -> '[{{level}}단계: {{name}}]', 'growthTabMagicBook' -> '마법책 강화').
Keep placeholders like {{{{level}}}} and {{{{name}}}} exactly as they are. Keep emojis if any. Keep \\n as \\n.
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
            if 'response_json' in locals():
                print(response_json)
    else:
        print(f"No updates needed for {filename}")
