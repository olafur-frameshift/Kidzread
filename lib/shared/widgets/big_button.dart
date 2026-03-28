import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// A large, chunky button with rounded corners designed for small fingers.
///
/// Meets the 60×60dp minimum touch-target requirement from UX guidelines.
class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor = KidsReadTheme.surfaceWhite,
    this.icon,
    this.width,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color textColor;
  final Widget? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: KidsReadTheme.minTouchTarget + 8,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shape: const RoundedRectangleBorder(
            borderRadius: KidsReadTheme.radiusMedium,
          ),
          elevation: 4,
          shadowColor: buttonColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: KidsReadTheme.spacingS),
            ],
            Text(label, style: KidsReadTheme.labelButton.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
