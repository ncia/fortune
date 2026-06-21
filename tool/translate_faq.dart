import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  String? apiKey;
  try {
    final envContent = await File('.env').readAsString();
    for (var line in envContent.split('\n')) {
      if (line.startsWith('GEMINI_API_KEY=')) {
        apiKey = line.substring('GEMINI_API_KEY='.length).trim();
        break;
      }
    }
  } catch (e) {
    print('Could not read .env: $e');
  }

  if (apiKey == null || apiKey.isEmpty) {
    print('Error: GEMINI_API_KEY not found in .env');
    return;
  }

  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
  );

  final l10nDir = Directory('lib/l10n');
  final arbFiles = l10nDir.listSync().where((f) => f.path.endsWith('.arb')).toList();

  final koArbContent = await File('lib/l10n/app_ko.arb').readAsString();
  final Map<String, dynamic> koArb = jsonDecode(koArbContent);

  final List<String> modifiedKeys = [
    'faqA2', 'faqA4', 'faqA5', 'faqA6', 'faqA7', 'faqA8', 'faqA9', 'faqA11', 'faqQ13', 'faqA13'
  ];

  final Map<String, String> keysToTranslate = {};
  koArb.forEach((key, value) {
    if (modifiedKeys.contains(key) && value is String) {
      keysToTranslate[key] = value;
    }
  });

  print('Found ${keysToTranslate.length} FAQ keys to translate.');

  for (var file in arbFiles) {
    final fileName = file.uri.pathSegments.last;
    if (fileName == 'app_ko.arb') continue;
    
    final langCode = fileName.replaceAll('app_', '').replaceAll('.arb', '');
    print('Translating for $langCode...');
    
    try {
      final fileContent = await File(file.path).readAsString();
      Map<String, dynamic> arbJson = jsonDecode(fileContent);
      
      bool needsUpdate = false;
      
      Map<String, String> batchToTranslate = {};
      for (var key in keysToTranslate.keys) {
        batchToTranslate[key] = keysToTranslate[key]!;
      }
      
      if (batchToTranslate.isNotEmpty) {
        final prompt = '''
You are a professional localization expert. Translate the following JSON object's values into the language corresponding to the locale code "$langCode".
Keep placeholders exactly as they are. Keep emojis. Keep \\n as \\n.
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
        }
      }
      
      if (needsUpdate) {
        final encoder = JsonEncoder.withIndent('  ');
        String output = encoder.convert(arbJson);
        output = output.replaceAllMapped(RegExp(r'\\u([0-9a-fA-F]{4})'), (Match m) {
          return String.fromCharCode(int.parse(m.group(1)!, radix: 16));
        });
        await File(file.path).writeAsString(output);
      }
    } catch (e) {
      print('Error processing $fileName: $e');
    }
  }
}
