import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/letter_data.dart';

/// Mini-game 2 — Letter Sort.
///
/// Letters fall from the top of the screen. Child drags each into the correct
/// UPPERCASE or lowercase bin at the bottom.
///
/// No fail state — score accumulates.
class LetterSortScreen extends StatefulWidget {
  const LetterSortScreen({super.key});

  @override
  State<LetterSortScreen> createState() => _LetterSortScreenState();
}

class _LetterSortScreenState extends State<LetterSortScreen>
    with TickerProviderStateMixin {
  static const Duration _fallDuration = Duration(seconds: 5);
  static const Duration _spawnInterval = Duration(seconds: 3);

  final List<_FallingLetter> _letters = [];
  final Random _rng = Random();
  int _score = 0;
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _spawnLetter();
    _spawnTimer = Timer.periodic(_spawnInterval, (_) => _spawnLetter());
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    for (final l in _letters) {
      l.controller.dispose();
    }
    super.dispose();
  }

  void _spawnLetter() {
    if (!mounted || _letters.length >= 4) return;
    final data = alphabet[_rng.nextInt(alphabet.length)];
    // Randomly show uppercase or lowercase display
    final showUpper = _rng.nextBool();
    final display = showUpper ? data.letter : data.lowercase;
    final isActuallyUpper = showUpper;
    final x = 0.05 + _rng.nextDouble() * 0.8;
    final controller =
        AnimationController(vsync: this, duration: _fallDuration);

    final item = _FallingLetter(
      display: display,
      isUppercase: isActuallyUpper,
      xFraction: x,
      controller: controller,
    );

    setState(() => _letters.add(item));

    controller.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _letters.remove(item);
        item.controller.dispose();
      });
    });
  }

  void _onSort(_FallingLetter item, bool droppedInUpper) {
    final correct = item.isUppercase == droppedInUpper;
    final audio = context.read<AudioService>();

    setState(() {
      _letters.remove(item);
      item.controller.dispose();
    });

    if (correct) {
      _score++;
      audio.playSfx(SfxType.correct);
    } else {
      audio.playSfx(SfxType.wrong);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const binHeight = 100.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Sort'),
        backgroundColor: KidsReadTheme.primaryOrange,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: KidsReadTheme.spacingM),
            child: Center(
              child: Text(
                'Score: $_score',
                style: KidsReadTheme.headingMedium
                    .copyWith(color: KidsReadTheme.surfaceWhite),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Falling letters
          ..._letters.map((item) {
            return AnimatedBuilder(
              animation: item.controller,
              builder: (context, child) {
                final y = item.controller.value *
                    (size.height - binHeight - 80);
                final x = size.width * item.xFraction;
                return Positioned(left: x, top: y, child: child!);
              },
              child: Draggable<_FallingLetter>(
                data: item,
                onDragStarted: () {
                  setState(() {
                    _letters.remove(item);
                    item.controller.stop();
                  });
                },
                feedback: _LetterChip(letter: item.display, color: KidsReadTheme.primaryOrange),
                childWhenDragging: const SizedBox.shrink(),
                child: _LetterChip(
                    letter: item.display,
                    color: item.isUppercase
                        ? KidsReadTheme.primaryBlue
                        : KidsReadTheme.primaryPurple),
              ),
            );
          }),

          // Bins at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                _SortBin(
                  label: 'ABC',
                  sublabel: 'UPPERCASE',
                  color: KidsReadTheme.primaryBlue,
                  onAccept: (item) => _onSort(item, true),
                ),
                _SortBin(
                  label: 'abc',
                  sublabel: 'lowercase',
                  color: KidsReadTheme.primaryPurple,
                  onAccept: (item) => _onSort(item, false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FallingLetter {
  final String display;
  final bool isUppercase;
  final double xFraction;
  final AnimationController controller;

  _FallingLetter({
    required this.display,
    required this.isUppercase,
    required this.xFraction,
    required this.controller,
  });
}

class _LetterChip extends StatelessWidget {
  const _LetterChip({required this.letter, required this.color});

  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: KidsReadTheme.radiusMedium,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: KidsReadTheme.headingLarge
              .copyWith(color: KidsReadTheme.surfaceWhite, fontSize: 26),
        ),
      ),
    );
  }
}

class _SortBin extends StatelessWidget {
  const _SortBin({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onAccept,
  });

  final String label;
  final String sublabel;
  final Color color;
  final void Function(_FallingLetter) onAccept;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<_FallingLetter>(
        onAcceptWithDetails: (details) => onAccept(details.data),
        builder: (context, candidates, _) {
          final hovering = candidates.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 100,
            color:
                hovering ? color.withOpacity(0.9) : color.withOpacity(0.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: KidsReadTheme.headingLarge.copyWith(
                    color: KidsReadTheme.surfaceWhite,
                    fontSize: 28,
                  ),
                ),
                Text(
                  sublabel,
                  style: KidsReadTheme.bodyLarge.copyWith(
                    color: KidsReadTheme.surfaceWhite.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
