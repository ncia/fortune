import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TarotAiService {
  late final GenerativeModel _model;

  TarotAiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY is not defined in .env');
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  String _getLanguageName(String localeCode) {
    switch (localeCode.split('_')[0]) {
      case 'ja': return 'Japanese';
      case 'ko': return 'Korean';
      case 'en': return 'English';
      case 'zh': return 'Chinese';
      case 'th': return 'Thai';
      case 'vi': return 'Vietnamese';
      case 'es': return 'Spanish';
      case 'fr': return 'French';
      case 'de': return 'German';
      case 'id': return 'Indonesian';
      case 'pt': return 'Portuguese';
      case 'ru': return 'Russian';
      case 'ar': return 'Arabic';
      case 'hi': return 'Hindi';
      case 'tr': return 'Turkish';
      case 'it': return 'Italian';
      case 'pl': return 'Polish';
      default: return localeCode;
    }
  }

  Stream<String> getTarotReadingStream(String question, List<String> cards, String personalityPrompt, String localeCode) async* {
    final langName = _getLanguageName(localeCode);
    final prompt = '''
$personalityPrompt
위의 페르소나(성격, 말투, 화법)를 **절대적으로 유지**하면서 아래 타로 리딩을 진행해 주세요. 말투와 분위기가 캐릭터에 맞춰 확연하게 달라야 합니다.

[내담자의 고민]
$question

[뽑은 타로 카드 ${cards.length}장 (이름 및 방향)]
${cards.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

이 ${cards.length}장의 카드의 의미를 연결하여 내담자의 고민에 대한 타로 리딩 결과를 제공해 주세요.
* 정통 라이더 웨이트 해석(정방향/역방향)을 기반으로 하되, **반드시 당신의 페르소나 성격에 맞는 방식**으로 결과를 전달하세요. (예: 다정한 성격이면 부드러운 위로를, 차가운 성격이면 객관적이고 따끔한 팩트폭격을, 늙은 마녀면 연륜이 묻어나는 옛스러운 비유를 사용 등)
* 역방향이 나왔더라도 각 캐릭터의 성향에 맞는 방식(위로, 호통, 현실적 대안 등)으로 조언을 덧붙여 주세요.
* 답변은 3~4문단 정도로 작성하며, 마크다운 기호(*, # 등)를 최대한 자제하고 온전히 캐릭터에 빙의하여 자연스러운 대화체로 작성해 주세요.
* **CRITICAL INSTRUCTION**: You MUST write your response ONLY in $langName. DO NOT use English or Korean unless $langName is English or Korean. Ensure ALL sentences, vocabulary, and grammar are completely in $langName.
''';

    try {
      final content = [Content.text(prompt)];
      final responseStream = _model.generateContentStream(content);
      await for (final chunk in responseStream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      yield '점괘를 읽는 도중 오류가 발생했습니다: $e';
    }
  }
}
