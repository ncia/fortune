import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  final apiKey = Platform.environment['SPEECHIFY_API_KEY'];
  if (apiKey == null) {
    print('No API key');
    return;
  }
  final baseUrl = 'https://api.speechify.ai/v1/audio/speech';
  final requestBody = jsonEncode({
    'input': 'สวัสดี',
    'voice_id': 'karen',
    'audio_format': 'mp3',
    'model': 'simba-multilingual',
    'language': 'th'
  });

  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: requestBody,
  );
  
  print('Status: ${response.statusCode}');
  // print(response.body);
}
