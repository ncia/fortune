import 'package:flutter/material.dart';
import 'diary_screen.dart';

class DiaryTabNavigator extends StatelessWidget {
  const DiaryTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => DiaryScreen(),
          settings: settings,
        );
      },
    );
  }
}
