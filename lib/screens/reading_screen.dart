import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/flip_card.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import '../data/tarot_data.dart';
import '../data/witch_data.dart';
import '../data/spread_type.dart';
import '../widgets/spread_layouts.dart';
import 'card_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import '../services/audio_service.dart';
import '../services/economy_service.dart';
import 'diary_edit_screen.dart';
import '../data/witch_data.dart';
import '../services/tarot_ai_service.dart';
import '../services/tarot_ai_service.dart';
import '../services/tts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/witch_profile_dialog.dart';
import '../services/diary_service.dart';
import '../data/tarot_diary.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum ReadingState { intro, picking, result }

class ReadingScreen extends StatefulWidget {
  final bool isForChat;
  final SpreadType spreadType;
  final void Function(List<String>)? onCardsPicked;
  final Witch? selectedWitch;
  final bool skipIntro;

  const ReadingScreen({
    super.key,
    this.isForChat = false,
    this.spreadType = SpreadType.threeCard,
    this.onCardsPicked,
    this.selectedWitch,
    this.skipIntro = false,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> with TickerProviderStateMixin {
  ReadingState _currentState = ReadingState.intro;
  late AnimationController _introAnimController;
  late AnimationController _lightningAnimController;
  late Animation<double> _scaleAnimation;
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  
  // Card Picking State
  bool _isFanSpread = true; // 레이아웃 토글
  bool _showLightning = false; // 번개 이펙트 토글
  final int _totalCards = 78; // 전체 78장
  final List<int> _selectedCardIndices = [];
  
  late List<TarotCardData> _shuffledDeck;
  late List<bool> _shuffledReversed;
  Witch? _activeWitch;
  bool _isInit = false;
  
  final TarotAiService _aiService = TarotAiService();
  final TtsService _ttsService = TtsService();
  String _aiReadingText = '';
  bool _isAiTyping = false;
  TarotDiary? _currentDiary;

  @override
  void initState() {
    super.initState();
    if (widget.isForChat || widget.skipIntro) {
      _currentState = ReadingState.picking;
    }
    _introAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _lightningAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // 매우 빠르게 번쩍임
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _introAnimController, curve: Curves.easeInOut),
    );
    
    if (!widget.isForChat) {
      _introAnimController.repeat(reverse: true);
    }
    
    _lightningAnimController.repeat(reverse: true);
    
    _shuffledDeck = List.from(getTarotDeck(context))..shuffle();
    _shuffledReversed = List.generate(78, (_) => math.Random().nextBool());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (widget.selectedWitch != null) {
        _activeWitch = widget.selectedWitch;
      } else {
        final allowedWitches = getLocalizedWitches(context).where((w) => w.id == 'morgan' || w.id == 'karen').toList();
        _activeWitch = allowedWitches[math.Random().nextInt(allowedWitches.length)];
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _introAnimController.dispose();
    _lightningAnimController.dispose();
    super.dispose();
  }

  void _startPicking() async {
    if (!widget.isForChat && !widget.skipIntro) {
      final economy = EconomyService();
      if (economy.coins < 1) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.deepPurple.shade900,
            title: Text(AppLocalizations.of(context)!.coinShortageTitle, style: const TextStyle(color: Colors.white)),
            content: Text(AppLocalizations.of(context)!.coinShortageContent, style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.of(context)!.dialogOk, style: const TextStyle(color: Colors.amberAccent)),
              ),
            ],
          ),
        );
        return;
      }

      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.deepPurple.shade900,
          title: Text(AppLocalizations.of(context)!.proceedReadingTitle, style: const TextStyle(color: Colors.white)),
          content: Text(AppLocalizations.of(context)!.proceedReadingContent, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(AppLocalizations.of(context)!.dialogCancel, style: const TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
              child: Text(AppLocalizations.of(context)!.dialogProceed, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      final success = await economy.deductCoin(1);
      if (!success) return;
    }

    AudioService().playThunderSound();
    setState(() {
      _currentState = ReadingState.picking;
    });
    _introAnimController.stop();
  }

  void _onCardTapped(int index) {
    if (_currentState != ReadingState.picking) return;
    if (_selectedCardIndices.contains(index)) return;
    if (_selectedCardIndices.length >= widget.spreadType.cardCount) return;

    setState(() {
      _selectedCardIndices.add(index);
    });

    if (_selectedCardIndices.length == widget.spreadType.cardCount) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showLightning = true;
          });
          
          Future.delayed(const Duration(seconds: 3), () async {
            if (mounted) {
              setState(() {
                _showLightning = false;
                _currentState = ReadingState.result;
              });
              
              if (!widget.isForChat) {
                _generateAiReading();
                await EconomyService().addMagicDust(10);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.magicDustObtained(10), style: const TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.purple,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            }
          });
        }
      });
    }
  }

  void _generateAiReading() async {
    if (widget.selectedWitch == null) return;
    setState(() {
      _isAiTyping = true;
      _aiReadingText = '';
    });
    
    List<String> pickedCards = [];
    for (int i = 0; i < widget.spreadType.cardCount; i++) {
      pickedCards.add(_shuffledDeck[_selectedCardIndices[i]].id);
    }
    
    String spreadName = widget.spreadType.name;
    String prompt = "사용자가 질문 없이 $spreadName 배열법으로 타로카드를 뽑았습니다. 뽑힌 카드들을 배열법의 각 위치에 맞게 해석하고 전반적인 운세와 조언을 해주세요. 답변은 반드시 당신의 페르소나 톤으로 바로 시작해주세요.";
    
    final stream = _aiService.getTarotReadingStream(prompt, pickedCards, widget.selectedWitch!.personalityPrompt, Localizations.localeOf(context).languageCode);
    
    await for (final chunk in stream) {
      if (mounted) {
        setState(() {
          _aiReadingText += chunk;
        });
      }
    }
    if (mounted) {
      setState(() {
        _isAiTyping = false;
      });
      // 마크다운 제거
      String cleanText = _aiReadingText.replaceAll(RegExp(r'[*#]+'), '').trim();
      _ttsService.speakLongText(widget.selectedWitch!, cleanText, Localizations.localeOf(context).languageCode);

      // 다이어리 자동 저장
      _autoSaveDiary(pickedCards, cleanText);
    }
  }

  void _autoSaveDiary(List<String> pickedCards, String cleanText) async {
    try {
      List<bool> reversals = [];
      List<String> labels = [];
      List<String> meanings = [];
      
      List<String> spreadLabels = [];
      if (widget.spreadType.name == 'oneCard') {
        spreadLabels = [AppLocalizations.of(context)!.readingSpreadLabelToday];
      } else if (widget.spreadType.name == 'threeCard') {
        spreadLabels = [AppLocalizations.of(context)!.readingSpreadLabelPast1, AppLocalizations.of(context)!.readingSpreadLabelPresent2, AppLocalizations.of(context)!.readingSpreadLabelFuture3];
      } else if (widget.spreadType.name == 'fourCard') {
        spreadLabels = [AppLocalizations.of(context)!.readingSpreadLabelCurrentSituation1, AppLocalizations.of(context)!.readingSpreadLabelCauseOfProblem2, AppLocalizations.of(context)!.readingSpreadLabelAdviceForResolution3, AppLocalizations.of(context)!.readingSpreadLabelExpectedResult4];
      } else if (widget.spreadType.name == 'fiveCard') {
        spreadLabels = [AppLocalizations.of(context)!.readingSpreadLabelCurrent1, AppLocalizations.of(context)!.readingSpreadLabelPast2, AppLocalizations.of(context)!.readingSpreadLabelFuture3Alt, AppLocalizations.of(context)!.readingSpreadLabelCause4, AppLocalizations.of(context)!.readingSpreadLabelPotential5];
      } else if (widget.spreadType.name == 'celticCross') {
        spreadLabels = [AppLocalizations.of(context)!.readingSpreadLabelCurrentSituation1Alt, AppLocalizations.of(context)!.readingSpreadLabelObstacle2, AppLocalizations.of(context)!.readingSpreadLabelUnconscious3, AppLocalizations.of(context)!.readingSpreadLabelPast4, AppLocalizations.of(context)!.readingSpreadLabelConsciousGoal5, AppLocalizations.of(context)!.readingSpreadLabelNearFuture6, AppLocalizations.of(context)!.readingSpreadLabelAttitude7, AppLocalizations.of(context)!.readingSpreadLabelExternalEnvironment8, AppLocalizations.of(context)!.readingSpreadLabelHopesAndFears9, AppLocalizations.of(context)!.readingSpreadLabelFinalResult10];
      } else if (widget.spreadType.name == 'hexagram') {
        spreadLabels = [AppLocalizations.of(context)!.readingSpreadLabelPast1, AppLocalizations.of(context)!.readingSpreadLabelPresent2, AppLocalizations.of(context)!.readingSpreadLabelFuture3, AppLocalizations.of(context)!.readingSpreadLabelAdvice4, AppLocalizations.of(context)!.readingSpreadLabelSurroundings5, AppLocalizations.of(context)!.readingSpreadLabelResult6];
      } else {
        spreadLabels = List.generate(widget.spreadType.cardCount, (i) => AppLocalizations.of(context)!.chatPositionLabel(i + 1));
      }
      
      for (int i = 0; i < widget.spreadType.cardCount; i++) {
        final idx = _selectedCardIndices[i];
        reversals.add(_shuffledReversed[idx]);
        labels.add(spreadLabels.length > i ? spreadLabels[i] : AppLocalizations.of(context)!.chatPositionLabel(i + 1));
        meanings.add(!_shuffledReversed[idx] ? _shuffledDeck[idx].uprightDesc : _shuffledDeck[idx].reversedDesc);
      }

      final diary = TarotDiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardId: pickedCards.isNotEmpty ? pickedCards[0] : '',
        spreadType: widget.spreadType.name,
        myNote: AppLocalizations.of(context)!.diaryTarotReading,
        resultText: cleanText,
        date: DateTime.now(),
        cardIds: pickedCards,
        cardReversals: reversals,
        positionLabels: labels,
        cardMeanings: meanings,
        witchId: widget.selectedWitch?.id,
      );

      if (mounted) {
        setState(() {
          _currentDiary = diary;
        });
      }

      await DiaryService.instance.saveToCloudOnly(diary);
    } catch (e) {
      debugPrint('Error auto-saving diary: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        useSafeArea: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: _buildCurrentState(),
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case ReadingState.intro:
        return _buildIntroView();
      case ReadingState.picking:
        return _buildPickingView();
      case ReadingState.result:
        return _buildResultView();
    }
  }

  Widget _buildIntroView() {
    return Stack(
      key: const ValueKey('intro'),
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              _activeWitch?.imagePath ?? 'assets/images/witch_morgan.jpg',
              key: ValueKey(_activeWitch?.imagePath ?? 'assets/images/witch_morgan.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error, color: Colors.white54, size: 50),
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: GlowingLights(),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x99120024),
                  Color(0xFF120024),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.readingIntroTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.readingIntroSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: _startPicking,
                  child: GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    borderRadius: 30,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.readingIntroButton,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickingView() {
    return Stack(
      children: [
        SafeArea(
          key: const ValueKey('picking'),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              final double screenHeight = constraints.maxHeight;
              final double slotWidth = 90.0;
              final double slotHeight = 140.0;
              
              // 상단 빈 슬롯이 시작되는 정확한 Y 좌표
              // Padding top 80 + 상단 텍스트Row 대략 30 + SizedBox 20 = 130
              final double slotsTopY = 130.0; 

              return Stack(
                clipBehavior: Clip.none,
                children: [
              // 1. 배경 및 UI 요소 레이어
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0, left: 24.0, right: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.pickCardsText(widget.spreadType.cardCount),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isFanSpread = !_isFanSpread;
                            });
                          },
                          icon: const Icon(Icons.swap_horiz, color: Colors.white),
                          label: Text(
                            _isFanSpread ? AppLocalizations.of(context)!.layoutFan : AppLocalizations.of(context)!.layoutStacked,
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white24,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 빈 슬롯은 표시하지 않고 카드 겹침 레이아웃을 사용
                  SizedBox(height: slotHeight),
                ],
              ),
              
              // 2. 인터랙티브 카드 레이어 (전체 화면 기준 절대 좌표로 애니메이션)
              ...List.generate(_totalCards, (index) {
                final isSelected = _selectedCardIndices.contains(index);
                final selectedOrder = _selectedCardIndices.indexOf(index);
                
                double targetTop;
                double targetLeft;
                double targetAngle = 0;

                if (isSelected) {
                  targetTop = slotsTopY; 
                  if (widget.spreadType.cardCount <= 3) {
                    double activeSpacing = (screenWidth - (slotWidth * widget.spreadType.cardCount)) / (widget.spreadType.cardCount + 1);
                    targetLeft = activeSpacing + (selectedOrder * (slotWidth + activeSpacing));
                  } else {
                    double stackTotalWidth = slotWidth + (_selectedCardIndices.length - 1) * 12;
                    double startLeft = (screenWidth / 2) - (stackTotalWidth / 2);
                    targetLeft = startLeft + (selectedOrder * 12);
                  }
                  targetAngle = 0;
                } else {
                  // 바닥에 펼쳐지는 위치 (화면 하단 기준)
                  final baseY = screenHeight - slotHeight - 40; 
                  if (_isFanSpread) {
                    double normalized = (index - (_totalCards - 1) / 2) / ((_totalCards - 1) / 2);
                    targetAngle = normalized * math.pi / 3.5;
                    targetLeft = (screenWidth / 2) - (slotWidth / 2) + (normalized * 140);
                    targetTop = baseY + (normalized * normalized * 60);
                  } else {
                    double normalized = (index - (_totalCards - 1) / 2) / ((_totalCards - 1) / 2);
                    targetAngle = 0;
                    targetLeft = (screenWidth / 2) - (slotWidth / 2) + (normalized * 130);
                    targetTop = baseY + 20;
                  }
                }

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  top: targetTop,
                  left: targetLeft,
                  child: AnimatedRotation(
                    turns: targetAngle / (math.pi * 2),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    child: GestureDetector(
                      onTap: () => _onCardTapped(index),
                      child: Container(
                        width: slotWidth,
                        height: slotHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/card_back.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
                ],
              );
            },
          ),
        ),
        
        // 3. 번개 이펙트 레이어 (카드가 모두 선택된 후 3초간 표시)
        // 화면 전체를 덮도록 SafeArea 외부에 배치
        if (_showLightning) ...[
          // 화면 전체가 어두워지는 효과 (검은 배경 매칭)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _lightningAnimController,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withOpacity(0.85 + (_lightningAnimController.value * 0.15)), // 0.85 ~ 1.0
                );
              },
            ),
          ),
          // 수정구(번개) 이미지 (크기 반으로 축소)
          Positioned.fill(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: AnimatedBuilder(
                  animation: _lightningAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.6 + (_lightningAnimController.value * 0.4),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/lighting.webp'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultView() {
    return SafeArea(
      key: const ValueKey('result'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.readingSpreadTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.readingSpreadSubtitle,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SpreadLayoutBuilder(
                      spreadType: widget.spreadType,
                      selectedCardIndices: _selectedCardIndices,
                      shuffledDeck: _shuffledDeck,
                      shuffledReversed: _shuffledReversed,
                      isForChat: widget.isForChat,
                      onCardsPicked: widget.onCardsPicked,
                    ),
                    const SizedBox(height: 20),
                    if (!widget.isForChat && widget.selectedWitch != null)
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showWitchProfileDialog(context, widget.selectedWitch!);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(widget.selectedWitch!.imagePath),
                                    radius: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.witchTarotReading(widget.selectedWitch!.name),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const Spacer(),
                                if (_isAiTyping)
                                  const SizedBox(
                                    width: 16, height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purpleAccent),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _aiReadingText.isEmpty && _isAiTyping ? AppLocalizations.of(context)!.readingFateFragments : _aiReadingText,
                              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (!widget.isForChat)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        _shareReadingResult();
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: Text(AppLocalizations.of(context)!.buttonShare),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amberAccent,
                        side: const BorderSide(color: Colors.amberAccent),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (_currentDiary != null)
                      OutlinedButton.icon(
                        onPressed: () async {
                          if (_currentDiary != null) {
                            await DiaryService.instance.saveToLocalOnly(_currentDiary!);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.readingSavedToDevice, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.save_alt, size: 18),
                        label: Text(AppLocalizations.of(context)!.buttonSaveReading),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.lightGreenAccent,
                          side: const BorderSide(color: Colors.lightGreenAccent),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(AppLocalizations.of(context)!.buttonSelectSpread),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(AppLocalizations.of(context)!.buttonSelectOtherWitch),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _shareReadingResult() async {
    try {
      final text = AppLocalizations.of(context)!.shareResultText;

      if (kIsWeb) {
        // 웹에서는 파일 시스템 접근이 불가능하므로 텍스트만 공유
        await Share.share(text);
        return;
      }

      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      // Capture image
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      
      final pngBytes = byteData.buffer.asUint8List();
      
      // Save temporarily
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tarot_result.png');
      await file.writeAsBytes(pngBytes);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );
    } catch (e) {
      print('Error sharing image: $e');
    }
  }
}

class GlowingLights extends StatefulWidget {
  const GlowingLights({super.key});

  @override
  _GlowingLightsState createState() => _GlowingLightsState();
}

class _GlowingLightsState extends State<GlowingLights> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();
  late List<LightParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _particles = List.generate(20, (index) => LightParticle(_random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: LightsPainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class LightParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;

  LightParticle(math.Random random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        size = random.nextDouble() * 20 + 10,
        speed = random.nextDouble() * 2 + 1,
        phase = random.nextDouble() * math.pi * 2;
}

class LightsPainter extends CustomPainter {
  final List<LightParticle> particles;
  final double time;

  LightsPainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final double opacity = (math.sin(time * math.pi * 2 * p.speed + p.phase) + 1) / 2;
      
      final paint = Paint()
        ..color = Colors.purpleAccent.withOpacity(opacity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.size, paint);
      
      final innerPaint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.size * 0.3, innerPaint);
    }
  }

  @override
  bool shouldRepaint(LightsPainter oldDelegate) => true;
}
