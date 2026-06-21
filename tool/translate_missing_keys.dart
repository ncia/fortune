import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    print('Error: GEMINI_API_KEY not found in .env');
    return;
  }

  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
  );

  final Map<String, String> keysToTranslate = {
    'cardDetailTabUpright': '정방향 (Upright)',
    'cardDetailTabReversed': '역방향 (Reversed)',
    'pickCardsText': '{count}장의 카드를 뽑으세요',
    'layoutFan': '부채꼴 (Fan Shape)',
    'layoutStacked': '겹친 모양 (Stacked)',
    'readingFateFragments': '운명의 조각들을 읽어내고 있어요. (Reading the fragments of destiny.)',
    'magicDustObtained': '마력의 가루 +{amount} 획득! ✨',
    'shareResultText': '✨ 내 타로 점 결과를 확인해보세요!\\n\\n자세한 점괘를 알고 싶다면, 타로 마녀 앱을 설치하고 직접 타로 점을 확인해보세요!\\n👉 다운로드: https://play.google.com/store/apps/details?id=com.ncia.tarot_card',
    'buttonShare': '공유하기 (Share)',
    'buttonSelectSpread': '스프레드 선택 (Select Spread)',
    'buttonSelectOtherWitch': '다른 마녀 선택 (Select another Witch)'
  };

  final l10nDir = Directory('lib/l10n');
  final arbFiles = l10nDir.listSync().where((f) => f.path.endsWith('.arb')).toList();

  for (var file in arbFiles) {
    final fileName = file.uri.pathSegments.last;
    if (fileName == 'app_ko.arb' || fileName == 'app_en.arb') continue;
    
    final langCode = fileName.replaceAll('app_', '').replaceAll('.arb', '');
    print('Translating for $langCode...');
    
    try {
      final fileContent = await File(file.path).readAsString();
      Map<String, dynamic> arbJson = jsonDecode(fileContent);
      
      bool needsUpdate = false;
      
      // Let's create a batch request to Gemini
      Map<String, String> batchToTranslate = {};
      for (var key in keysToTranslate.keys) {
        // If it contains Korean or question marks, we re-translate
        final currentVal = arbJson[key]?.toString() ?? '';
        final hasKorean = RegExp(r'[가-힣]').hasMatch(currentVal);
        final hasQuestionMarks = currentVal.contains('?');
        if (hasKorean || hasQuestionMarks || currentVal.isEmpty) {
          batchToTranslate[key] = keysToTranslate[key]!;
        }
      }
      
      if (batchToTranslate.isNotEmpty) {
        final prompt = '''
You are a professional localization expert. Translate the following JSON object's values into the language corresponding to the locale code "$langCode".
Keep placeholders like {count} and {amount} exactly as they are. Keep emojis. Keep \\n as \\n.
Return ONLY valid JSON format representing the translated key-value pairs, without markdown blocks.

JSON to translate:
${jsonEncode(batchToTranslate)}
''';
        final response = await model.generateContent([Content.text(prompt)]);
        String responseText = response.text ?? '{}';
        responseText = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
        
        try {
          final Map<String, dynamic> translatedObj = jsonDecode(responseText);
          for (var key in translatedObj.keys) {
            arbJson[key] = translatedObj[key];
            needsUpdate = true;
          }
        } catch (e) {
          print('Failed to parse JSON for $langCode: $e');
          print('Raw response: $responseText');
        }
      }
      
      if (needsUpdate) {
        final encoder = JsonEncoder.withIndent('  ');
        // Fix unicode escaping
        String output = encoder.convert(arbJson);
        output = output.replaceAllMapped(RegExp(r'\\u([0-9a-fA-F]{4})'), (Match m) {
          return String.fromCharCode(int.parse(m.group(1)!, radix: 16));
        });
        await File(file.path).writeAsString(output);
        print('Updated $fileName');
      } else {
        print('No updates needed for $fileName');
      }
    } catch (e) {
      print('Error processing $fileName: $e');
    }
  }
}
