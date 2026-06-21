import json
import glob
import os
import time
from deep_translator import GoogleTranslator
import concurrent.futures

# The newly added keys in English
en_translations = {
  'authSignupComplete': 'Sign up is complete. Please check the email sent to you to verify.',
  'chatInitError': 'Initialization error occurred:\n{error}',
  'chatError': 'Error occurred:\n{error}\n\n{stackTrace}',
  'chatPositionLabel': 'Position {number}',
  'communityTranslationFailed': 'Translation failed: {error}',
  'diarySelectDate': 'Select a date',
  'diarySavedSuccess': 'Diary saved successfully!',
  'diarySaveFailed': 'Failed to save diary.',
  'diaryWriteTitle': 'Write Diary',
  'diaryWriteHint': 'Feel free to write your thoughts or feelings about today\'s reading.',
  'diarySaveButton': 'Save to Diary',
  'myMenuAppVersion': 'Version {version}',
  'readingSpreadLabelToday': 'Today\'s Fortune',
  'readingSpreadLabelPast1': '1. Past',
  'readingSpreadLabelPresent2': '2. Present',
  'readingSpreadLabelFuture3': '3. Future',
  'readingSpreadLabelCurrent1': '1. Current',
  'readingSpreadLabelPast2': '2. Past',
  'readingSpreadLabelFuture3Alt': '3. Future',
  'readingSpreadLabelCause4': '4. Cause',
  'readingSpreadLabelPotential5': '5. Potential',
  'readingSpreadLabelCurrentSituation1': '1. Current situation and problem',
  'readingSpreadLabelCauseOfProblem2': '2. Cause of problem',
  'readingSpreadLabelAdviceForResolution3': '3. Advice for resolution',
  'readingSpreadLabelExpectedResult4': '4. Expected result',
  'readingSpreadLabelCurrentSituation1Alt': '1. Current situation',
  'readingSpreadLabelObstacle2': '2. Obstacle',
  'readingSpreadLabelUnconscious3': '3. Unconscious',
  'readingSpreadLabelPast4': '4. Past',
  'readingSpreadLabelConsciousGoal5': '5. Conscious Goal',
  'readingSpreadLabelNearFuture6': '6. Near Future',
  'readingSpreadLabelAttitude7': '7. Attitude',
  'readingSpreadLabelExternalEnvironment8': '8. External Environment',
  'readingSpreadLabelHopesAndFears9': '9. Hopes and Fears',
  'readingSpreadLabelFinalResult10': '10. Final Result',
  'readingSpreadLabelAdvice4': '4. Advice',
  'readingSpreadLabelSurroundings5': '5. Surroundings',
  'readingSpreadLabelResult6': '6. Result',
  'shopBonusCoins': 'Bonus {amount}',
  'shopCoins': '{amount} Coins',
  'serviceLoginRequired': 'Login is required.',
  'serviceDefaultNickname': 'Nameless Witch',
  'serviceTarotReadingError': 'An error occurred while reading the fortune: {error}',
  'defaultUserDisplayName': 'User',
  'listenToInterpretation': 'Listen to Interpretation'
}

placeholders = ['{error}', '{stackTrace}', '{number}', '{version}', '{amount}']

def process_file(file):
    lang_code = os.path.basename(file).replace('app_', '').replace('.arb', '')
    if lang_code == 'zh_Hans':
        lang_code = 'zh-CN'
    elif lang_code == 'zh_Hant':
        lang_code = 'zh-TW'
    elif lang_code == 'he':
        lang_code = 'iw'
        
    try:
        translator = GoogleTranslator(source='en', target=lang_code)
    except Exception as e:
        print(f"Skipping {lang_code}: {e}")
        return
        
    print(f"[{lang_code}] Starting translation...")
    
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    modified = False
    for key, text in en_translations.items():
        if key not in data:
            try:
                translated = translator.translate(text)
                for ph in placeholders:
                    if ph in text and ph not in translated:
                        translated = text
                data[key] = translated
                modified = True
                time.sleep(0.3)
            except Exception as e:
                print(f"[{lang_code}] Translation failed for {key}: {e}")
                data[key] = text
                modified = True
                
    if modified:
        with open(file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"[{lang_code}] Completed and saved.")
    else:
        print(f"[{lang_code}] Already up-to-date.")

def main():
    arb_files = glob.glob('lib/l10n/app_*.arb')
    arb_files = [f for f in arb_files if not f.endswith('app_en.arb') and not f.endswith('app_ko.arb')]
    
    print(f"Found {len(arb_files)} language files. Starting 5 threads...")
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        executor.map(process_file, arb_files)

    print("Translation script complete.")

if __name__ == '__main__':
    main()
