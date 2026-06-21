import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static final LanguageManager instance = LanguageManager._internal();
  LanguageManager._internal();

  final ValueNotifier<Locale?> localeNotifier = ValueNotifier<Locale?>(null);
  
  static const String _prefKey = 'selected_language_code';
  static const String _prefScriptKey = 'selected_script_code';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_prefKey);
    final String? scriptCode = prefs.getString(_prefScriptKey);

    if (languageCode != null && languageCode.isNotEmpty) {
      if (scriptCode != null && scriptCode.isNotEmpty) {
        localeNotifier.value = Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode);
      } else {
        localeNotifier.value = Locale(languageCode);
      }
    } else {
      localeNotifier.value = null; // System default
    }
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefKey);
      await prefs.remove(_prefScriptKey);
    } else {
      await prefs.setString(_prefKey, locale.languageCode);
      if (locale.scriptCode != null) {
        await prefs.setString(_prefScriptKey, locale.scriptCode!);
      } else {
        await prefs.remove(_prefScriptKey);
      }
    }
    localeNotifier.value = locale;
  }
}
