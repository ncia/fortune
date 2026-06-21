import 'dart:io';
import 'package:image/image.dart';

void main() {
  final file = File('assets/images/ic_diary.png');
  final bytes = file.readAsBytesSync();
  final img = decodeImage(bytes)!;

  // Create a new image explicitly with 4 channels (RGBA)
  final maskImg = Image(width: img.width, height: img.height, numChannels: 4);

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      final p = img.getPixel(x, y);
      int gray = (p.r + p.g + p.b) ~/ 3;
      
      // Make dark background fully transparent
      int alpha = gray < 20 ? 0 : gray;
      
      maskImg.setPixelRgba(x, y, 255, 255, 255, alpha);
    }
  }

  file.writeAsBytesSync(encodePng(maskImg));
  
  // Verify
  int minAlpha = 255;
  for (int y = 0; y < maskImg.height; y++) {
    for (int x = 0; x < maskImg.width; x++) {
      int a = maskImg.getPixel(x, y).a.toInt();
      if (a < minAlpha) minAlpha = a;
    }
  }
  print('Image converted successfully! Min Alpha is now: $minAlpha');
}
