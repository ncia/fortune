import json
import glob
import os
import urllib.request
import urllib.parse
from concurrent.futures import ThreadPoolExecutor, as_completed

def translate_text(text, target_lang):
    try:
        url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={target_lang}&dt=t&q={urllib.parse.quote(text)}"
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=10) as response:
            result = json.loads(response.read().decode())
            translated = "".join([s[0] for s in result[0] if s[0]])
            return translated
    except Exception as e:
        print(f"  Translation error ({target_lang}): {e}")
        return text

# Keys to translate (simple strings only, no placeholders)
simple_keys = {
    "diaryEmpty": "No diary entries yet.\nCheck your fortune today and leave a diary!",
    "diaryTarotConsult": "Tarot Consultation",
    "diaryTarotReading": "Tarot Reading",
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

# Keys with placeholders - translate template then restore placeholder
placeholder_keys = {
    "diaryAndMore": ("and {count} more", "{count}"),
    "diaryDaysAgo": ("{days}d ago", "{days}"),
    "diaryHoursAgo": ("{hours}h ago", "{hours}"),
    "diaryMinutesAgo": ("{minutes}m ago", "{minutes}"),
}

placeholder_meta = {
    "diaryAndMore": {"@diaryAndMore": {"placeholders": {"count": {"type": "int"}}}},
    "diaryDaysAgo": {"@diaryDaysAgo": {"placeholders": {"days": {"type": "int"}}}},
    "diaryHoursAgo": {"@diaryHoursAgo": {"placeholders": {"hours": {"type": "int"}}}},
    "diaryMinutesAgo": {"@diaryMinutesAgo": {"placeholders": {"minutes": {"type": "int"}}}},
}

arb_to_google = {
    "ar": "ar", "be": "be", "bg": "bg", "ca": "ca", "cs": "cs",
    "da": "da", "de": "de", "el": "el", "es": "es", "et": "et",
    "fa": "fa", "fi": "fi", "fr": "fr", "hi": "hi", "hr": "hr",
    "hu": "hu", "hy": "hy", "id": "id", "it": "it", "ja": "ja",
    "lt": "lt", "lv": "lv", "ml": "ml", "ms": "ms", "no": "no",
    "pl": "pl", "pt": "pt", "rm": "rm", "ro": "ro", "ru": "ru",
    "sk": "sk", "sl": "sl", "sr": "sr", "sv": "sv", "th": "th",
    "tl": "tl", "tr": "tr", "uk": "uk", "vi": "vi", "zh": "zh-TW",
}

def process_arb(arb_path, lang_code):
    google_lang = arb_to_google.get(lang_code)
    if not google_lang:
        return lang_code, "skipped"
    
    with open(arb_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    changed = 0
    
    # Simple keys
    for key, en_text in simple_keys.items():
        if key not in data or data[key] == en_text:
            translated = translate_text(en_text, google_lang)
            data[key] = translated
            changed += 1
    
    # Placeholder keys
    for key, (en_text, placeholder) in placeholder_keys.items():
        if key not in data or data[key] == en_text:
            marker = "PLACEHOLDER_MARKER"
            temp_text = en_text.replace(placeholder, marker)
            translated = translate_text(temp_text, google_lang)
            translated = translated.replace(marker, placeholder)
            # Also handle common translation artifacts
            translated = translated.replace("PLACEHOLDER _MARKER", placeholder)
            translated = translated.replace("PLACEHOLDER_Marker", placeholder)
            data[key] = translated
            changed += 1
        # Add meta
        meta = placeholder_meta.get(key, {})
        data.update(meta)
    
    with open(arb_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    return lang_code, changed

# Process all ARBs except ko and en
arb_files = glob.glob("lib/l10n/app_*.arb")
tasks = []

for arb_path in arb_files:
    basename = os.path.basename(arb_path)
    lang_code = basename.replace("app_", "").replace(".arb", "")
    if lang_code in ("ko", "en", "zh_Hans", "zh_Hant"):
        if lang_code == "zh_Hans":
            tasks.append((arb_path, "zh_Hans"))
        elif lang_code == "zh_Hant":
            tasks.append((arb_path, "zh_Hant"))
        continue
    tasks.append((arb_path, lang_code))

# Handle zh_Hans and zh_Hant separately
def process_chinese(arb_path, variant):
    google_lang = "zh-CN" if variant == "zh_Hans" else "zh-TW"
    with open(arb_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    changed = 0
    for key, en_text in simple_keys.items():
        if key not in data or data[key] == en_text:
            translated = translate_text(en_text, google_lang)
            data[key] = translated
            changed += 1
    
    for key, (en_text, placeholder) in placeholder_keys.items():
        if key not in data or data[key] == en_text:
            marker = "PLACEHOLDER_MARKER"
            temp_text = en_text.replace(placeholder, marker)
            translated = translate_text(temp_text, google_lang)
            translated = translated.replace(marker, placeholder)
            translated = translated.replace("PLACEHOLDER _MARKER", placeholder)
            data[key] = translated
            changed += 1
        meta = placeholder_meta.get(key, {})
        data.update(meta)
    
    with open(arb_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    return variant, changed

print("Starting translation of diary keys to all languages...")

with ThreadPoolExecutor(max_workers=5) as executor:
    futures = []
    for arb_path, lang_code in tasks:
        if lang_code in ("zh_Hans", "zh_Hant"):
            futures.append(executor.submit(process_chinese, arb_path, lang_code))
        elif lang_code not in ("ko", "en"):
            futures.append(executor.submit(process_arb, arb_path, lang_code))
    
    for future in as_completed(futures):
        lang, count = future.result()
        print(f"  {lang}: {count} keys translated")

print("All translations complete!")
