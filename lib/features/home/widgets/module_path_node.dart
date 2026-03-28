import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/theme.dart';
import '../../../models/lesson.dart';

/// A single node on the home-screen module path.
///
/// Shows lock/unlock/complete state and animates in on first appearance.
class ModulePathNode extends StatelessWidget {
  const ModulePathNode({
    super.key,
    required this.module,
    required this.isLocked,
    required this.isCompleted,
    required this.alignRight,
    this.onTap,
  });

  final ModuleInfo module;
  final bool isLocked;
  final bool isCompleted;

  /// Alternate alignment for a winding path visual.
  final bool alignRight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(module.color);
    final effectiveColor = isLocked ? KidsReadTheme.lockedGrey : color;

    return Padding(
      padding: EdgeInsets.only(
        bottom: KidsReadTheme.spacingXL,
        left: alignRight ? KidsReadTheme.spacingXXL : 0,
        right: alignRight ? 0 : KidsReadTheme.spacingXXL,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment:
              alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            _buildNodeButton(effectiveColor),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildNodeButton(Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(KidsReadTheme.spacingM),
      decoration: BoxDecoration(
        color: color,
        borderRadius: KidsReadTheme.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLocked
                ? Icons.lock_rounded
                : isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.play_circle_rounded,
            color: KidsReadTheme.surfaceWhite,
            size: 36,
          ),
          const SizedBox(height: KidsReadTheme.spacingS),
          Text(
            module.title,
            style: KidsReadTheme.headingMedium.copyWith(
              color: KidsReadTheme.surfaceWhite,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
