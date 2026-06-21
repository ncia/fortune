import 'package:flutter/material.dart';
import '../services/theme_manager.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;

  const GradientBackground({
    super.key, 
    required this.child,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = useSafeArea ? SafeArea(child: child) : child;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6A0DAD), // Deep Purple
            Color(0xFFB100FF), // Magenta/Purple
            Color(0xFF120024), // Dark Background at bottom
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: ValueListenableBuilder<String>(
                valueListenable: ThemeManager.instance.themeNotifier,
                builder: (context, themePath, child) {
                  return Image.asset(
                    themePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}
