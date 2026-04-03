import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../models/lesson.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/word_data.dart';
import '../../../shared/progress/progress_service.dart';
import '../level_complete_overlay.dart';

/// CVC word sets per level (6–7 words each, 4 levels + review).
const List<List<int>> _spellingLevelIndices = [
  [0, 1, 2, 3, 4, 5, 6],
  [7, 8, 9, 10, 11, 12, 13],
  [14, 15, 16, 17, 18, 19, 20],
  [21, 22, 23, 24, 25, 26, 27],
  [0, 7, 14, 21], // review: one from each set
];

/// Module 4 — Short Word Spelling (CVC words).
///
/// Child drags letter tiles into blank slots to spell the word shown as a
/// picture. Audio pronounces the completed word automatically.
class SpellingModuleScreen extends StatefulWidget {
  const SpellingModuleScreen({super.key});

  @override
  State<SpellingModuleScreen> createState() => _SpellingModuleScreenState();
}

class _SpellingModuleScreenState extends State<SpellingModuleScreen> {
  static const String _moduleId = ModuleIds.spelling;

  int _levelIndex = 0;
  int _wordIndex = 0;
  int _correctCount = 0;

  late Word _currentWord;
  late List<String> _letterPool;
  late List<String?> _slots;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _loadWord();
  }

  void _loadWord() {
    final indices = _spellingLevelIndices[_levelIndex];
    final wordIdx = indices[_wordIndex % indices.length];
    _currentWord = cvcWords[wordIdx];
    _slots = List.filled(_currentWord.text.length, null);
    _letterPool = _buildLetterPool(_currentWord.text);
    _isComplete = false;
  }

  List<String> _buildLetterPool(String word) {
    final letters = word.split('');
    // Add 2 random distractors
    const allLetters = 'abcdefghijklmnopqrstuvwxyz';
    while (letters.length < word.length + 2) {
      final r = allLetters[Random().nextInt(allLetters.length)];
      if (!letters.contains(r)) letters.add(r);
    }
    return letters..shuffle(Random());
  }

  void _placeLetter(String letter, int slotIndex) {
    if (_slots[slotIndex] != null) return;
    setState(() {
      _slots[slotIndex] = letter;
      _letterPool.remove(letter);
    });
    _checkComplete();
  }

  void _removeLetter(int slotIndex) {
    final letter = _slots[slotIndex];
    if (letter == null) return;
    setState(() {
      _slots[slotIndex] = null;
      _letterPool.add(letter);
    });
  }

  void _checkComplete() {
    if (_slots.every((s) => s != null)) {
      final spelled = _slots.join();
      final isCorrect = spelled == _currentWord.text;
      final audio = context.read<AudioService>();
      if (isCorrect) {
        _correctCount++;
        audio.speakWord(_currentWord.text);
        audio.playSfx(SfxType.correct);
        setState(() => _isComplete = true);
        Future.delayed(const Duration(milliseconds: 1800), _advance);
      } else {
        audio.playSfx(SfxType.wrong);
        audio.playEncouragement(EncouragementType.tryAgain);
        // Clear slots so child can retry
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _letterPool = _buildLetterPool(_currentWord.text);
            _slots = List.filled(_currentWord.text.length, null);
          });
        });
      }
    }
  }

  void _advance() {
    final indices = _spellingLevelIndices[_levelIndex];
    if (_wordIndex < indices.length - 1) {
      setState(() {
        _wordIndex++;
        _loadWord();
      });
    } else {
      _completeLevel();
    }
  }

  Future<void> _completeLevel() async {
    final indices = _spellingLevelIndices[_levelIndex];
    final accuracy = (_correctCount / indices.length * 100).round();
    final levelId = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex]
        .id;
    final isLast = _levelIndex == _spellingLevelIndices.length - 1;

    final result = await context.read<ProgressService>().recordLevelComplete(
          levelId: levelId,
          moduleId: _moduleId,
          accuracyPercent: accuracy,
          isLastLevelInModule: isLast,
        );

    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelCompleteOverlay(
        stars: result.stars,
        unlockedGameId: result.unlockedGameId,
        isLastLevel: isLast,
        onNext: isLast
            ? () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            : () {
                Navigator.of(context).pop();
                setState(() {
                  _levelIndex++;
                  _wordIndex = 0;
                  _correctCount = 0;
                  _loadWord();
                });
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levelInfo = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex];
    final indices = _spellingLevelIndices[_levelIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(levelInfo.title),
        backgroundColor: KidsReadTheme.primaryGreen,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KidsReadTheme.spacingL),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_wordIndex + 1) / indices.length,
                backgroundColor: KidsReadTheme.cardBackground,
                color: KidsReadTheme.primaryGreen,
                minHeight: 8,
                borderRadius: KidsReadTheme.radiusSmall,
              ),
              const SizedBox(height: KidsReadTheme.spacingL),

              Text('Spell the word!', style: KidsReadTheme.headingMedium),
              const SizedBox(height: KidsReadTheme.spacingM),

              // Word picture placeholder
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: KidsReadTheme.cardBackground,
                  borderRadius: KidsReadTheme.radiusLarge,
                  border: Border.all(
                      color: KidsReadTheme.primaryGreen, width: 3),
                ),
                child: const Center(
                  child: Icon(Icons.image_rounded,
                      size: 60, color: KidsReadTheme.lockedGrey),
                ),
              ),

              const SizedBox(height: KidsReadTheme.spacingXL),

              // Letter slots (drop targets)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_currentWord.text.length, (i) {
                  return DragTarget<_LetterDrag>(
                    onWillAcceptWithDetails: (_) => _slots[i] == null,
                    onAcceptWithDetails: (details) =>
                        _placeLetter(details.data.letter, i),
                    builder: (context, candidates, _) {
                      final letter = _slots[i];
                      final isHovering = candidates.isNotEmpty;
                      return GestureDetector(
                        onTap: letter != null ? () => _removeLetter(i) : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: KidsReadTheme.spacingXS),
                          width: 52,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _isComplete
                                ? KidsReadTheme.correctGreen
                                : letter != null
                                    ? KidsReadTheme.primaryBlue
                                    : isHovering
                                        ? KidsReadTheme.primaryYellow
                                        : KidsReadTheme.cardBackground,
                            borderRadius: KidsReadTheme.radiusSmall,
                            border: Border.all(
                              color: _isComplete
                                  ? KidsReadTheme.correctGreen
                                  : KidsReadTheme.primaryGreen,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter?.toUpperCase() ?? '',
                              style: KidsReadTheme.headingLarge.copyWith(
                                color: letter != null
                                    ? KidsReadTheme.surfaceWhite
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              const Spacer(),

              // Letter pool (draggable tiles)
              Text('Drag the letters!', style: KidsReadTheme.bodyLarge),
              const SizedBox(height: KidsReadTheme.spacingM),
              Wrap(
                spacing: KidsReadTheme.spacingM,
                runSpacing: KidsReadTheme.spacingM,
                alignment: WrapAlignment.center,
                children: _letterPool.map((letter) {
                  return Draggable<_LetterDrag>(
                    data: _LetterDrag(letter),
                    feedback: _buildTile(letter, dragging: true),
                    childWhenDragging: _buildTile(letter, faded: true),
                    child: _buildTile(letter),
                  );
                }).toList(),
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(String letter,
      {bool dragging = false, bool faded = false}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: faded ? 0.3 : 1.0,
      child: Container(
        width: 52,
        height: 60,
        decoration: BoxDecoration(
          color: dragging
              ? KidsReadTheme.primaryOrange
              : KidsReadTheme.primaryGreen,
          borderRadius: KidsReadTheme.radiusSmall,
          boxShadow: dragging
              ? [
                  BoxShadow(
                    color: KidsReadTheme.primaryOrange.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            letter.toUpperCase(),
            style: KidsReadTheme.headingLarge
                .copyWith(color: KidsReadTheme.surfaceWhite),
          ),
        ),
      ),
    );
  }
}

class _LetterDrag {
  final String letter;
  const _LetterDrag(this.letter);
}
