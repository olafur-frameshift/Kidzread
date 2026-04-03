import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../models/lesson.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/word_data.dart';
import '../../../shared/progress/progress_service.dart';
import '../../../shared/widgets/audio_prompt_button.dart';
import '../level_complete_overlay.dart';

/// Module 5 — Word–Picture Matching.
///
/// Phase A: hear a word, tap the correct picture from 4 choices.
/// Phase B: see a written word, tap the correct picture.
class WordPictureModuleScreen extends StatefulWidget {
  const WordPictureModuleScreen({super.key});

  @override
  State<WordPictureModuleScreen> createState() =>
      _WordPictureModuleScreenState();
}

class _WordPictureModuleScreenState extends State<WordPictureModuleScreen> {
  static const String _moduleId = ModuleIds.wordPicture;

  // Levels 0–3: 4 words each; level 4: review with 6 words
  static const int _wordsPerLevel = 4;
  static const int _totalLevels = 5;

  int _levelIndex = 0;
  int _questionIndex = 0;
  int _correctCount = 0;
  bool _showWrittenWord = false; // false = audio-first, true = text-first

  late Word _targetWord;
  late List<Word> _choices;
  int? _selectedIndex;
  bool? _lastCorrect;
  bool _showingResult = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Word? _previousTarget;

  void _loadQuestion() {
    final pool = List<Word>.from(cvcWords)..shuffle(Random());
    // Avoid repeating the same target word consecutively.
    if (_previousTarget != null && pool.first.text == _previousTarget!.text && pool.length > 1) {
      pool.add(pool.removeAt(0));
    }
    _targetWord = pool.first;
    _previousTarget = _targetWord;
    final distractors = pool.skip(1).take(3).toList();
    _choices = [_targetWord, ...distractors]..shuffle(Random());
    _selectedIndex = null;
    _lastCorrect = null;
    _showingResult = false;
    _showWrittenWord = _levelIndex >= 1; // text-first from level 2 onward

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_showWrittenWord) {
        context.read<AudioService>().speakWord(_targetWord.text);
      }
    });
  }

  void _onChoiceTap(int index) {
    if (_showingResult) return;
    final isCorrect = _choices[index].text == _targetWord.text;
    if (isCorrect) _correctCount++;

    final audio = context.read<AudioService>();
    audio.playSfx(isCorrect ? SfxType.correct : SfxType.wrong);
    if (!isCorrect) audio.playEncouragement(EncouragementType.tryAgain);

    setState(() {
      _selectedIndex = index;
      _lastCorrect = isCorrect;
      _showingResult = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_questionIndex < _wordsPerLevel - 1) {
        setState(() {
          _questionIndex++;
          _loadQuestion();
        });
      } else {
        _completeLevel();
      }
    });
  }

  Future<void> _completeLevel() async {
    final accuracy = (_correctCount / _wordsPerLevel * 100).round();
    final levelId = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex]
        .id;
    final isLast = _levelIndex == _totalLevels - 1;

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
                  _questionIndex = 0;
                  _correctCount = 0;
                  _loadQuestion();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(levelInfo.title),
        backgroundColor: KidsReadTheme.primaryPink,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KidsReadTheme.spacingL),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_questionIndex + 1) / _wordsPerLevel,
                backgroundColor: KidsReadTheme.cardBackground,
                color: KidsReadTheme.primaryPink,
                minHeight: 8,
                borderRadius: KidsReadTheme.radiusSmall,
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),

              // Prompt area
              if (_showWrittenWord)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: KidsReadTheme.spacingXL,
                    vertical: KidsReadTheme.spacingM,
                  ),
                  decoration: BoxDecoration(
                    color: KidsReadTheme.primaryPink,
                    borderRadius: KidsReadTheme.radiusLarge,
                  ),
                  child: Text(
                    _targetWord.text,
                    style: KidsReadTheme.displayMedium
                        .copyWith(color: KidsReadTheme.surfaceWhite),
                  ),
                )
              else
                Column(
                  children: [
                    AudioPromptButton(
                      onTap: () => context
                          .read<AudioService>()
                          .speakWord(_targetWord.text),
                      color: KidsReadTheme.primaryPink,
                      size: 96,
                    ),
                    const SizedBox(height: KidsReadTheme.spacingS),
                    Text('Tap to hear the word again',
                        style: KidsReadTheme.bodyLarge),
                  ],
                ),

              const SizedBox(height: KidsReadTheme.spacingXL),
              Text('Tap the matching picture!',
                  style: KidsReadTheme.headingMedium),
              const SizedBox(height: KidsReadTheme.spacingM),

              // 2×2 picture choice grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: KidsReadTheme.spacingM,
                  mainAxisSpacing: KidsReadTheme.spacingM,
                  children: List.generate(_choices.length, (i) {
                    final word = _choices[i];
                    final isSelected = _selectedIndex == i;
                    final isCorrect = isSelected ? _lastCorrect : null;
                    Color borderColor = KidsReadTheme.cardBackground;
                    if (isCorrect == true) borderColor = KidsReadTheme.correctGreen;
                    if (isCorrect == false) borderColor = KidsReadTheme.wrongRed;

                    return GestureDetector(
                      onTap: () => _onChoiceTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: KidsReadTheme.cardBackground,
                          borderRadius: KidsReadTheme.radiusMedium,
                          border: Border.all(color: borderColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.2),
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
                              size: 60,
                              color: KidsReadTheme.lockedGrey,
                            ),
                            const SizedBox(height: KidsReadTheme.spacingXS),
                            Text(
                              word.text,
                              style: KidsReadTheme.headingMedium
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
