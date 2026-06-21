import json

en_keys = {
  "diaryViewList": "List View",
  "diaryViewCalendar": "Calendar View"
}

ko_keys = {
  "diaryViewList": "리스트 보기",
  "diaryViewCalendar": "캘린더 보기"
}

with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)
with open('lib/l10n/app_ko.arb', 'r', encoding='utf-8') as f:
    ko_data = json.load(f)

for k, v in en_keys.items():
    en_data[k] = v

for k, v in ko_keys.items():
    ko_data[k] = v

with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en_data, f, ensure_ascii=False, indent=2)
with open('lib/l10n/app_ko.arb', 'w', encoding='utf-8') as f:
    json.dump(ko_data, f, ensure_ascii=False, indent=2)

print('Updated app_en.arb and app_ko.arb with diary view keys.')
