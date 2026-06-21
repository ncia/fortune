import json

faq_en = {
  "faqQ1": "Can I read tarot every day?",
  "faqA1": "Yes, it is good to read the flow of today with a light heart. However, it is not recommended to keep drawing cards repeatedly for the same question.",
  "faqQ2": "How do I get magic dust?",
  "faqA2": "You can get magic dust through app attendance, community activities, or purchasing in the shop.",
  "faqQ3": "What should I do if the result is bad?",
  "faqA3": "Tarot is not a fixed future, but an advice. Use a bad result as a milestone to warn you of risks to avoid.",
  "faqQ4": "How can I see my past tarot readings?",
  "faqA4": "You can review your saved reading records by date in the 'Diary' (Calendar) tab at the bottom menu anytime.",
  "faqQ5": "How do I share to the community?",
  "faqA5": "Turn on the 'Share to Community' switch on the diary detail screen saved in the diary to share your reading with other users.",
  "faqQ6": "How can I change my nickname or profile?",
  "faqA6": "You can change your nickname and icon anytime by touching the profile area at the top of the 'My Menu' tab.",
  "faqQ7": "Where can I turn notifications on and off?",
  "faqA7": "You can control notifications from your device's settings app, or from the preferences menu to be updated in the future.",
  "faqQ8": "Can I see other people's tarot diaries?",
  "faqA8": "Yes, you can view and cheer for interesting tarot readings that other wizards (users) have made public in the 'Community' tab at the bottom."
}

faq_ko = {
  "faqQ1": "매일 타로를 봐도 되나요?",
  "faqA1": "네, 가벼운 마음으로 오늘의 흐름을 읽는 것은 좋습니다. 다만 같은 질문으로 계속 반복해서 뽑는 것은 권장하지 않아요.",
  "faqQ2": "마력의 가루는 어떻게 획득하나요?",
  "faqA2": "앱 출석, 커뮤니티 활동, 혹은 상점 구매를 통해 얻을 수 있습니다.",
  "faqQ3": "결과가 안 좋게 나오면 어떻게 해야 하나요?",
  "faqA3": "타로는 정해진 미래가 아닌 조언일 뿐입니다. 안 좋은 결과는 오히려 피해야 할 위험을 미리 알려주는 이정표로 삼으세요.",
  "faqQ4": "과거의 타로 리딩 기록은 어떻게 보나요?",
  "faqA4": "하단 메뉴의 '다이어리(달력)' 탭에서 날짜별로 저장된 리딩 기록을 언제든 다시 볼 수 있습니다.",
  "faqQ5": "커뮤니티 공유는 어떻게 하나요?",
  "faqA5": "다이어리에 저장된 일기 상세 화면에서 '커뮤니티 공개' 스위치를 켜면 다른 사용자들과 리딩을 나눌 수 있습니다.",
  "faqQ6": "내 닉네임이나 프로필은 어떻게 변경하나요?",
  "faqA6": "'마이 메뉴' 탭 상단의 프로필 영역을 터치하시면 언제든지 닉네임과 아이콘을 변경할 수 있습니다.",
  "faqQ7": "알림 설정은 어디서 끄고 켤 수 있나요?",
  "faqA7": "기기의 설정 앱에서 알림을 제어하거나, 향후 업데이트될 환경설정 메뉴에서 제어할 수 있습니다.",
  "faqQ8": "다른 사람의 타로 일기도 볼 수 있나요?",
  "faqA8": "네, 하단의 '커뮤니티' 탭에서 다른 마법사(사용자)들이 공개 설정한 흥미로운 타로 리딩들을 구경하고 응원할 수 있습니다."
}

for file_path, new_keys in [("lib/l10n/app_en.arb", faq_en), ("lib/l10n/app_ko.arb", faq_ko)]:
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    data.update(new_keys)
    
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

print("Updated app_en.arb and app_ko.arb successfully.")
