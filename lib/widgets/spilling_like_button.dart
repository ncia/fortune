import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpillingLikeButton extends StatefulWidget {
  final Widget child; // The actual Like button/icon/text to wrap
  final bool isEnabled;

  const SpillingLikeButton({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  @override
  State<SpillingLikeButton> createState() => _SpillingLikeButtonState();
}

class _SpillingLikeButtonState extends State<SpillingLikeButton> with TickerProviderStateMixin {
  final List<_FloatingParticle> _particles = [];
  final Random _random = Random();
  Timer? _timer;

  static const List<dynamic> _particleIcons = [
    FontAwesomeIcons.solidHeart,
    FontAwesomeIcons.solidStar,
    FontAwesomeIcons.wandMagicSparkles,
    Icons.celebration, // 축포
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEnabled) {
      _startAmbientSpill();
    }
  }

  @override
  void didUpdateWidget(SpillingLikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled && !oldWidget.isEnabled) {
      _startAmbientSpill();
    } else if (!widget.isEnabled && oldWidget.isEnabled) {
      _timer?.cancel();
    }
  }

  void _startAmbientSpill() {
    _scheduleNextSpill();
  }

  void _scheduleNextSpill() {
    if (!mounted || !widget.isEnabled) return;
    
    final delay = Duration(milliseconds: 1500 + _random.nextInt(2000));
    _timer = Timer(delay, () {
      if (mounted) {
        _spawnAmbientParticle();
        _scheduleNextSpill();
      }
    });
  }

  void _spawnAmbientParticle() {
    int count = _random.nextInt(100) < 40 ? 2 : 1; 
    
    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1500 + _random.nextInt(1500)),
      );
      
      final icon = _particleIcons[_random.nextInt(_particleIcons.length)];
      final isHeart = icon == FontAwesomeIcons.solidHeart;
      final size = isHeart ? (10 + _random.nextDouble() * 8) : (12 + _random.nextDouble() * 10);
      
      final particle = _FloatingParticle(
        controller: controller,
        startX: -5.0 + _random.nextDouble() * 20, 
        targetX: -20.0 + _random.nextDouble() * 40, 
        targetY: 40 + _random.nextDouble() * 80, 
        size: size,
        color: Colors.pinkAccent.withOpacity(0.5 + _random.nextDouble() * 0.5), 
        icon: icon,
      );
      
      setState(() {
        _particles.add(particle);
      });
      
      controller.forward().then((_) {
        if (mounted) {
          setState(() {
            _particles.remove(particle);
          });
        }
        controller.dispose();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var particle in _particles) {
      particle.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        widget.child, 
        
        ..._particles.map((particle) {
          return AnimatedBuilder(
            animation: particle.controller,
            builder: (context, child) {
              final progress = particle.controller.value;
              
              final curve = Curves.easeOut.transform(progress);
              final y = particle.targetY * curve;
              
              final wobble = sin(progress * pi * 3) * 8;
              final x = particle.startX + (particle.targetX * progress) + wobble;
              
              final fadeOpacity = progress > 0.5 ? 1.0 - ((progress - 0.5) * 2) : 1.0;
              final combinedOpacity = fadeOpacity * particle.color.opacity;
              
              return Positioned(
                left: x,
                bottom: 8 + y, 
                child: Opacity(
                  opacity: combinedOpacity,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.pinkAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: particle.icon is IconData
                        ? Icon(
                            particle.icon as IconData,
                            color: Colors.white,
                            size: particle.size,
                          )
                        : FaIcon(
                            particle.icon,
                            color: Colors.white,
                            size: particle.size,
                          ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

class _FloatingParticle {
  final AnimationController controller;
  final double startX;
  final double targetX;
  final double targetY;
  final double size;
  final Color color;
  final dynamic icon;

  _FloatingParticle({
    required this.controller,
    required this.startX,
    required this.targetX,
    required this.targetY,
    required this.size,
    required this.color,
    required this.icon,
  });
}
