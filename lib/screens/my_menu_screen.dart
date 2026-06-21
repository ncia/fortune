import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/nickname_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/data/nickname_data.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:flutter_tarot/screens/theme_selection_screen.dart';
import 'package:flutter_tarot/screens/faq_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'auth_screen.dart'; // AuthScreen 임포트 추가
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/profile_edit_dialog.dart';
import 'main_screen.dart';
import 'theme_selection_screen.dart';
import 'theme_selection_screen.dart';
import 'language_selection_screen.dart';
import '../services/language_manager.dart';
import 'favorite_cards_screen.dart';
import '../widgets/mailbox_dialog.dart';
import '../services/mail_service.dart';

class MyMenuScreen extends StatelessWidget {
  const MyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase가 초기화되지 않은 환경(예: 윈도우 미설정) 처리
    final isFirebaseInitialized = Firebase.apps.isNotEmpty;
    
    return GradientBackground(
      child: SafeArea(
        child: isFirebaseInitialized 
        ? StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final isLoggedIn = user != null;
              
              if (!isLoggedIn) {
                return const AuthScreen(isInline: true);
              }
              
              return _buildMenuList(context, isFirebaseInitialized: true, isLoggedIn: isLoggedIn, user: user);
            }
          )
        : _buildMenuList(context, isFirebaseInitialized: false, isLoggedIn: false, user: null),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, {required bool isFirebaseInitialized, required bool isLoggedIn, User? user}) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      children: [

        // User Profile Section
        if (!isFirebaseInitialized)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: GlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo.shade900,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/witch_morgan.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.myMenuFirebaseNotConnected,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.myMenuWindowsSetupNeeded,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.myMenuTouchToViewLogin,
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (isLoggedIn)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
            builder: (context, docSnapshot) {
              String displayName = user.email ?? AppLocalizations.of(context)!.myMenuNoName;
              String profileImage = 'assets/images/witch_morgan.jpg';
              bool isCustomNickname = true;
              int? prefixIndex;
              int? suffixIndex;
              String? instagramUrl;
              String? facebookUrl;
              String? xUrl;
              String? bio;

              if (docSnapshot.hasData && docSnapshot.data!.exists) {
                final data = docSnapshot.data!.data() as Map<String, dynamic>;
                isCustomNickname = data['isCustomNickname'] ?? true;
                prefixIndex = data['nicknamePrefixIndex'];
                suffixIndex = data['nicknameSuffixIndex'];
                instagramUrl = data['instagramUrl'];
                facebookUrl = data['facebookUrl'];
                xUrl = data['xUrl'];
                bio = data['bio'];
                
                if (!isCustomNickname && prefixIndex != null && suffixIndex != null) {
                  final prefix = NicknameLocalizations.getPrefix(context, prefixIndex);
                  final suffix = NicknameLocalizations.getSuffix(context, suffixIndex);
                  displayName = '$prefix $suffix';
                } else {
                  displayName = data['nickname'] ?? displayName;
                }
                profileImage = data['profileImage'] ?? profileImage;
              }
              
              return GlassContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 20,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.shade900,
                        image: DecorationImage(
                          image: profileImage.startsWith('data:image')
                              ? MemoryImage(base64Decode(profileImage.split(',').last)) as ImageProvider
                              : AssetImage(profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? '',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          _EmailVerificationBadge(user: user),
                        ],
                      ),
                    ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ProfileEditDialog(
                              user: user,
                              currentNickname: displayName,
                              currentProfileImage: profileImage,
                              isCustomNickname: isCustomNickname,
                              nicknamePrefixIndex: prefixIndex,
                              nicknameSuffixIndex: suffixIndex,
                              instagramUrl: instagramUrl,
                              facebookUrl: facebookUrl,
                              xUrl: xUrl,
                              bio: bio,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        else
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: GlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade800,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/witch_morgan.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.myMenuPleaseLogin,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.myMenuTouchToSignupLogin,
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 30),
        // Menu Items
        _buildSectionTitle(AppLocalizations.of(context)!.menuSectionNews),
        ListenableBuilder(
          listenable: MailService(),
          builder: (context, _) {
            final unreadCount = MailService().unreadCount;
            return _buildMenuItem(
              Icons.mail_outline,
              AppLocalizations.of(context)!.menuMailboxTitle,
              AppLocalizations.of(context)!.menuMailboxSubtitle,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const MailboxDialog(),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (unreadCount > 0)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const Icon(Icons.chevron_right, color: Colors.white54),
                ],
              ),
            );
          },
        ),
        _buildMenuItem(Icons.notifications_none, AppLocalizations.of(context)!.menuNotificationCenterTitle, AppLocalizations.of(context)!.menuNotificationCenterSubtitle, onTap: () {
          // TODO: 알림 센터 열기
        }),
        
        const SizedBox(height: 20),
        _buildSectionTitle(AppLocalizations.of(context)!.myMenuSectionMyRecords),
        _buildMenuItem(Icons.history_edu, AppLocalizations.of(context)!.myMenuDiaryStorage, AppLocalizations.of(context)!.myMenuCheckSavedDiary, onTap: () {
          mainScreenKey.currentState?.switchTab(2);
        }),
        _buildMenuItem(Icons.star_border, AppLocalizations.of(context)!.myMenuFavoriteCards, AppLocalizations.of(context)!.myMenuMyFavoriteCardsList, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteCardsScreen()),
          );
        }),
        
        const SizedBox(height: 20),
        _buildSectionTitle(AppLocalizations.of(context)!.myMenuSectionAppSettings),
        if (isLoggedIn && user != null) _PushSettingsTile(userId: user.uid),
        
        ValueListenableBuilder<Locale?>(
          valueListenable: LanguageManager.instance.localeNotifier,
          builder: (context, locale, _) {
            String subtitle = AppLocalizations.of(context)!.languageSystemDefault;
            if (locale != null) {
              final match = LanguageSelectionScreen.supportedLanguages.where((lang) => 
                  lang['code'] == locale.languageCode && 
                  lang['script'] == locale.scriptCode
              ).toList();
              if (match.isNotEmpty) {
                subtitle = match.first['name'];
              }
            }
            return _buildMenuItem(
              Icons.language, 
              AppLocalizations.of(context)!.myMenuLanguageSettings, 
              subtitle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
                );
              },
            );
          },
        ),

        _buildMenuItem(Icons.dark_mode_outlined, AppLocalizations.of(context)!.myMenuThemeSettings, AppLocalizations.of(context)!.myMenuChangeBackground, onTap: () {
          Navigator.pushNamed(context, '/theme_selection');
        }),
        
        const SizedBox(height: 20),
        _buildSectionTitle(AppLocalizations.of(context)!.myMenuSectionCustomerSupport),
        _buildMenuItem(Icons.email_outlined, AppLocalizations.of(context)!.myMenuContactUs, AppLocalizations.of(context)!.myMenuContactUsSubtitle, onTap: () {
          _showContactDialog(context);
        }),
        _buildMenuItem(Icons.help_outline, AppLocalizations.of(context)!.myMenuFaq, null, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FaqScreen()),
          );
        }),
        _buildMenuItem(Icons.info_outline, AppLocalizations.of(context)!.myMenuAppInfo, AppLocalizations.of(context)!.myMenuAppVersion('1.2.4')),
        
        if (isLoggedIn) ...[
          const SizedBox(height: 20),
          _buildSectionTitle(AppLocalizations.of(context)!.myMenuSectionAccountManagement),
          _buildMenuItem(Icons.logout, AppLocalizations.of(context)!.myMenuLogout, AppLocalizations.of(context)!.myMenuLogoutDesc, onTap: () async {
            await FirebaseAuth.instance.signOut();
          }),
          _buildMenuItem(Icons.person_remove, AppLocalizations.of(context)!.myMenuDeleteAccount, AppLocalizations.of(context)!.myMenuDeleteAccountDesc, onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Colors.deepPurple.shade900,
                title: Text(AppLocalizations.of(context)!.myMenuDeleteAccountWarnTitle, style: const TextStyle(color: Colors.redAccent)),
                content: Text(
                  AppLocalizations.of(context)!.myMenuDeleteAccountWarnDesc,
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(AppLocalizations.of(context)!.myMenuDeleteAccountCancel, style: const TextStyle(color: Colors.white54)),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final uid = user.uid;
                          // Delete diaries
                          final diaries = await FirebaseFirestore.instance.collection('tarot_diary').where('userId', isEqualTo: uid).get();
                          for (var doc in diaries.docs) {
                            await doc.reference.delete();
                          }
                          // Delete user profile
                          await FirebaseFirestore.instance.collection('users').doc(uid).delete();
                          // Delete auth account
                          await user.delete();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.profileEditErrorRecentLogin)),
                          );
                          await FirebaseAuth.instance.signOut();
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.myMenuDeleteAccountConfirm, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _showContactDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    String selectedType = localizations.contactTypeBug;
    final List<String> types = [
      localizations.contactTypeBug,
      localizations.contactTypeFeature,
      localizations.contactTypePayment,
      localizations.contactTypeOther,
    ];
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: GlassContainer(
                borderRadius: 16,
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        localizations.contactDialogTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: const Color(0xFF2C2C4E),
                            value: selectedType,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedType = newValue;
                                });
                              }
                            },
                            items: types.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TextField(
                          controller: contentController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: localizations.contactHint,
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.amberAccent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              localizations.contactCancel,
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              foregroundColor: Colors.black87,
                            ),
                            onPressed: () async {
                              if (contentController.text.trim().isEmpty) {
                                _showEmptyWarning(context);
                                return;
                              }
                              
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'ncia@daum.net',
                                query: _encodeQueryParameters(<String, String>{
                                  'subject': '[$selectedType] ${localizations.contactDialogTitle}',
                                  'body': contentController.text,
                                }),
                              );
                              if (await canLaunchUrl(emailLaunchUri)) {
                                await launchUrl(emailLaunchUri);
                                if (context.mounted) Navigator.of(context).pop();
                              }
                            },
                            child: Text(localizations.contactSend),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEmptyWarning(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C4E),
          title: Text(localizations.contactEmptyErrorTitle, style: const TextStyle(color: Colors.white)),
          content: Text(localizations.contactEmptyErrorMessage, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.amberAccent)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String? subtitle, {VoidCallback? onTap, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 16,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.amberAccent),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  )
                : null,
            trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }
}

