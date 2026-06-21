import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../lib/data/tarot_data.dart';

void main() async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('.env file not found');
    exit(1);
  }
  
  final lines = await envFile.readAsLines();
  String? apiKey;
  for (final line in lines) {
    if (line.startsWith('GEMINI_API_KEY=')) {
      apiKey = line.split('=')[1].trim();
      break;
    }
  }

  if (apiKey == null || apiKey.isEmpty) {
    print('GEMINI_API_KEY not found in .env');
    exit(1);
  }

  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
    ),
  );

  final outputFile = File('assets/data/tarot_details_ko.json');
  List<dynamic> existingData = [];
  if (await outputFile.exists()) {
    final contents = await outputFile.readAsString();
    if (contents.trim().isNotEmpty) {
      existingData = jsonDecode(contents);
    }
  }

  final Set<String> completedIds = existingData.map((e) => e['id'] as String).toSet();

  print('Total cards: ${tarotDeck.length}, Completed: ${completedIds.length}');

  for (final card in tarotDeck) {
    if (completedIds.contains(card.id)) {
      continue;
    }

    print('Generating details for: ${card.name} (${card.id})');
    
    final prompt = '''
타로 카드 "${card.name}"의 매우 상세한 해석을 한국어로 작성해 주세요. 
이 해석은 타로 도감 앱에 들어갈 내용입니다.
반드시 아래의 JSON 스키마를 정확히 지켜서 출력해 주세요. JSON 외의 다른 텍스트는 출력하지 마세요.

JSON Schema:
{
  "id": "${card.id}",
  "upright": {
    "keyMeanings": "정방향일 때의 핵심 키워드 5~6개 (쉼표로 구분)",
    "general": "정방향일 때의 전반적인 의미 (3~4문장)",
    "love": "정방향일 때의 연애 및 관계 의미",
    "career": "정방향일 때의 금전 및 커리어 의미",
    "health": "정방향일 때의 건강 의미",
    "spirituality": "정방향일 때의 영성 및 내면 의미"
  },
  "reversed": {
    "keyMeanings": "역방향일 때의 핵심 키워드 5~6개 (쉼표로 구분)",
    "general": "역방향일 때의 전반적인 의미 (3~4문장)",
    "love": "역방향일 때의 연애 및 관계 의미",
    "career": "역방향일 때의 금전 및 커리어 의미",
    "health": "역방향일 때의 건강 의미",
    "spirituality": "역방향일 때의 영성 및 내면 의미"
  }
}
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;
      if (text != null && text.isNotEmpty) {
        final parsedJson = jsonDecode(text);
        existingData.add(parsedJson);
        await outputFile.writeAsString(jsonEncode(existingData));
        print('  -> Success');
      } else {
        print('  -> Failed: Empty response');
      }
    } catch (e) {
      print('  -> Error: $e');
      // Wait a bit before retrying or continuing to avoid quota errors
      await Future.delayed(Duration(seconds: 5));
    }
    
    // Rate limit delay (Flash handles up to 15 RPM for free, or more for paid. Let's be safe with 2 sec)
    await Future.delayed(Duration(seconds: 2));
  }
  
  print('Generation complete.');
}
