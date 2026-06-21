import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../data/nickname_data.dart';
import 'glass_container.dart';

class ProfileEditDialog extends StatefulWidget {
  final User user;
  final String currentNickname;
  final String currentProfileImage;
  final bool isCustomNickname;
  final int? nicknamePrefixIndex;
  final int? nicknameSuffixIndex;
  final String? instagramUrl;
  final String? facebookUrl;
  final String? xUrl;
  final String? bio;

  const ProfileEditDialog({
    super.key,
    required this.user,
    required this.currentNickname,
    required this.currentProfileImage,
    required this.isCustomNickname,
    this.nicknamePrefixIndex,
    this.nicknameSuffixIndex,
    this.instagramUrl,
    this.facebookUrl,
    this.xUrl,
    this.bio,
  });

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _nicknameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _xController;
  late TextEditingController _bioController;
  
  late String _selectedImage;
  bool _isLoading = false;
  bool _isSocialLoginUser = false;
  bool _isEmailEditing = false;
  bool _isCustomNickname = false;
  int? _prefixIndex;
  int? _suffixIndex;
  String? _customImageData;
  
  final List<String> _availableAvatars = [
    'assets/images/witch_morgan.jpg',
    'assets/images/witch_luna.jpg',
    'assets/images/witch_aria.jpg',
    'assets/images/witch_serena.jpg',
    'assets/images/witch_evelyn.jpg',
    'assets/images/witch_karen.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.currentNickname);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
    _isCustomNickname = widget.isCustomNickname;
    _prefixIndex = widget.nicknamePrefixIndex;
    _suffixIndex = widget.nicknameSuffixIndex;
    _instagramController = TextEditingController(text: widget.instagramUrl);
    _facebookController = TextEditingController(text: widget.facebookUrl);
    _xController = TextEditingController(text: widget.xUrl);
    _bioController = TextEditingController(text: widget.bio);
    
    
    if (widget.currentProfileImage.startsWith('data:image')) {
      _customImageData = widget.currentProfileImage;
      _selectedImage = _customImageData!;
    } else {
      _selectedImage = _availableAvatars.contains(widget.currentProfileImage) 
          ? widget.currentProfileImage 
          : 'assets/images/witch_morgan.jpg';
    }
        
    // 구글/애플 가입 여부 확인 (소셜 가입자는 이메일 변경 불가)
    _isSocialLoginUser = widget.user.providerData.any(
      (userInfo) => userInfo.providerId == 'google.com' || userInfo.providerId == 'apple.com'
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _xController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 200,
        maxHeight: 200,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        setState(() {
          _customImageData = base64String;
          _selectedImage = base64String;
        });
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  void _generateRandomNickname() {
    final random = Random();
    final prefixes = getNicknamePrefixes(context);
    final suffixes = getNicknameSuffixes(context);
    _prefixIndex = random.nextInt(prefixes.length);
    _suffixIndex = random.nextInt(suffixes.length);
    final prefix = prefixes[_prefixIndex!];
    final suffix = suffixes[_suffixIndex!];
    setState(() {
      _nicknameController.text = '$prefix $suffix';
      _isCustomNickname = false;
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final newNickname = _nicknameController.text.trim();
      final newEmail = _emailController.text.trim();

      // 1. 닉네임 중복 검사 및 정보 업데이트
      if (newNickname.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.profileEditEmptyNickname)));
        setState(() => _isLoading = false);
        return;
      }

      if (newNickname != widget.currentNickname) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('nickname', isEqualTo: newNickname)
            .get();
            
        if (querySnapshot.docs.isNotEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.profileEditDuplicateNickname)),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
        'nickname': newNickname,
        'profileImage': _selectedImage,
        'nicknamePrefixIndex': _isCustomNickname ? null : _prefixIndex,
        'nicknameSuffixIndex': _isCustomNickname ? null : _suffixIndex,
        'isCustomNickname': _isCustomNickname,
        'instagramUrl': _instagramController.text.trim(),
        'facebookUrl': _facebookController.text.trim(),
        'xUrl': _xController.text.trim(),
        'bio': _bioController.text.trim(),
      });

      // 2. 이메일 변경 처리 (소셜 로그인이 아니며, 기존 이메일과 다르고, 비어있지 않을 때)
      if (!_isSocialLoginUser && newEmail != widget.user.email && newEmail.isNotEmpty) {
        // 비밀번호 확인
        final password = _passwordController.text;
        if (password.isEmpty) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.profileEditEmptyPassword)));
          setState(() => _isLoading = false);
          return;
        }

        // 재인증
        final AuthCredential credential = EmailAuthProvider.credential(
          email: widget.user.email!,
          password: password,
        );
        await widget.user.reauthenticateWithCredential(credential);

        // 파이어베이스 Auth 이메일 변경 인증 메일 발송
        await widget.user.verifyBeforeUpdateEmail(newEmail);
        
        // Firestore의 email도 업데이트 (하지만 실제 Auth 이메일은 링크 클릭 시 변경됨)
        // 안내 메시지 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.profileEditEmailSent), duration: const Duration(seconds: 5)),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.profileEditSuccess)));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String msg = AppLocalizations.of(context)!.profileEditErrorDefault;
        if (e.code == 'wrong-password') { msg = AppLocalizations.of(context)!.profileEditErrorWrongPassword; }
        else if (e.code == 'invalid-email') { msg = AppLocalizations.of(context)!.profileEditErrorInvalidEmail; }
        else if (e.code == 'email-already-in-use') { msg = AppLocalizations.of(context)!.profileEditErrorEmailInUse; }
        else if (e.code == 'requires-recent-login') { msg = AppLocalizations.of(context)!.profileEditErrorRecentLogin; }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.profileEditErrorUnknown(e.toString()))));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 20,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.profileEditTitle, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // 사진 선택
              Text(AppLocalizations.of(context)!.profileEditPhoto, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableAvatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = _selectedImage.startsWith('data:image');
                        return GestureDetector(
                          onTap: () async {
                            if (isSelected) {
                              await _pickImage();
                            } else {
                              if (_customImageData != null) {
                                setState(() => _selectedImage = _customImageData!);
                              } else {
                                await _pickImage();
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? Colors.amberAccent : Colors.transparent, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white10,
                              backgroundImage: _customImageData != null 
                                  ? MemoryImage(base64Decode(_customImageData!.split(',').last)) 
                                  : null,
                              child: _customImageData == null 
                                  ? const Icon(Icons.add_a_photo, color: Colors.white) 
                                  : null,
                            ),
                          ),
                        );
                      }
                      
                      final avatar = _availableAvatars[index - 1];
                      final isSelected = avatar == _selectedImage;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedImage = avatar),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? Colors.amberAccent : Colors.transparent, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(avatar),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 닉네임 입력
              TextFormField(
                controller: _nicknameController,
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  if (!_isCustomNickname) {
                    setState(() => _isCustomNickname = true);
                  }
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileEditNickname,
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    onPressed: _generateRandomNickname,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 자기 소개 입력
              TextField(
                controller: _bioController,
                style: const TextStyle(color: Colors.white),
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileEditBio,
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  counterStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),

              // 이메일 입력
              TextField(
                controller: _emailController,
                enabled: !_isSocialLoginUser,
                style: TextStyle(color: _isSocialLoginUser ? Colors.white54 : Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileEditEmail,
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  helperText: _isSocialLoginUser ? AppLocalizations.of(context)!.profileEditEmailSocialHint : AppLocalizations.of(context)!.profileEditEmailChangeHint,
                  helperStyle: TextStyle(color: _isSocialLoginUser ? Colors.redAccent : Colors.amberAccent, fontSize: 11),
                ),
                onChanged: (val) {
                  if (!_isEmailEditing && val != widget.user.email) {
                    setState(() => _isEmailEditing = true);
                  } else if (_isEmailEditing && val == widget.user.email) {
                    setState(() => _isEmailEditing = false);
                  }
                },
              ),
              
              if (_isEmailEditing && !_isSocialLoginUser) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.profileEditPassword,
                    labelStyle: const TextStyle(color: Colors.redAccent),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.profileEditSnsIntegration, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _instagramController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileEditSnsInsta,
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  prefixIcon: Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _facebookController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileEditSnsFb,
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  prefixIcon: Icon(Icons.facebook, color: Colors.white54, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _xController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileEditSnsX,
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  prefixIcon: Icon(Icons.alternate_email, color: Colors.white54, size: 20),
                ),
              ),
              
              const SizedBox(height: 32),

              // 하단 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.profileEditCancel, style: const TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(AppLocalizations.of(context)!.profileEditSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
