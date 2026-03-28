import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/word_data.dart';
import '../../../shared/widgets/audio_prompt_button.dart';

/// Mini-game 4 — Picture Hunt.
///
/// A grid of word-picture cards is displayed. A word is read aloud and the
/// child taps the matching card. No fail state.
///
/// Note: In production, replace the placeholder grid with a rich illustrated
/// scene. For MVP the grid layout shows word labels as stand-ins for art.
class PictureHuntScreen extends StatefulWidget {
  const PictureHuntScreen({super.key});

  @override
  State<PictureHuntScreen> createState() => _PictureHuntScreenState();
}

class _PictureHuntScreenState extends State<PictureHuntScreen> {
  static const int _gridSize = 9;

  final Random _rng = Random();
  late List<Word> _gridWords;
  late Word _targetWord;
  int _score = 0;
  int? _tappedIndex;
  bool? _lastCorrect;

  @override
  void initState() {
    super.initState();
    _loadRound();
  }

  void _loadRound() {
    final pool = List<Word>.from(cvcWords)..shuffle(_rng);
    _gridWords = pool.take(_gridSize).toList();
    _targetWord = _gridWords[_rng.nextInt(_gridWords.length)];
    _tappedIndex = null;
    _lastCorrect = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().speakWord(_targetWord.text);
    });
  }

  void _onTap(int index) {
    if (_tappedIndex != null) return;
    final isCorrect = _gridWords[index].text == _targetWord.text;
    final audio = context.read<AudioService>();

    setState(() {
      _tappedIndex = index;
      _lastCorrect = isCorrect;
    });

    if (isCorrect) {
      _score++;
      audio.playSfx(SfxType.correct);
      audio.playEncouragement(EncouragementType.greatJob);
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(_loadRound);
      });
    } else {
      audio.playSfx(SfxType.wrong);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _tappedIndex = null;
          _lastCorrect = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Hunt'),
        backgroundColor: KidsReadTheme.primaryPink,
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
          padding: const EdgeInsets.all(KidsReadTheme.spacingM),
          child: Column(
            children: [
              // Prompt row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: KidsReadTheme.spacingL,
                  vertical: KidsReadTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: KidsReadTheme.primaryPink,
                  borderRadius: KidsReadTheme.radiusLarge,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AudioPromptButton(
                      onTap: () => context
                          .read<AudioService>()
                          .speakWord(_targetWord.text),
                      color: KidsReadTheme.surfaceWhite,
                      size: 52,
                    ),
                    const SizedBox(width: KidsReadTheme.spacingM),
                    Text(
                      'Find "${_targetWord.text}"!',
                      style: KidsReadTheme.headingLarge.copyWith(
                        color: KidsReadTheme.surfaceWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: KidsReadTheme.spacingM),

              // Picture grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: KidsReadTheme.spacingS,
                    mainAxisSpacing: KidsReadTheme.spacingS,
                  ),
                  itemCount: _gridWords.length,
                  itemBuilder: (context, index) {
                    final word = _gridWords[index];
                    final isTapped = _tappedIndex == index;
                    Color borderColor = Colors.transparent;
                    if (isTapped && _lastCorrect == true) {
                      borderColor = KidsReadTheme.correctGreen;
                    } else if (isTapped && _lastCorrect == false) {
                      borderColor = KidsReadTheme.wrongRed;
                    }

                    return GestureDetector(
                      onTap: () => _onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: KidsReadTheme.cardBackground,
                          borderRadius: KidsReadTheme.radiusMedium,
                          border:
                              Border.all(color: borderColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_rounded,
                              size: 44,
                              color: KidsReadTheme.lockedGrey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              word.text,
                              style: KidsReadTheme.headingMedium
                                  .copyWith(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
