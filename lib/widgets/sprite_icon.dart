import 'package:flutter/material.dart';

class SpriteIcon extends StatelessWidget {
  final String imagePath;
  final int cols;
  final int rows;
  final int colIndex;
  final int rowIndex;
  final double iconSize;
  final Color? color;

  const SpriteIcon({
    super.key,
    required this.imagePath,
    required this.cols,
    required this.rows,
    required this.colIndex,
    required this.rowIndex,
    this.iconSize = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: iconSize * cols,
          maxHeight: iconSize * rows,
          alignment: Alignment(
            cols == 1 ? 0 : (colIndex / (cols - 1)) * 2 - 1,
            rows == 1 ? 0 : (rowIndex / (rows - 1)) * 2 - 1,
          ),
          child: ColorFiltered(
            // RGB 값이 0(검은색)일 경우 투명도(Alpha)를 0으로 만들어 배경을 제거합니다.
            colorFilter: const ColorFilter.matrix([
              1, 0, 0, 0, 0, // R
              0, 1, 0, 0, 0, // G
              0, 0, 1, 0, 0, // B
              1, 1, 1, 0, 0, // Alpha (R+G+B 기반으로 검은색 제외하고 불투명하게)
            ]),
            child: Image.asset(
              imagePath,
              width: iconSize * cols,
              height: iconSize * rows,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
