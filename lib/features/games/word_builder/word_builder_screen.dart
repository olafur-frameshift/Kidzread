import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/word_data.dart';

/// Mini-game 3 — Word Builder.
///
/// Scrambled letters appear on screen. Child arranges them to spell the
/// pictured word before a timer runs out. No fail state — just try again.
class WordBuilderScreen extends StatefulWidget {
  const WordBuilderScreen({super.key});

  @override
  State<WordBuilderScreen> createState() => _WordBuilderScreenState();
}

class _WordBuilderScreenState extends State<WordBuilderScreen> {
  static const int _timeLimitSeconds = 20;

  final Random _rng = Random();
  late Word _targetWord;
  late List<String> _scrambled;
  late List<String?> _slots;
  int _score = 0;
  int _secondsLeft = _timeLimitSeconds;
  Timer? _timer;
  bool _solved = false;

  @override
  void initState() {
    super.initState();
    _loadWord();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadWord() {
    final word = cvcWords[_rng.nextInt(cvcWords.length)];
    _targetWord = word;
    _scrambled = word.text.split('')..shuffle(_rng);
    _slots = List.filled(word.text.length, null);
    _solved = false;
    _secondsLeft = _timeLimitSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().speakWord(_targetWord.text);
    });
  }

  void _tick(Timer t) {
    if (!mounted) return;
    if (_secondsLeft <= 0) {
      t.cancel();
      _timeUp();
      return;
    }
    setState(() => _secondsLeft--);
  }

  void _timeUp() {
    context.read<AudioService>().playEncouragement(EncouragementType.tryAgain);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(_loadWord);
    });
  }

  void _onLetterTap(int scrambledIndex) {
    final letter = _scrambled[scrambledIndex];
    // Find first empty slot
    final slotIndex = _slots.indexOf(null);
    if (slotIndex == -1) return;

    setState(() {
      _slots[slotIndex] = letter;
      _scrambled[scrambledIndex] = ''; // mark used
    });
    _checkWin();
  }

  void _onSlotTap(int slotIndex) {
    final letter = _slots[slotIndex];
    if (letter == null) return;
    // Return letter to scramble pool
    final emptyIndex = _scrambled.indexOf('');
    setState(() {
      _slots[slotIndex] = null;
      if (emptyIndex != -1) {
        _scrambled[emptyIndex] = letter;
      } else {
        _scrambled.add(letter);
      }
    });
  }

  void _checkWin() {
    if (_slots.any((s) => s == null)) return;
    final spelled = _slots.join();
    if (spelled == _targetWord.text) {
      _timer?.cancel();
      _score++;
      _solved = true;
      setState(() {});
      context.read<AudioService>().speakWord(_targetWord.text);
      context.read<AudioService>().playSfx(SfxType.correct);
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        setState(_loadWord);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsLeft / _timeLimitSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Builder'),
        backgroundColor: KidsReadTheme.primaryGreen,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KidsReadTheme.spacingL),
          child: Column(
            children: [
              // Timer bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: KidsReadTheme.radiusSmall,
                  color: KidsReadTheme.cardBackground,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: KidsReadTheme.radiusSmall,
                      color: progress > 0.4
                          ? KidsReadTheme.primaryGreen
                          : KidsReadTheme.wrongRed,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: KidsReadTheme.spacingM),
              Text('$_secondsLeft seconds', style: KidsReadTheme.bodyLarge),
              const SizedBox(height: KidsReadTheme.spacingXL),

              // Picture area
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: KidsReadTheme.cardBackground,
                  borderRadius: KidsReadTheme.radiusLarge,
                  border: Border.all(
                      color: _solved
                          ? KidsReadTheme.correctGreen
                          : KidsReadTheme.primaryGreen,
                      width: 3),
                ),
                child: const Center(
                  child: Icon(Icons.image_rounded,
                      size: 64, color: KidsReadTheme.lockedGrey),
                ),
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),

              // Slots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slots.length, (i) {
                  final letter = _slots[i];
                  return GestureDetector(
                    onTap: () => _onSlotTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                          horizontal: KidsReadTheme.spacingXS),
                      width: 52,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _solved
                            ? KidsReadTheme.correctGreen
                            : letter != null
                                ? KidsReadTheme.primaryGreen
                                : KidsReadTheme.cardBackground,
                        borderRadius: KidsReadTheme.radiusSmall,
                        border: Border.all(
                            color: KidsReadTheme.primaryGreen, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          letter?.toUpperCase() ?? '',
                          style: KidsReadTheme.headingLarge.copyWith(
                            color: KidsReadTheme.surfaceWhite,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),
              Text('Tap letters to build the word!',
                  style: KidsReadTheme.bodyLarge),
              const SizedBox(height: KidsReadTheme.spacingM),

              // Scrambled letter pool
              Wrap(
                spacing: KidsReadTheme.spacingM,
                runSpacing: KidsReadTheme.spacingM,
                alignment: WrapAlignment.center,
                children: List.generate(_scrambled.length, (i) {
                  final letter = _scrambled[i];
                  if (letter.isEmpty) return const SizedBox(width: 52, height: 60);
                  return GestureDetector(
                    onTap: () => _onLetterTap(i),
                    child: Container(
                      width: 52,
                      height: 60,
                      decoration: BoxDecoration(
                        color: KidsReadTheme.primaryOrange,
                        borderRadius: KidsReadTheme.radiusSmall,
                        boxShadow: [
                          BoxShadow(
                            color: KidsReadTheme.primaryOrange.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          letter.toUpperCase(),
                          style: KidsReadTheme.headingLarge.copyWith(
                            color: KidsReadTheme.surfaceWhite,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
