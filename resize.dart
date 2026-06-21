import 'dart:io';
import 'package:image/image.dart';

void main() {
  final inputPath = r'C:\Users\ncia\.gemini\antigravity-ide\brain\f2998b6b-9c26-48f2-84c5-e9b46781ea08\magic_book_hexagram_1781177829580.png';
  final outputPath = r'assets/images/ic_diary.png';
  
  final bytes = File(inputPath).readAsBytesSync();
  final image = decodeImage(bytes);
  
  if (image != null) {
    final resized = copyResize(image, width: 138, height: 138);
    File(outputPath).writeAsBytesSync(encodePng(resized));
    print('Hexagram book icon resized to 138x138 and saved!');
  } else {
    print('Failed to decode image');
  }
}
