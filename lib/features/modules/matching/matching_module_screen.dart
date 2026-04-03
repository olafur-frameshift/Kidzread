import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../models/lesson.dart';
import '../../../shared/audio/audio_service.dart';
import '../../../shared/data/letter_data.dart';
import '../../../shared/progress/progress_service.dart';
import '../../../shared/widgets/star_burst.dart';
import '../level_complete_overlay.dart';

/// Module 2 — Uppercase / Lowercase Matching.
///
/// Child drags an uppercase letter onto its lowercase counterpart.
class MatchingModuleScreen extends StatefulWidget {
  const MatchingModuleScreen({super.key});

  @override
  State<MatchingModuleScreen> createState() => _MatchingModuleScreenState();
}

class _MatchingModuleScreenState extends State<MatchingModuleScreen> {
  static const String _moduleId = ModuleIds.matching;

  int _levelIndex = 0;
  int _matchedCount = 0;
  int _correctCount = 0;
  int _totalAttempts = 0;

  late List<String> _levelLetters;
  late List<String> _upperCards;
  late List<String> _lowerCards;
  final Map<String, String?> _matches = {}; // upper → lower matched

  String? _dragging;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  void _loadLevel() {
    _levelLetters = letterGroups[_levelIndex];
    _upperCards = List<String>.from(_levelLetters);
    _lowerCards = _levelLetters.map((l) => l.toLowerCase()).toList()..shuffle(Random());
    _matches.clear();
    _matchedCount = 0;
    _correctCount = 0;
    _totalAttempts = 0;
    _dragging = null;
  }

  void _onDrop(String upper, String lower) {
    final audio = context.read<AudioService>();
    final isCorrect = upper.toLowerCase() == lower;
    _totalAttempts++;

    if (isCorrect) {
      _correctCount++;
      _matchedCount++;
      audio.playSfx(SfxType.correct);
      setState(() => _matches[upper] = lower);
    } else {
      audio.playSfx(SfxType.wrong);
      audio.playEncouragement(EncouragementType.tryAgain);
    }

    setState(() => _dragging = null);

    if (_matchedCount == _levelLetters.length) {
      Future.delayed(const Duration(milliseconds: 500), _completeLevel);
    }
  }

  Future<void> _completeLevel() async {
    final accuracy = (_correctCount / max(_totalAttempts, 1) * 100).round();
    final levelId = ModuleCatalogue.modules
        .firstWhere((m) => m.id == _moduleId)
        .levels[_levelIndex]
        .id;
    final isLast = _levelIndex == letterGroups.length - 1;

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
                  _loadLevel();
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
        backgroundColor: KidsReadTheme.primaryOrange,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KidsReadTheme.spacingL),
          child: Column(
            children: [
              Text(
                'Match the big letter to the small letter!',
                style: KidsReadTheme.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: KidsReadTheme.spacingXL),

              // Uppercase row (draggable sources)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _upperCards.map((upper) {
                  final isMatched = _matches.containsKey(upper);
                  return Opacity(
                    opacity: isMatched ? 0.3 : 1.0,
                    child: Draggable<String>(
                      data: upper,
                      onDragStarted: () => setState(() => _dragging = upper),
                      onDraggableCanceled: (_, __) =>
                          setState(() => _dragging = null),
                      feedback: _buildLetterTile(upper, 80,
                          color: KidsReadTheme.primaryOrange,
                          isUppercase: true),
                      childWhenDragging: _buildLetterTile(upper, 68,
                          color: KidsReadTheme.lockedGrey, isUppercase: true),
                      child: _buildLetterTile(upper, 68,
                          color: isMatched
                              ? KidsReadTheme.lockedGrey
                              : KidsReadTheme.primaryOrange,
                          isUppercase: true),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: KidsReadTheme.spacingXXL),
              const Divider(height: 1),
              const SizedBox(height: KidsReadTheme.spacingXXL),

              // Lowercase row (drop targets)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _lowerCards.map((lower) {
                  final isMatched = _matches.values.contains(lower);
                  return DragTarget<String>(
                    onWillAcceptWithDetails: (details) =>
                        !isMatched,
                    onAcceptWithDetails: (details) =>
                        _onDrop(details.data, lower),
                    builder: (context, candidates, rejected) {
                      final isHovering = candidates.isNotEmpty;
                      return _buildLetterTile(
                        lower,
                        68,
                        color: isMatched
                            ? KidsReadTheme.correctGreen
                            : isHovering
                                ? KidsReadTheme.primaryYellow
                                : KidsReadTheme.primaryBlue,
                        isUppercase: false,
                      );
                    },
                  );
                }).toList(),
              ),

              const Spacer(),
              Text(
                'Matched: $_matchedCount / ${_levelLetters.length}',
                style: KidsReadTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterTile(String letter, double size,
      {required Color color, required bool isUppercase}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: KidsReadTheme.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isUppercase ? letter.toUpperCase() : letter.toLowerCase(),
          style: KidsReadTheme.displayLarge.copyWith(
            color: KidsReadTheme.surfaceWhite,
            fontSize: size * 0.48,
          ),
        ),
      ),
    );
  }
}
