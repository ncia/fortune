import 'package:flutter/material.dart';

class CustomImageIcon extends StatelessWidget {
  final String assetPath;
  
  const CustomImageIcon(this.assetPath, {super.key});

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconColor = iconTheme.color ?? Colors.white;
    
    // IconTheme의 투명도(opacity)와 색상의 알파값을 결합하여 최종 투명도 계산
    final alphaMultiplier = (iconTheme.opacity ?? 1.0) * (iconColor.alpha / 255.0);

    return Opacity(
      opacity: alphaMultiplier,
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix([
          // RGB 값은 하단 메뉴가 지정하는 색상(마젠타 또는 회색)으로 덮어씌웁니다.
          0, 0, 0, 0, iconColor.red.toDouble(),
          0, 0, 0, 0, iconColor.green.toDouble(),
          0, 0, 0, 0, iconColor.blue.toDouble(),
          // 입력 이미지의 RGB 값을 더해 Alpha를 만듭니다.
          // 즉, 원본이 검은색(0,0,0)이면 Alpha가 0이 되어 투명해지고, 
          // 원본에 색상(흰색, 골드 등)이 있으면 Alpha가 255가 되어 불투명해집니다.
          1, 1, 1, 0, 0, 
        ]),
        child: Image.asset(assetPath, width: 24, height: 24),
      ),
    );
  }
}
