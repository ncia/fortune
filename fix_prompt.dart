import 'dart:convert';
import 'dart:io';

void main() {
  var file = File('lib/services/tarot_ai_service.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    "* IMPORTANT: You MUST answer strictly in the language represented by the ISO 639-1 locale code '\$localeCode'. Do not mix languages.",
    "* **CRITICAL INSTRUCTION**: Your entire response MUST be translated into the language corresponding to the locale code '\$localeCode' (e.g. if 'ja', use Japanese. if 'th', use Thai. if 'ko', use Korean. if 'en', use English). DO NOT respond in English or Korean unless the locale matches."
  );
  file.writeAsStringSync(content);
  print('done');
}
