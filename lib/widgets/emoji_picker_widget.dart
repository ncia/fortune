import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class EmojiPickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isVisible;

  const EmojiPickerWidget({
    super.key,
    required this.controller,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isVisible,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          textEditingController: controller,
          config: Config(
            bottomActionBarConfig: const BottomActionBarConfig(
              showBackspaceButton: true,
              showSearchViewButton: false,
              backgroundColor: Color(0xFF1E1E1E),
              buttonColor: Color(0xFF1E1E1E),
              buttonIconColor: Colors.grey,
            ),
            categoryViewConfig: const CategoryViewConfig(
              backgroundColor: Color(0xFF1E1E1E),
              indicatorColor: Colors.amberAccent,
              iconColorSelected: Colors.amberAccent,
              iconColor: Colors.grey,
            ),
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: const Color(0xFF1E1E1E),
              emojiSizeMax: 28 * (Theme.of(context).platform == TargetPlatform.iOS ? 1.3 : 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
