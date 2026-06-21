import 'package:flutter/material.dart';
import 'reading_tab_navigator.dart';
import 'chat_screen.dart';
import 'meanings_screen.dart';
import 'my_menu_screen.dart';
import 'my_menu_tab_navigator.dart';
import 'diary_tab_navigator.dart';
import 'growth_screen.dart';
import 'shop_screen.dart';
import '../widgets/custom_image_icon.dart';
import '../widgets/coin_widget.dart';
import '../widgets/magic_dust_widget.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../widgets/top_floating_icons.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key ?? mainScreenKey);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _checkEmailVerification() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.deepPurple.shade900,
          title: Text(AppLocalizations.of(context)!.emailVerificationRequiredTitle, style: const TextStyle(color: Colors.white)),
          content: Text(
            AppLocalizations.of(context)!.emailVerificationRequiredDesc,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _currentIndex = 4;
                });
              },
              child: Text(AppLocalizations.of(context)!.emailVerificationGoToMenu, style: const TextStyle(color: Colors.amberAccent)),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  void switchTab(int index) {
    if (index != 4) {
      if (!_checkEmailVerification()) return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    const ReadingTabNavigator(),
    const ChatScreen(),
    const DiaryTabNavigator(),
    const MeaningsScreen(),
    const MyMenuTabNavigator(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioService().init().then((_) {
      AudioService().playMysteriousBgm();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioService().stopBgm();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      AudioService().pauseBgm();
    } else if (state == AppLifecycleState.resumed) {
      AudioService().resumeBgm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: TopFloatingIcons(
                onShop: () {
                  if (!_checkEmailVerification()) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopScreen()),
                  );
                },
                onGrowth: () {
                  if (!_checkEmailVerification()) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GrowthScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: switchTab,
      ),
    );
  }
}
