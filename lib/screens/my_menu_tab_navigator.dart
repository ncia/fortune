import 'package:flutter/material.dart';
import 'my_menu_screen.dart';
import 'theme_selection_screen.dart';

class MyMenuTabNavigator extends StatelessWidget {
  const MyMenuTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == '/') {
          page = const MyMenuScreen();
        } else if (settings.name == '/theme_selection') {
          page = const ThemeSelectionScreen();
        } else {
          page = const SizedBox();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
