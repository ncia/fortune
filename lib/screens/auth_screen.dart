import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../data/nickname_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  final bool isInline;
  const AuthScreen({super.key, this.isInline = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _isAdmin = false; // 관리자 가입 여부
  bool _obscurePassword = true; // 비밀번호 숨김 여부
  bool _agreedToTerms = false; // 약관 동의 여부 (기본 체크 해제)
  bool _agreedToPush = false; // 마케팅/푸시 알림 동의 여부 (기본 체크 해제)
  bool _keepLoggedIn = true; // 자동 로그인 유지 여부

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  int? _prefixIndex;
  int? _suffixIndex;
  bool _isCustomNickname = false;

  void _generateRandomNickname() {
    final random = Random();
    final prefixes = getNicknamePrefixes(context);
    final suffixes = getNicknameSuffixes(context);
    _prefixIndex = random.nextInt(prefixes.length);
    _suffixIndex = random.nextInt(suffixes.length);
    final prefix = prefixes[_prefixIndex!];
    final suffix = suffixes[_suffixIndex!];
    _nicknameController.text = '$prefix $suffix';
    _isCustomNickname = false;
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(AppLocalizations.of(context)!.eulaTitle, style: const TextStyle(color: Colors.white, fontSize: 18)),
          content: SingleChildScrollView(
            child: Text(
              AppLocalizations.of(context)!.eulaArticle1 + AppLocalizations.of(context)!.eulaArticle2 + AppLocalizations.of(context)!.eulaArticle3 + AppLocalizations.of(context)!.eulaArticle4 + AppLocalizations.of(context)!.eulaArticle5 + AppLocalizations.of(context)!.eulaArticle6 + AppLocalizations.of(context)!.eulaAgreement,
              style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 13),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.closeButton, style: const TextStyle(color: Colors.amberAccent)),
            ),
          ],
        );
      },
    );
  }

  void _showPushTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(AppLocalizations.of(context)!.pushTermsTitle, style: const TextStyle(color: Colors.white, fontSize: 18)),
          content: SingleChildScrollView(
            child: Text(
              AppLocalizations.of(context)!.pushArticle1 + AppLocalizations.of(context)!.pushArticle2 + AppLocalizations.of(context)!.pushArticle3 + AppLocalizations.of(context)!.pushAgreement,
              style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 13),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.closeButton, style: const TextStyle(color: Colors.amberAccent)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithGoogle() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.windowsNoGoogleLogin)),
        );
      }
      return;
    }

    if (!_isLogin && !_agreedToTerms) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.signupTermsRequired)),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!docSnapshot.exists) {
          final random = Random();
          final prefixes = getNicknamePrefixes(context);
          final suffixes = getNicknameSuffixes(context);
          final prefixIndex = random.nextInt(prefixes.length);
          final suffixIndex = random.nextInt(suffixes.length);
          final prefix = prefixes[prefixIndex];
          final suffix = suffixes[suffixIndex];
          
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': user.email,
            'nickname': '$prefix $suffix',
            'nicknamePrefixIndex': prefixIndex,
            'nicknameSuffixIndex': suffixIndex,
            'isCustomNickname': false,
            'role': 'user',
            'pushEnabled': _agreedToPush,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
            'deleteEligibleAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))), // 1년 뒤 삭제 대상
            'retentionExpiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365 * 3))), // 3년 뒤 영구 파기
          });
          
          if (_agreedToPush) {
            await FirebaseMessaging.instance.requestPermission();
          }
        }
        
        // 로그인 성공 시 유지 여부 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keepLoggedIn', _keepLoggedIn);

        if (mounted) {
          if (!widget.isInline) {
            Navigator.pop(context);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.googleLoginError(e.message ?? 'Unknown'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.googleLoginUnknownError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    
    if (Firebase.apps.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.windowsNoFirebase)),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      if (_isLogin) {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        if (userCredential.user != null && !userCredential.user!.emailVerified) {
          // 이메일 미인증 상태
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.emailVerificationRequired),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.resendEmail,
                  onPressed: () async {
                    await userCredential.user!.sendEmailVerification();
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.verificationEmailSent)));
                  },
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
          await FirebaseAuth.instance.signOut(); // 인증 안되었으므로 강제 로그아웃
          return;
        }

        // 로그인 성공 시 유지 여부 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keepLoggedIn', _keepLoggedIn);
      } else {
        if (_passwordController.text != _confirmPasswordController.text) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.passwordMismatch)),
            );
          }
          setState(() => _isLoading = false);
          return;
        }

        if (!_agreedToTerms) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.signupTermsRequired)),
            );
          }
          setState(() => _isLoading = false);
          return;
        }

        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        final user = userCredential.user;
        if (user != null) {
          // Firestore에 유저 정보 및 권한(role) 저장
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'email': _emailController.text.trim(),
            'nickname': _nicknameController.text.trim(),
            'nicknamePrefixIndex': _isCustomNickname ? null : _prefixIndex,
            'nicknameSuffixIndex': _isCustomNickname ? null : _suffixIndex,
            'isCustomNickname': _isCustomNickname,
            'role': _isAdmin ? 'admin' : 'user', // 관리자 여부에 따라 role 부여
            'pushEnabled': _agreedToPush,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
            'deleteEligibleAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))), // 1년 뒤 자동 삭제 대상
            'retentionExpiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365 * 3))), // 3년 뒤 완전 파기
          });
          
          if (_agreedToPush) {
            await FirebaseMessaging.instance.requestPermission();
          }
          
          // 인증 메일 발송
          await user.sendEmailVerification();
          await FirebaseAuth.instance.signOut(); // 가입 직후 로그아웃 처리하여 인증 유도
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.authSignupComplete),
                duration: const Duration(seconds: 5),
              ),
            );
            setState(() {
              _isLogin = true; // 로그인 화면으로 전환
              _passwordController.clear();
              _isAdmin = false; // 초기화
            });
            return;
          }
        }
      }
      if (mounted && !widget.isInline) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? AppLocalizations.of(context)!.authError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: GlassContainer(
              padding: const EdgeInsets.all(24),
              borderRadius: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLogin ? AppLocalizations.of(context)!.authLoginTitle : AppLocalizations.of(context)!.authSignupTitle,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 24),
                  if (!_isLogin) ...[
                    TextFormField(
                      controller: _nicknameController,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        setState(() {
                          _isCustomNickname = true;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.authTarotNickname,
                        labelStyle: const TextStyle(color: Colors.amberAccent),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.amberAccent),
                          onPressed: () => setState(() => _generateRandomNickname()),
                          tooltip: AppLocalizations.of(context)!.authRerollNickname,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.authEmail,
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.authPassword,
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(height: 16),

                  if (!_isLogin) ...[
                    TextField(
                      controller: _confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.authConfirmPassword,
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isLogin) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: _keepLoggedIn,
                          onChanged: (val) {
                            setState(() => _keepLoggedIn = val ?? true);
                          },
                          activeColor: Colors.amberAccent,
                          checkColor: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _keepLoggedIn = !_keepLoggedIn);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.authKeepLoggedIn,
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (!_isLogin) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) {
                            setState(() => _agreedToTerms = val ?? false);
                          },
                          activeColor: Colors.amberAccent,
                          checkColor: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _agreedToTerms = !_agreedToTerms);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.authAgreeEula,
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _showTermsDialog,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                          ),
                          child: Text(AppLocalizations.of(context)!.authViewContent, style: const TextStyle(color: Colors.amberAccent, fontSize: 12)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToPush,
                          onChanged: (val) {
                            setState(() => _agreedToPush = val ?? false);
                          },
                          activeColor: Colors.amberAccent,
                          checkColor: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _agreedToPush = !_agreedToPush);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.authAgreePush,
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _showPushTermsDialog,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                          ),
                          child: Text(AppLocalizations.of(context)!.authViewContent, style: const TextStyle(color: Colors.amberAccent, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.amberAccent)
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_isLogin ? AppLocalizations.of(context)!.authBtnLogin : AppLocalizations.of(context)!.authBtnSignup, style: const TextStyle(fontSize: 16)),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        if (!_isLogin && _nicknameController.text.isEmpty) {
                          _generateRandomNickname();
                        }
                      });
                    },
                    child: Text(
                      _isLogin ? AppLocalizations.of(context)!.authSwitchToSignup : AppLocalizations.of(context)!.authSwitchToLogin,
                      style: const TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 8),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google_logo.png', width: 24, height: 24),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.authGoogleSignIn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

    if (widget.isInline) {
      return formContent;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: formContent,
      ),
    );
  }
}
