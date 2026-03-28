import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../models/lesson.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/letter_data.dart';
import '../../../shared/progress/progress_service.dart';
import '../../../shared/widgets/audio_prompt_button.dart';
import '../../../shared/widgets/letter_card.dart';
import '../../../shared/widgets/star_burst.dart';
import '../level_complete_overlay.dart';

/// Module 1 — Letter Recognition.
///
/// Each level presents letters from [letterGroups]. The child sees a letter,
/// taps it to hear its name, then answers a 4-choice quiz.
class LettersModuleScreen extends StatefulWidget {
  const LettersModuleScreen({super.key});

  @override
  State<LettersModuleScreen> createState() => _LettersModuleScreenState();
}

class _LettersModuleScreenState extends State<LettersModuleScreen> {
  static const String _moduleId = ModuleIds.letters;

  int _levelIndex = 0;
  int _questionIndex = 0;
  int _correctCount = 0;
  int _totalQuestions = 0;

  String? _selectedLetter;
  bool? _lastAnswerCorrect;
  bool _showingResult = false;

  late List<String> _currentLetters;
  late String _targetLetter;
  late List<String> _choices;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  void _loadLevel() {
    _currentLetters = letterGroups[_levelIndex];
    _questionIndex = 0;
    _correctCount = 0;
    _totalQuestions = _currentLetters.length;
    _selectedLetter = null;
    _lastAnswerCorrect = null;
    _loadQuestion();
  }

  void _loadQuestion() {
    _targetLetter = _currentLetters[_questionIndex];
    _choices = _buildChoices(_targetLetter);
    _selectedLetter = null;
    _lastAnswerCorrect = null;
    _showingResult = false;

    // Auto-play the letter name on new question.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().speakLetter(_targetLetter);
    });
  }

  List<String> _buildChoices(String correct) {
    final pool = List<String>.from(
      alphabet.map((l) => l.letter).where((l) => l != correct),
    );
    pool.shuffle(Random());
    final distractors = pool.take(3).toList();
    final all = [correct, ...distractors]..shuffle(Random());
    return all;
  }

  void _onLetterTap(String letter) {
    if (_showingResult) return;
    final audio = context.read<AudioService>();
    final isCorrect = letter == _targetLetter;

    setState(() {
      _selectedLetter = letter;
      _lastAnswerCorrect = isCorrect;
      _showingResult = true;
    });

    if (isCorrect) {
      _correctCount++;
      audio.playSfx(SfxType.correct);
      audio.playEncouragement(EncouragementType.greatJob);
    } else {
      audio.playSfx(SfxType.wrong);
      audio.playEncouragement(EncouragementType.tryAgain);
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (isCorrect || true) {
        // Always advance so children are never stuck.
        _advance();
      }
    });
  }

  void _advance() {
    if (_questionIndex < _totalQuestions - 1) {
      setState(() {
        _questionIndex++;
        _loadQuestion();
      });
    } else {
      _completLevel();
    }
  }

  Future<void> _completLevel() async {
    final accuracy = (_correctCount / _totalQuestions * 100).round();
    final levelId = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex]
        .id;
    final isLast = _levelIndex == letterGroups.length - 1;

    final progressService = context.read<ProgressService>();
    final stars = await progressService.recordLevelComplete(
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
        stars: stars,
        onNext: isLast
            ? () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            : () {
                Navigator.of(context).pop();
                setState(() {
                  _levelIndex++;
                  _loadLevel();
                });
              },
        isLastLevel: isLast,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levelInfo = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex];

    return Scaffold(
      backgroundColor: KidsReadTheme.backgroundLight,
      appBar: AppBar(
        title: Text(levelInfo.title),
        backgroundColor: KidsReadTheme.primaryBlue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KidsReadTheme.spacingL),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_questionIndex + 1) / _totalQuestions,
                backgroundColor: KidsReadTheme.cardBackground,
                color: KidsReadTheme.primaryGreen,
                minHeight: 8,
                borderRadius: KidsReadTheme.radiusSmall,
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),

              // Target letter display
              Text('Which letter is this?', style: KidsReadTheme.headingMedium),
              const SizedBox(height: KidsReadTheme.spacingL),

              // Large letter with audio button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: KidsReadTheme.primaryBlue,
                      borderRadius: KidsReadTheme.radiusLarge,
                      boxShadow: [
                        BoxShadow(
                          color: KidsReadTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _targetLetter,
                        style: KidsReadTheme.displayLarge.copyWith(
                          color: KidsReadTheme.surfaceWhite,
                          fontSize: 72,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scale(duration: 300.ms, curve: Curves.elasticOut),
                  const SizedBox(width: KidsReadTheme.spacingL),
                  AudioPromptButton(
                    onTap: () =>
                        context.read<AudioService>().speakLetter(_targetLetter),
                  ),
                ],
              ),

              const Spacer(),

              // 4-choice answer grid
              Text('Tap the letter!', style: KidsReadTheme.bodyLarge),
              const SizedBox(height: KidsReadTheme.spacingM),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: KidsReadTheme.spacingM,
                mainAxisSpacing: KidsReadTheme.spacingM,
                children: _choices.map((letter) {
                  final isSelected = letter == _selectedLetter;
                  final isCorrect = isSelected ? _lastAnswerCorrect : null;
                  return LetterCard(
                    letter: letter,
                    onTap: () => _onLetterTap(letter),
                    isSelected: isSelected,
                    isCorrect: isCorrect,
                    size: 90,
                  );
                }).toList(),
              ),
              const SizedBox(height: KidsReadTheme.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
