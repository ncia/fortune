import 'dart:io';
import 'package:image/image.dart';

void main() {
  // Read the image
  final imagePath = 'assets/images/app_icon.png';
  final file = File(imagePath);
  final image = decodeImage(file.readAsBytesSync());

  if (image == null) {
    print('Failed to decode image');
    return;
  }

  // Get the background color from top-left pixel
  final bgPixel = image.getPixel(0, 0);
  final rBg = bgPixel.r;
  final gBg = bgPixel.g;
  final bBg = bgPixel.b;

  // New color: dark purple (e.g. #31004a)
  final newR = 49;
  final newG = 0;
  final newB = 74;
  final tolerance = 30;

  print('Original BG Color: R: $rBg, G: $gBg, B: $bBg');

  // Iterate over all pixels
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;

      // Check if pixel is close to background color
      if ((r - rBg).abs() <= tolerance &&
          (g - gBg).abs() <= tolerance &&
          (b - bBg).abs() <= tolerance) {
        
        // Update pixel with new color
        pixel.setRgba(newR, newG, newB, pixel.a);
      }
    }
  }

  // Save the image
  file.writeAsBytesSync(encodePng(image));
  print('App icon background color changed successfully.');
}
