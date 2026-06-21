import 'package:flutter/material.dart';
import 'package:flutter_tarot/services/language_manager.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  static const List<Map<String, dynamic>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ko', 'name': '한국어'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'zh', 'script': 'Hans', 'name': '简体中文 (Simplified Chinese)'},
    {'code': 'zh', 'script': 'Hant', 'name': '繁體中文 (Traditional Chinese)'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'th', 'name': 'ไทย'},
    {'code': 'vi', 'name': 'Tiếng Việt'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'id', 'name': 'Bahasa Indonesia'},
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'be', 'name': 'Беларуская'},
    {'code': 'bg', 'name': 'Български'},
    {'code': 'ca', 'name': 'Català'},
    {'code': 'cs', 'name': 'Čeština'},
    {'code': 'da', 'name': 'Dansk'},
    {'code': 'el', 'name': 'Ελληνικά'},
    {'code': 'et', 'name': 'Eesti'},
    {'code': 'fa', 'name': 'فارسی'},
    {'code': 'fi', 'name': 'Suomi'},
    {'code': 'hr', 'name': 'Hrvatski'},
    {'code': 'hu', 'name': 'Magyar'},
    {'code': 'hy', 'name': 'Հայերեն'},
    {'code': 'lt', 'name': 'Lietuvių'},
    {'code': 'lv', 'name': 'Latviešu'},
    {'code': 'ms', 'name': 'Bahasa Melayu'},
    {'code': 'no', 'name': 'Norsk'},
    {'code': 'pl', 'name': 'Polski'},
    {'code': 'rm', 'name': 'Rumantsch'},
    {'code': 'ro', 'name': 'Română'},
    {'code': 'sk', 'name': 'Slovenčina'},
    {'code': 'sl', 'name': 'Slovenščina'},
    {'code': 'sr', 'name': 'Српски'},
    {'code': 'sv', 'name': 'Svenska'},
    {'code': 'tl', 'name': 'Tagalog'},
    {'code': 'tr', 'name': 'Türkçe'},
    {'code': 'uk', 'name': 'Українська'},
    {'code': 'ml', 'name': 'മലയാളം'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 110,
        leading: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Text(AppLocalizations.of(context)!.myMenuLanguageSettings, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A0845),
              Color(0xFF6441A5),
            ],
          ),
        ),
        child: SafeArea(
          child: ValueListenableBuilder<Locale?>(
            valueListenable: LanguageManager.instance.localeNotifier,
            builder: (context, currentLocale, _) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: supportedLanguages.length + 1, // +1 for "System Default"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isSelected = currentLocale == null;
                    return _buildLanguageTile(
                      context,
                      name: AppLocalizations.of(context)!.languageSystemDefault,
                      isSelected: isSelected,
                      onTap: () {
                        LanguageManager.instance.setLocale(null);
                        Navigator.pop(context);
                      },
                    );
                  }

                  final langMap = supportedLanguages[index - 1];
                  final String code = langMap['code'];
                  final String? script = langMap['script'];
                  final String name = langMap['name'];

                  final isSelected = currentLocale != null &&
                      currentLocale.languageCode == code &&
                      currentLocale.scriptCode == script;

                  return _buildLanguageTile(
                    context,
                    name: name,
                    isSelected: isSelected,
                    onTap: () {
                      LanguageManager.instance.setLocale(
                        Locale.fromSubtags(languageCode: code, scriptCode: script),
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: Colors.amber, width: 1.5) : null,
      ),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.amber : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.amber)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