class _PushSettingsTile extends StatefulWidget {
  final String userId;
  const _PushSettingsTile({required this.userId});

  @override
  State<_PushSettingsTile> createState() => _PushSettingsTileState();
}

class _PushSettingsTileState extends State<_PushSettingsTile> {
  bool _pushEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPushSetting();
  }

  Future<void> _loadPushSetting() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        setState(() {
          _pushEnabled = doc.data()?['pushEnabled'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('푸시 설정 로드 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePush(bool value) async {
    setState(() {
      _pushEnabled = value;
      _isLoading = true;
    });

    try {
      if (value) {
        // 권한 요청 (iOS 등의 경우 여기서 창이 뜹니다)
        await FirebaseMessaging.instance.requestPermission();
      }
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'pushEnabled': value,
      });
    } catch (e) {
      debugPrint('푸시 설정 업데이트 오류: $e');
      setState(() => _pushEnabled = !value); // 롤백
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 16,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications_active_outlined, color: Colors.amberAccent),
            ),
            title: Text(
              AppLocalizations.of(context)!.myMenuPushNotifications,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.myMenuPushNotificationsDesc,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),
            trailing: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amberAccent),
                  )
                : Switch(
                    value: _pushEnabled,
                    onChanged: _togglePush,
                    activeColor: Colors.amberAccent,
                  ),
          ),
        ),
      ),
    );
  }
}

