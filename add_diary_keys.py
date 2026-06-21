import json

new_keys_ko = {
    "diaryEmpty": "아직 작성된 일기가 없습니다.\n오늘의 점괘를 확인하고 일기를 남겨보세요!",
    "diaryTarotConsult": "타로 상담",
    "diaryTarotReading": "타로 리딩",
    "diaryAndMore": "외 {count}장",
    "@diaryAndMore": {"placeholders": {"count": {"type": "int"}}},
    "diaryDaysAgo": "{days}일 전",
    "@diaryDaysAgo": {"placeholders": {"days": {"type": "int"}}},
    "diaryHoursAgo": "{hours}시간 전",
    "@diaryHoursAgo": {"placeholders": {"hours": {"type": "int"}}},
    "diaryMinutesAgo": "{minutes}분 전",
    "@diaryMinutesAgo": {"placeholders": {"minutes": {"type": "int"}}},
    "diaryJustNow": "방금 전",
    "diaryNoEntryForDate": "이 날짜에는 점괘 기록이 없습니다.",
    "diaryMyQuestion": "나의 질문",
    "diaryWitchReading": "의 타로점",
    "diaryNoResult": "결과가 없습니다.",
    "diaryFollowUpTitle": "후일담 메모",
    "diaryFollowUpHint": "점괘가 맞았는지, 결과는 어땠는지 며칠 뒤에 기록해보세요.",
    "diaryFollowUpPlaceholder": "그때 본 점괘의 결과는 어땠나요?",
    "diaryFollowUpSave": "후일담 저장",
    "diaryFollowUpSaved": "후일담이 저장되었습니다!",
    "diaryFollowUpEdit": "후일담 수정",
    "diaryTagTitle": "태그",
    "diaryTagAddHint": "새 태그 입력",
    "diaryTagDeleteConfirm": "이 태그를 삭제하시겠습니까?",
    "diaryTagDelete": "삭제",
    "diaryDeleteTitle": "일기 삭제",
    "diaryDeleteConfirm": "이 일기를 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.",
}

new_keys_en = {
    "diaryEmpty": "No diary entries yet.\nCheck your fortune today and leave a diary!",
    "diaryTarotConsult": "Tarot Consultation",
    "diaryTarotReading": "Tarot Reading",
    "diaryAndMore": "and {count} more",
    "@diaryAndMore": {"placeholders": {"count": {"type": "int"}}},
    "diaryDaysAgo": "{days}d ago",
    "@diaryDaysAgo": {"placeholders": {"days": {"type": "int"}}},
    "diaryHoursAgo": "{hours}h ago",
    "@diaryHoursAgo": {"placeholders": {"hours": {"type": "int"}}},
    "diaryMinutesAgo": "{minutes}m ago",
    "@diaryMinutesAgo": {"placeholders": {"minutes": {"type": "int"}}},
    "diaryJustNow": "Just now",
    "diaryNoEntryForDate": "No reading records for this date.",
    "diaryMyQuestion": "My Question",
    "diaryWitchReading": "'s Tarot Reading",
    "diaryNoResult": "No results available.",
    "diaryFollowUpTitle": "Follow-up Note",
    "diaryFollowUpHint": "Record whether the reading was accurate a few days later.",
    "diaryFollowUpPlaceholder": "How did the reading turn out?",
    "diaryFollowUpSave": "Save Follow-up",
    "diaryFollowUpSaved": "Follow-up saved!",
    "diaryFollowUpEdit": "Edit Follow-up",
    "diaryTagTitle": "Tags",
    "diaryTagAddHint": "Enter new tag",
    "diaryTagDeleteConfirm": "Delete this tag?",
    "diaryTagDelete": "Delete",
    "diaryDeleteTitle": "Delete Diary",
    "diaryDeleteConfirm": "Delete this diary entry? This cannot be undone.",
}

# Update Korean ARB
with open("lib/l10n/app_ko.arb", "r", encoding="utf-8") as f:
    ko = json.load(f)
ko.update(new_keys_ko)
with open("lib/l10n/app_ko.arb", "w", encoding="utf-8") as f:
    json.dump(ko, f, ensure_ascii=False, indent=2)

# Update English ARB
with open("lib/l10n/app_en.arb", "r", encoding="utf-8") as f:
    en = json.load(f)
en.update(new_keys_en)
with open("lib/l10n/app_en.arb", "w", encoding="utf-8") as f:
    json.dump(en, f, ensure_ascii=False, indent=2)

print(f"Done! Added {len([k for k in new_keys_ko if not k.startswith('@')])} new keys")
