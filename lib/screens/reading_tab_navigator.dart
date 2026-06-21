import 'package:flutter/material.dart';
import 'reading_intro_screen.dart';
import 'spread_selection_screen.dart';
import '../data/shaman_data.dart';

class ReadingTabNavigator extends StatelessWidget {
  const ReadingTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == '/') {
          page = ReadingIntroScreen(
            onStart: (ctx, selectedWitch) {
              Navigator.pushNamed(ctx, '/selection', arguments: selectedWitch);
            },
          );
        } else if (settings.name == '/selection') {
          final witch = settings.arguments as Witch?;
          page = SpreadSelectionScreen(showBackButton: true, selectedWitch: witch);
        } else {
          page = const SizedBox();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}

