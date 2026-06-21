import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipCardWidget extends StatefulWidget {
  final String frontImagePath;
  final String backImagePath;
  final bool isFlipped;
  final double width;
  final double height;
  final Duration duration;
  final bool isReversed;

  const FlipCardWidget({
    super.key,
    required this.frontImagePath,
    this.backImagePath = 'assets/images/card_back.jpg',
    this.isFlipped = false,
    this.width = 100,
    this.height = 160,
    this.duration = const Duration(milliseconds: 600),
    this.isReversed = false,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = false;

  @override
  void initState() {
    super.initState();
    _isFrontVisible = widget.isFlipped;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * math.pi;
        if (angle >= math.pi / 2) {
          _isFrontVisible = true;
        } else {
          _isFrontVisible = false;
        }

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle),
            child: _isFrontVisible
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(math.pi)
                      ..rotateZ(widget.isReversed ? math.pi : 0), // 역방향 회전
                    child: _buildCardFace(widget.frontImagePath),
                  )
                : _buildCardFace(widget.backImagePath),
        );
      },
    );
  }

  Widget _buildCardFace(String imagePath) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
