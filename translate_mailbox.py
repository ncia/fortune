import json
import glob
import os
import time
from deep_translator import GoogleTranslator

en_translations = {
    "menuSectionNews": "News & Notifications",
    "menuMailboxTitle": "Mailbox",
    "menuMailboxSubtitle": "Check new updates and gifts",
    "mailboxTitle": "Mailbox",
    "mailboxAllRewardsClaimed": "All rewards claimed.",
    "mailboxClaimAll": "Claim All",
    "mailboxEmpty": "Mailbox is empty.",
    "mailboxSenderAndDate": "From: {sender} • {date}",
    "mailboxClaimed": "Claimed",
    "mailboxClaim": "Claim",
    "mailboxAttachedRewards": "Attached Rewards",
    "mailboxRewardClaimed": "Reward claimed.",
    "mailboxClaimReward": "Claim Reward"
}

ko_translations = {
    "menuSectionNews": "소식 및 알림",
    "menuMailboxTitle": "우편함",
    "menuMailboxSubtitle": "새로운 소식과 선물을 확인하세요",
    "mailboxTitle": "우편함",
    "mailboxAllRewardsClaimed": "모든 보상을 수령했습니다.",
    "mailboxClaimAll": "모두 받기",
    "mailboxEmpty": "우편함이 비어있습니다.",
    "mailboxSenderAndDate": "보낸사람: {sender} • {date}",
    "mailboxClaimed": "수령 완료",
    "mailboxClaim": "받기",
    "mailboxAttachedRewards": "첨부 보상",
    "mailboxRewardClaimed": "보상을 수령했습니다.",
    "mailboxClaimReward": "보상 받기"
}

metadata = {
    "@mailboxSenderAndDate": {
        "placeholders": {
            "sender": {
                "type": "String"
            },
            "date": {
                "type": "String"
            }
        }
    }
}

# Update en.arb
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)
for k, v in en_translations.items():
    en_data[k] = v
en_data.update(metadata)
with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en_data, f, ensure_ascii=False, indent=2)

# Update ko.arb
with open('lib/l10n/app_ko.arb', 'r', encoding='utf-8') as f:
    ko_data = json.load(f)
for k, v in ko_translations.items():
    ko_data[k] = v
ko_data.update(metadata)
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
            # We skip translating placeholders carefully.
            # deep_translator might break {sender} into { sender }.
            # We'll just replace after translation if needed, or translate piece by piece.
            # But deep_translator usually preserves {xxx} tags well if we're lucky.
            translated_text = translator.translate(original_text)
            
            # fix broken placeholders
            translated_text = translated_text.replace('{ sender }', '{sender}').replace('{ date }', '{date}')
            translated_text = translated_text.replace('{Sender}', '{sender}').replace('{Date}', '{date}')
            
            data[k] = translated_text
        except Exception as e:
            print(f"Translation failed for {k} to {lang_code}: {e}")
            data[k] = original_text
        time.sleep(0.1) # Be nice to the API
        
    data.update(metadata)
    with open(file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Translation script complete.")
