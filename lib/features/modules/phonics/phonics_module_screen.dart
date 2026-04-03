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
import '../level_complete_overlay.dart';

/// Level letter sets for the phonics module.
///
/// Each list is a group whose phonemes are drilled in that level.
const List<List<String>> _phonicsGroups = [
  ['A', 'E', 'I', 'O', 'U'],          // Level 1: short vowels
  ['B', 'C', 'D', 'F', 'G', 'H'],     // Level 2: consonants A–M first half
  ['J', 'K', 'L', 'M'],               // Level 3: consonants A–M second half
  ['N', 'P', 'Q', 'R', 'S', 'T'],     // Level 4: consonants N–Z first half
  ['V', 'W', 'X', 'Y', 'Z'],          // Level 5: consonants N–Z second half
];

/// Module 3 — Letter Sounds & Phonics.
///
/// Child hears a phoneme and taps the correct letter from 3 choices.
class PhonicsModuleScreen extends StatefulWidget {
  const PhonicsModuleScreen({super.key});

  @override
  State<PhonicsModuleScreen> createState() => _PhonicsModuleScreenState();
}

class _PhonicsModuleScreenState extends State<PhonicsModuleScreen> {
  static const String _moduleId = ModuleIds.phonics;

  int _levelIndex = 0;
  int _questionIndex = 0;
  int _correctCount = 0;

  late String _targetLetter;
  late List<String> _choices;
  String? _selected;
  bool? _lastCorrect;
  bool _showingResult = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    final group = _phonicsGroups[_levelIndex];
    _targetLetter = group[_questionIndex % group.length];
    _choices = _buildChoices(_targetLetter);
    _selected = null;
    _lastCorrect = null;
    _showingResult = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().speakLetterSound(_targetLetter);
    });
  }

  List<String> _buildChoices(String correct) {
    final pool = alphabet.map((l) => l.letter).where((l) => l != correct).toList();
    pool.shuffle(Random());
    return [correct, pool[0], pool[1]]..shuffle(Random());
  }

  void _onTap(String letter) {
    if (_showingResult) return;
    final isCorrect = letter == _targetLetter;
    if (isCorrect) _correctCount++;
    final audio = context.read<AudioService>();
    audio.playSfx(isCorrect ? SfxType.correct : SfxType.wrong);
    if (!isCorrect) audio.playEncouragement(EncouragementType.tryAgain);

    setState(() {
      _selected = letter;
      _lastCorrect = isCorrect;
      _showingResult = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final group = _phonicsGroups[_levelIndex];
      if (_questionIndex < group.length - 1) {
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
    final group = _phonicsGroups[_levelIndex];
    final accuracy = (_correctCount / group.length * 100).round();
    final levelId = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex]
        .id;
    final isLast = _levelIndex == _phonicsGroups.length - 1;

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
    final group = _phonicsGroups[_levelIndex];
    final levelInfo = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(levelInfo.title),
        backgroundColor: KidsReadTheme.primaryPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KidsReadTheme.spacingL),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_questionIndex + 1) / group.length,
                backgroundColor: KidsReadTheme.cardBackground,
                color: KidsReadTheme.primaryPurple,
                minHeight: 8,
                borderRadius: KidsReadTheme.radiusSmall,
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),

              Text(
                'What sound does this letter make?',
                style: KidsReadTheme.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),

              // Audio play button — primary interaction
              AudioPromptButton(
                onTap: () =>
                    context.read<AudioService>().speakLetterSound(_targetLetter),
                color: KidsReadTheme.primaryPurple,
                size: 100,
              ),
              const SizedBox(height: KidsReadTheme.spacingS),
              Text('Tap to hear the sound again',
                  style: KidsReadTheme.bodyLarge),

              const Spacer(),

              Text('Which letter is it?', style: KidsReadTheme.headingMedium),
              const SizedBox(height: KidsReadTheme.spacingM),

              // 3-choice answer row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _choices.map((letter) {
                  final isSelected = letter == _selected;
                  return LetterCard(
                    key: ValueKey('$_levelIndex-$_questionIndex-$letter'),
                    letter: letter,
                    onTap: () => _onTap(letter),
                    isSelected: isSelected,
                    isCorrect: isSelected ? _lastCorrect : null,
                    size: 100,
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
}
