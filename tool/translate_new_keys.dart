import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey!);

  final l10nDir = Directory('lib/l10n');
  final files = l10nDir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();

  final koFile = files.firstWhere((f) => f.path.endsWith('app_ko.arb'));
  final koData = jsonDecode(koFile.readAsStringSync());

  koData['buttonShare'] = '공유하기';
  koData['buttonSelectSpread'] = '스프레드 선택';
  koData['buttonSelectOtherWitch'] = '다른 마녀 선택';
  koData['shareResultText'] = '🔮 내 타로 점괘 결과를 확인해보세요!\\n\\n자세한 점괘 내용이 궁금하다면 타로마녀 앱을 설치해서 직접 타로 점을 확인해 보세요!\\n👉 다운로드: https://play.google.com/store/apps/details?id=com.ncia.tarot_card';

  final encoder = JsonEncoder.withIndent('  ');
  koFile.writeAsStringSync(encoder.convert(koData));

  for (var file in files) {
    if (file.path.endsWith('app_ko.arb')) continue;
    final lang = file.path.split('app_')[1].split('.arb')[0];
    final data = jsonDecode(file.readAsStringSync());
    
    if (data.containsKey('buttonShare') && data.containsKey('buttonSelectSpread')) {
      continue;
    }

    print('Translating for $lang...');
    final prompt = '''
Translate the following JSON values from Korean to the language corresponding to ISO code '$lang'.
Keep the keys exactly as they are.
Return ONLY valid JSON. Do not return markdown blocks like ```json.
{
  "buttonShare": "공유하기",
  "buttonSelectSpread": "스프레드 선택",
  "buttonSelectOtherWitch": "다른 마녀 선택",
  "shareResultText": "🔮 내 타로 점괘 결과를 확인해보세요!\\n\\n자세한 점괘 내용이 궁금하다면 타로마녀 앱을 설치해서 직접 타로 점을 확인해 보세요!\\n👉 다운로드: https://play.google.com/store/apps/details?id=com.ncia.tarot_card"
}
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      var text = response.text!.trim();
      if (text.startsWith('```json')) text = text.substring(7);
      if (text.startsWith('```')) text = text.substring(3);
      if (text.endsWith('```')) text = text.substring(0, text.length - 3);
      
      final translated = jsonDecode(text.trim());
      data['buttonShare'] = translated['buttonShare'];
      data['buttonSelectSpread'] = translated['buttonSelectSpread'];
      data['buttonSelectOtherWitch'] = translated['buttonSelectOtherWitch'];
      data['shareResultText'] = translated['shareResultText'];
      
      file.writeAsStringSync(encoder.convert(data));
      print('Saved $lang');
    } catch (e) {
      print('Error on $lang: $e');
    }
  }
}
