import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/letter_data.dart';

/// Mini-game 1 — Bubble Pop.
///
/// Letters drift upward as bubbles. The voice names a letter; the child taps
/// the correct bubble before it floats off-screen.
///
/// No fail state — score accumulates indefinitely. Purely for fun.
class BubblePopScreen extends StatefulWidget {
  const BubblePopScreen({super.key});

  @override
  State<BubblePopScreen> createState() => _BubblePopScreenState();
}

class _BubblePopScreenState extends State<BubblePopScreen>
    with TickerProviderStateMixin {
  static const int _maxBubbles = 5;
  static const Duration _spawnInterval = Duration(seconds: 2);
  static const Duration _riseTime = Duration(seconds: 6);

  final List<_Bubble> _bubbles = [];
  final Random _rng = Random();
  String? _targetLetter;
  int _score = 0;
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _spawnTimer = Timer.periodic(_spawnInterval, (_) => _spawnBubble());
    _spawnBubble();
    Future.delayed(const Duration(milliseconds: 500), _announceTarget);
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    for (final b in _bubbles) {
      b.controller.dispose();
    }
    super.dispose();
  }

  String _randomLetter() =>
      alphabet[_rng.nextInt(alphabet.length)].letter;

  void _spawnBubble() {
    if (!mounted) return;
    if (_bubbles.length >= _maxBubbles) return;

    final letter = _randomLetter();
    final controller = AnimationController(vsync: this, duration: _riseTime);
    final xFraction = 0.05 + _rng.nextDouble() * 0.85;

    final bubble = _Bubble(
      letter: letter,
      controller: controller,
      xFraction: xFraction,
      id: UniqueKey(),
    );

    setState(() => _bubbles.add(bubble));

    controller.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _bubbles.remove(bubble);
        bubble.controller.dispose();
      });
      // Announce next target when bubbles clear
      if (_targetLetter == null || !_bubbles.any((b) => b.letter == _targetLetter)) {
        _announceTarget();
      }
    });
  }

  void _announceTarget() {
    if (!mounted || _bubbles.isEmpty) return;
    final target = _bubbles[_rng.nextInt(_bubbles.length)].letter;
    setState(() => _targetLetter = target);
    context.read<AudioService>().speakLetter(target);
  }

  void _onBubbleTap(_Bubble bubble) {
    if (bubble.letter != _targetLetter) {
      context.read<AudioService>().playSfx(SfxType.wrong);
      return;
    }
    context.read<AudioService>().playSfx(SfxType.correct);
    setState(() {
      _score++;
      _bubbles.remove(bubble);
      bubble.controller.dispose();
      _targetLetter = null;
    });

    Future.delayed(const Duration(milliseconds: 300), _announceTarget);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubble Pop'),
        backgroundColor: KidsReadTheme.primaryBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: KidsReadTheme.spacingM),
            child: Center(
              child: Text(
                'Score: $_score',
                style: KidsReadTheme.headingMedium.copyWith(
                  color: KidsReadTheme.surfaceWhite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Target indicator
          if (_targetLetter != null)
            Positioned(
              top: KidsReadTheme.spacingL,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: KidsReadTheme.spacingL,
                    vertical: KidsReadTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: KidsReadTheme.primaryBlue,
                    borderRadius: KidsReadTheme.radiusLarge,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.volume_up_rounded,
                          color: KidsReadTheme.surfaceWhite),
                      const SizedBox(width: KidsReadTheme.spacingS),
                      Text(
                        'Pop the "$_targetLetter" bubble!',
                        style: KidsReadTheme.headingMedium.copyWith(
                          color: KidsReadTheme.surfaceWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bubbles
          ..._bubbles.map((bubble) {
            return AnimatedBuilder(
              animation: bubble.controller,
              builder: (context, child) {
                final y = size.height * (1 - bubble.controller.value) - 80;
                final x = size.width * bubble.xFraction;
                return Positioned(
                  left: x,
                  top: y,
                  child: child!,
                );
              },
              child: GestureDetector(
                onTap: () => _onBubbleTap(bubble),
                child: _BubbleWidget(
                  letter: bubble.letter,
                  isTarget: bubble.letter == _targetLetter,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Bubble {
  final String letter;
  final AnimationController controller;
  final double xFraction;
  final Key id;

  _Bubble({
    required this.letter,
    required this.controller,
    required this.xFraction,
    required this.id,
  });
}

class _BubbleWidget extends StatelessWidget {
  const _BubbleWidget({required this.letter, required this.isTarget});

  final String letter;
  final bool isTarget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isTarget
            ? KidsReadTheme.primaryYellow.withOpacity(0.85)
            : KidsReadTheme.primaryBlue.withOpacity(0.7),
        border: Border.all(
          color: isTarget
              ? KidsReadTheme.primaryOrange
              : KidsReadTheme.primaryBlue,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (isTarget
                    ? KidsReadTheme.primaryYellow
                    : KidsReadTheme.primaryBlue)
                .withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: KidsReadTheme.headingLarge.copyWith(
            color: isTarget ? KidsReadTheme.textDark : KidsReadTheme.surfaceWhite,
            fontSize: 28,
          ),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.06, 1.06),
          duration: 1200.ms,
          curve: Curves.easeInOut,
        );
  }
}
