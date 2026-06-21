import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final String apiKey = '3aebff76f1a291205b2b416552aae5a1';
  final String voiceId = '259d4ac1ecf560c0f76e08'; // Anna
  final String url = 'https://supertoneapi.com/v1/text-to-speech/$voiceId';
  
  final requestBody = jsonEncode({
    'text': '나이 든 마녀의 목소리입니다.',
    'language': 'ko',
    'voice_settings': {
      'pitch_shift': -6.0,
      'speed': 0.8
    }
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'x-sup-api-key': apiKey,
      'Content-Type': 'application/json',
    },
    body: requestBody,
  );

  print('Status code: ${response.statusCode}');
  if (response.statusCode != 200) {
    print('Response body: ${response.body}');
  } else {
    print('Success! Received ${response.bodyBytes.length} bytes.');
  }
}