class _EmailVerificationBadge extends StatefulWidget {
  final User user;
  const _EmailVerificationBadge({required this.user});

  @override
  State<_EmailVerificationBadge> createState() => _EmailVerificationBadgeState();
}

class _EmailVerificationBadgeState extends State<_EmailVerificationBadge> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    return GestureDetector(
      onTap: isVerified || _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                await FirebaseAuth.instance.currentUser?.reload();
                if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.myMenuEmailVerifiedMsg)),
                    );
                  }
                } else {
                  final langCode = Localizations.localeOf(context).languageCode;
                  await FirebaseAuth.instance.setLanguageCode(langCode);
                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.deepPurple.shade900,
                        title: Text(AppLocalizations.of(context)!.myMenuEmailSendTitle, style: const TextStyle(color: Colors.white)),
                        content: Text(
                          AppLocalizations.of(context)!.myMenuEmailSendContent,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(AppLocalizations.of(context)!.myMenuConfirm, style: const TextStyle(color: Colors.amberAccent)),
                          ),
                        ],
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.myMenuEmailErrorMsg)),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isVerified ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isVerified ? Colors.green : Colors.redAccent),
        ),
        child: _isLoading 
            ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
                isVerified ? AppLocalizations.of(context)!.myMenuEmailVerified : AppLocalizations.of(context)!.myMenuEmailNotVerified,
                style: TextStyle(
                  color: isVerified ? Colors.greenAccent : Colors.redAccent, 
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

