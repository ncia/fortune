import 'dart:io';
import 'package:image/image.dart';

void main() {
  final img = decodeImage(File('assets/images/ic_chat.png').readAsBytesSync())!;
  var p = img.getPixel(0,0);
  print('ic_chat.png Pixel 0,0: R=${p.r}, G=${p.g}, B=${p.b}, A=${p.a}');

  final img2 = decodeImage(File('assets/images/ic_diary.png').readAsBytesSync())!;
  var p2 = img2.getPixel(0,0);
  print('ic_diary.png Pixel 0,0: R=${p2.r}, G=${p2.g}, B=${p2.b}, A=${p2.a}');
}
