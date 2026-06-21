import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TranslationService {
  late final GenerativeModel _model;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TranslationService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY is not defined in .env');
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  /// 번역 캐싱 확인 및 번역 수행
  /// [docRef]: 번역 결과를 저장할 Firestore 문서 참조 (CommunityPost 또는 CommunityComment)
  /// [text]: 원문 텍스트
  /// [targetLocale]: 번역할 대상 언어 코드 (예: 'en', 'ja', 'ko')
  Future<String> getOrTranslate(DocumentReference docRef, String text, String targetLocale) async {
    try {
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) return text;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final translations = data['translations'] as Map<String, dynamic>? ?? {};

      // 이미 캐시된 번역이 있다면 바로 반환
      if (translations.containsKey(targetLocale)) {
        return translations[targetLocale] as String;
      }

      // 없으면 Gemini를 이용해 번역
      final translatedText = await translateText(text, targetLocale);

      // 번역 성공 시 Firestore에 업데이트 (캐싱)
      translations[targetLocale] = translatedText;
      await docRef.update({'translations': translations});

      return translatedText;
    } catch (e) {
      print('Translation error: $e');
      return text; // 실패 시 원문 반환
    }
  }

  Future<String> translateText(String text, String targetLanguage) async {
    final prompt = '''
Translate the following text into the language with the locale code: "$targetLanguage".
Provide ONLY the translated text without any extra conversational filler, markdown formatting, or quotes.
If the text contains any special domain terms (like Tarot terms), translate them naturally.

Text to translate:
$text
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text?.trim() ?? text;
    } catch (e) {
      throw Exception('Failed to translate: $e');
    }
  }
}
