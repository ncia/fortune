import 'package:flutter/material.dart';
import '../widgets/custom_image_icon.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../services/mail_service.dart';

class SharedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SharedBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black.withOpacity(0.8),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const CustomImageIcon('assets/images/ic_meanings.png'),
          label: AppLocalizations.of(context)!.navReading,
        ),
        BottomNavigationBarItem(
          icon: const CustomImageIcon('assets/images/ic_chat.png'),
          label: AppLocalizations.of(context)!.navChat,
        ),
        BottomNavigationBarItem(
          icon: const CustomImageIcon('assets/images/ic_diary.png'),
          label: AppLocalizations.of(context)!.navDiary,
        ),
        BottomNavigationBarItem(
          icon: const CustomImageIcon('assets/images/ic_reading.png'),
          label: AppLocalizations.of(context)!.navMeanings,
        ),
        BottomNavigationBarItem(
          icon: ListenableBuilder(
            listenable: MailService(),
            builder: (context, _) {
              final unreadCount = MailService().unreadCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const CustomImageIcon('assets/images/ic_account.png'),
                  if (unreadCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          label: AppLocalizations.of(context)!.navMyMenu,
        ),
      ],
    );
  }
}
