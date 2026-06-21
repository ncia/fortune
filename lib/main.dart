import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tarot/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/economy_service.dart';
import 'widgets/top_floating_icons.dart';
import 'screens/shop_screen.dart';
import 'screens/growth_screen.dart';
import 'services/theme_manager.dart';
import 'services/language_manager.dart';
import 'services/diary_service.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env");
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;
    
    // 자동 로그인 해제 상태인지 확인
    final prefs = await SharedPreferences.getInstance();
    final keepLoggedIn = prefs.getBool('keepLoggedIn') ?? true;
    
    if (!keepLoggedIn && auth.currentUser != null && !auth.currentUser!.isAnonymous) {
      await auth.signOut(); // 로그인 유지를 끈 경우 명시적 로그아웃 (이후 익명 전환됨)
    }

    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    } else if (!auth.currentUser!.isAnonymous) {
      // 일반 회원인 경우 앱 구동(접속) 시 최근 접속일과 자동 삭제 예정일(1년 뒤) 갱신
      try {
        await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
          'deleteEligibleAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        });
      } catch (e) {
        debugPrint('접속 기록 갱신 실패 (신규 가입 직후일 수 있음): $e');
      }
    }
    await EconomyService().initializeNewUser();
  } catch (e) {
    debugPrint('Firebase initialization failed (not configured yet?): $e');
  }

  await ThemeManager.instance.init();
  await LanguageManager.instance.init();
  await DiaryService.instance.init();

  // 로그인 유저면 기존 Firestore 데이터를 로컬로 마이그레이션
  try {
    final migrated = await DiaryService.instance.migrateFromCloud();
    if (migrated > 0) {
      debugPrint('Migrated $migrated diaries from cloud to local.');
    }
  } catch (e) {
    debugPrint('Cloud migration skipped: $e');
  }


  runApp(const TarotApp());
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LanguageManager.instance.localeNotifier,
      builder: (context, currentLocale, _) {
        return MaterialApp(
          title: '타로마녀',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ko'), // Korean
            Locale('ja'), // Japanese
            Locale('zh'), // Chinese
            Locale('es'), // Spanish
            Locale('fr'), // French
            Locale('de'), // German
            Locale('ru'), // Russian
            Locale('pt'), // Portuguese
            Locale('it'), // Italian
            Locale('th'), // Thai
            Locale('vi'), // Vietnamese
            Locale('hi'), // Hindi
            Locale('id'), // Indonesian
            Locale('ar'), // Arabic
            Locale('be'), // Belarusian
            Locale('bg'), // Bulgarian
            Locale('ca'), // Catalan
            Locale('cs'), // Czech
            Locale('da'), // Danish
            Locale('el'), // Greek
            Locale('et'), // Estonian
            Locale('fa'), // Persian
            Locale('fi'), // Finnish
            Locale('hr'), // Croatian
            Locale('hu'), // Hungarian
            Locale('hy'), // Armenian
            Locale('lt'), // Lithuanian
            Locale('lv'), // Latvian
            Locale('ms'), // Malay
            Locale('no'), // Norwegian
            Locale('pl'), // Polish
            Locale('rm'), // Romansh
            Locale('ro'), // Romanian
            Locale('sk'), // Slovak
            Locale('sl'), // Slovenian
            Locale('sr'), // Serbian
            Locale('sv'), // Swedish
            Locale('tl'), // Filipino/Tagalog
            Locale('tr'), // Turkish
            Locale('uk'), // Ukrainian
            Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), // Chinese Simplified
            Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // Chinese Traditional
            Locale('ml'), // Malayalam
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return const Locale('en');
            // 1. 완벽 일치 (언어 + 스크립트)
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.scriptCode == locale.scriptCode) {
                return supportedLocale;
              }
            }
            // 2. 언어 코드만 일치
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            // 3. 일치하는 언어가 없으면 기본값(영어) 사용
            return const Locale('en');
          },
          navigatorKey: globalNavigatorKey,
          home: MainScreen(),
        );
      },
    );
  }
}
