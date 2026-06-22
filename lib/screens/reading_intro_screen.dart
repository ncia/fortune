import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../data/shaman_data.dart';
import '../widgets/shaman_profile_dialog.dart';
import '../services/tts_service.dart';

class ReadingIntroScreen extends StatefulWidget {
  final void Function(BuildContext, Witch) onStart;

  const ReadingIntroScreen({super.key, required this.onStart});

  @override
  State<ReadingIntroScreen> createState() => _ReadingIntroScreenState();
}

class _ReadingIntroScreenState extends State<ReadingIntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _purpleAnimController;
  late Animation<double> _glowAnimation;
  late String _currentBackgroundImage;
  bool _isInit = false;
  
  late List<Witch> _witches;
  late Witch _selectedWitch;
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _purpleAnimController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 3)
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.1, end: 0.6).animate(
      CurvedAnimation(parent: _purpleAnimController, curve: Curves.easeInOutSine)
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _witches = getLocalizedWitches(context);
      _selectedWitch = _witches.first;
      _currentBackgroundImage = _selectedWitch.imagePath;
      _isInit = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playGreeting();
      });
    }
  }

  void _playGreeting() {
    _ttsService.stop();
    // TTS ?�성 ?�생 ?�거 ?�청???�라 주석 처리
    // final greeting = '?�떤 ?�명???�여?�볼까요? ?�신??미래가 궁금?�군??';
    // _ttsService.speak(_selectedWitch, greeting, Localizations.localeOf(context).languageCode);
  }

  void _changeWitch(Witch witch) {
    setState(() {
      _selectedWitch = witch;
      _currentBackgroundImage = witch.imagePath;
    });
    _playGreeting();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _purpleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 배경 ?��?지 ?�체 ??��
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              _currentBackgroundImage,
              key: ValueKey(_currentBackgroundImage),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          
          // 2. 마�?(중앙)�??�외?�고 배경 쪽에�?보라??불빛???�쉬??빛나???�과
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2), // 마�????�단 중심 ?�치
                    radius: 1.2,
                    colors: [
                      Colors.transparent, // 중앙(마�?)?� ?�명?�게 ?��?
                      Colors.purple.withOpacity(_glowAnimation.value),
                      Colors.deepPurple.withOpacity(_glowAnimation.value * 0.8),
                    ],
                    stops: const [0.35, 0.8, 1.0], // 0.35까�????�명?�서 마�?가 보임
                  ),
                ),
              );
            },
          ),
          
          // 3. ?�스??가?�성???�한 ?�주 ?��? ?�두???�버?�이
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Witch Selector
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showWitchProfileDialog(context, _selectedWitch);
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.purpleAccent,
                                  image: DecorationImage(
                                    image: AssetImage(_selectedWitch.imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _selectedWitch.name,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _selectedWitch.title,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.pinkAccent),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppLocalizations.of(context)!.readingIntroSelectWitch,
                                    style: const TextStyle(fontSize: 11, color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Witch>(
                              value: _selectedWitch,
                              dropdownColor: Colors.deepPurple.shade900.withOpacity(0.9),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
                              isExpanded: true,
                              items: _witches.map((Witch witch) {
                                return DropdownMenuItem<Witch>(
                                  value: witch,
                                  child: Text(
                                    '${witch.name} - ${witch.title}',
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Witch? newValue) {
                                if (newValue != null && newValue.id != _selectedWitch.id) {
                                  _changeWitch(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Greeting text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    AppLocalizations.of(context)!.readingIntroGreeting,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      height: 1.4,
                      shadows: [
                        const Shadow(
                          color: Colors.black87,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Button
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
                  child: InkWell(
                    onTap: () {
                      _ttsService.stop();
                      widget.onStart(context, _selectedWitch);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ]
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.readingIntroStart,
                        style: const TextStyle(
                          fontSize: 18, 
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

