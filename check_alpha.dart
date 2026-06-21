import 'dart:io';
import 'package:image/image.dart';

void main() {
  final bytes = File('assets/images/ic_diary.png').readAsBytesSync();
  final img = decodeImage(bytes)!;
  
  int maxAlpha = 0;
  int minAlpha = 255;
  int nonZeroAlphaCount = 0;

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      final p = img.getPixel(x, y);
      final a = p.a as num; 
      int alphaValue = a.toInt();
      
      if (alphaValue > maxAlpha) maxAlpha = alphaValue;
      if (alphaValue < minAlpha) minAlpha = alphaValue;
      if (alphaValue > 0) nonZeroAlphaCount++;
    }
  }

  print('ic_diary.png Analysis:');
  print('Width: ${img.width}, Height: ${img.height}');
  print('Max Alpha: $maxAlpha');
  print('Min Alpha: $minAlpha');
  print('Non-zero alpha pixels: $nonZeroAlphaCount');
}
