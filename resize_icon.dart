import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/app_icon.png');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }
  
  print('Reading image...');
  final image = img.decodeImage(file.readAsBytesSync());
  
  if (image != null) {
    print('Resizing image...');
    final thumbnail = img.copyResize(image, width: 512);
    
    print('Saving image...');
    File('assets/images/splash_icon.png').writeAsBytesSync(img.encodePng(thumbnail, level: 9));
    print('Resized image saved successfully to assets/images/splash_icon.png!');
  } else {
    print('Failed to decode image');
  }
}
