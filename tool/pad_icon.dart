import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final imagePath = r'C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\media__1782021770188.png';
  final file = File(imagePath);
  if (!file.existsSync()) {
    print('Original icon not found at $imagePath');
    return;
  }
  
  final image = img.decodeImage(file.readAsBytesSync());
  if (image == null) return;
  
  // Create a new image of the same size
  final width = image.width;
  final height = image.height;
  final padded = img.Image(width: width, height: height);
  
  // Use a brighter, more vivid deep purple for the background instead of the dark edge pixel
  // R: 60, G: 30, B: 90
  final bgPixel = img.ColorRgb8(60, 30, 90);
  
  // Fill the new image with the background color
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      padded.setPixel(x, y, bgPixel);
    }
  }
  
  // Scale original image to 66% 
  final scale = 0.66;
  final newWidth = (width * scale).toInt();
  final newHeight = (height * scale).toInt();
  
  final resized = img.copyResize(image, width: newWidth, height: newHeight, interpolation: img.Interpolation.average);
  
  // Draw resized image in the center
  final offsetX = (width - newWidth) ~/ 2;
  final offsetY = (height - newHeight) ~/ 2;
  
  img.compositeImage(padded, resized, dstX: offsetX, dstY: offsetY);
  
  File('assets/images/app_icon.png').writeAsBytesSync(img.encodePng(padded));
  print('Padded icon created at assets/images/app_icon.png');
}
