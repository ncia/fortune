import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = 'AIzaSyDYS7adBEj8U_UPw-bPJdwf0OkdBgCC-vI';
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
  
  final response = await http.get(url);
  final data = jsonDecode(response.body);
  if (data['models'] != null) {
    for (var model in data['models']) {
      print(model['name']);
    }
  } else {
    print(data);
  }
}
