import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

import '../services/shaman_ai_service.dart';
import '../services/diary_service.dart';
import '../services/audio_service.dart';
import '../data/saju_diary.dart';
import '../data/shaman_data.dart';

import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/custom_image_icon.dart';
import 'auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ReadingState { intro, picking, reading, result }

class ReadingScreen extends StatefulWidget {
  final bool isForChat;
  final bool skipIntro;
  final Witch? selectedWitch;
  final SajuDiary? existingDiary;

  const ReadingScreen({
    super.key,
    this.isForChat = false,
    this.skipIntro = false,
    this.selectedWitch,
    this.existingDiary,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> with TickerProviderStateMixin {
  ReadingState _currentState = ReadingState.intro;
  late Witch _activeWitch;

  // Animation Controllers
  late AnimationController _introAnimController;
  late Animation<double> _scaleAnimation;
  late AnimationController _lightningAnimController;

  // Saju Input Data
  String _sajuData = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Reading Data
  String _aiReadingText = '';
  bool _isAiTyping = false;
  SajuDiary? _currentDiary;

  @override
  void initState() {
    super.initState();
    if (widget.skipIntro || widget.isForChat) {
      _currentState = ReadingState.picking;
    }
    
    _introAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _lightningAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _introAnimController, curve: Curves.easeInOut),
    );

    if (!widget.isForChat) {
      _introAnimController.repeat(reverse: true);
    }
    _lightningAnimController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.selectedWitch != null) {
      _activeWitch = widget.selectedWitch!;
    } else {
      final allowedWitches = getLocalizedWitches(context).where((w) => w.id == 'morgan' || w.id == 'karen').toList();
      if (allowedWitches.isNotEmpty) {
        _activeWitch = allowedWitches[math.Random().nextInt(allowedWitches.length)];
      } else {
        _activeWitch = getLocalizedWitches(context).first;
      }
    }
  }

  @override
  void dispose() {
    _introAnimController.dispose();
    _lightningAnimController.dispose();
    _nameController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _startSajuInput() {
    setState(() {
      _currentState = ReadingState.picking;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSajuInputDialog();
    });
  }

  void _showSajuInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple.shade900,
          title: Text(AppLocalizations.of(context)!.sajuInputTitle, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: '이름',
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: _yearController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.sajuInputYear,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: _monthController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.sajuInputMonth,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: _dayController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.sajuInputDay,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: _timeController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.sajuInputTime,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _currentState = ReadingState.intro);
              },
              child: Text('취소', style: const TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                _sajuData = '이름: ${_nameController.text}\n생년월일시: ${_yearController.text}년 ${_monthController.text}월 ${_dayController.text}일 ${_timeController.text}시';
                Navigator.pop(ctx);
                _startReading();
              },
              child: Text('확인', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startReading() async {
    setState(() {
      _currentState = ReadingState.reading;
      _aiReadingText = '';
      _isAiTyping = true;
    });

    // AudioService().playSound('tinkle_sound.mp3');

    final languageCode = AppLocalizations.of(context)!.localeName;
    final stream = ShamanAiService.instance.getSajuReadingStream(_sajuData, _activeWitch.personalityPrompt, languageCode);

    try {
      await for (final chunk in stream) {
        if (!mounted) return;
        setState(() {
          _aiReadingText += chunk;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _aiReadingText = 'AI 연결 오류';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAiTyping = false;
          _currentState = ReadingState.result;
        });
        _autoSaveDiary();
        
        // Play TTS if applicable based on the generated text
        // AudioService().speak(_aiReadingText, _activeWitch.id);
      }
    }
  }

  void _autoSaveDiary() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final diary = SajuDiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sajuData: _sajuData,
        myNote: '',
        resultText: _aiReadingText,
        date: DateTime.now(),
        witchId: _activeWitch.id,
      );
      await DiaryService.instance.saveDiary(diary);
      if (mounted) {
        setState(() {
          _currentDiary = diary;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildCurrentStateView(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStateView() {
    switch (_currentState) {
      case ReadingState.intro:
        return _buildIntroView();
      case ReadingState.picking:
      case ReadingState.reading:
        return _buildReadingAnimationView();
      case ReadingState.result:
        return _buildResultView();
    }
  }

  Widget _buildIntroView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: _startSajuInput,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amberAccent.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const CustomImageIcon(
                    'assets/images/ic_reading.png',
                    
                    
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            '사주팔자 보기',
            style: const TextStyle(
              
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingAnimationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _lightningAnimController,
            builder: (context, child) {
              return Opacity(
                opacity: _currentState == ReadingState.reading ? _lightningAnimController.value : 0.0,
                child: const Icon(Icons.flash_on,  size: 100),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            _currentState == ReadingState.reading ? "사주를 풀이하는 중입니다..." : "사주 정보를 입력하세요...",
            style: const TextStyle( fontSize: 18),
          ),
          if (_currentState == ReadingState.reading)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                _aiReadingText,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                maxLines: 5,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          GlassContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  _sajuData,
                  style: const TextStyle( fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  _aiReadingText,
                  style: const TextStyle( fontSize: 16, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_currentDiary == null && FirebaseAuth.instance.currentUser == null)
            TextButton.icon(
              icon: const Icon(Icons.save, ),
              label: Text('저장하려면 로그인하세요', style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
              },
            )
          else if (_currentDiary != null)
            const Text(
              '다이어리에 자동 저장되었습니다.',
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                _currentState = ReadingState.intro;
              });
            },
            child: Text('다시보기'),
          ),
        ],
      ),
    );
  }
}
