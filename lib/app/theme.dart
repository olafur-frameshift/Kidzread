import 'package:flutter/material.dart';

/// KidsRead design tokens — colours, typography, and shape.
///
/// All interactive elements must meet the 60×60dp minimum touch-target size
/// defined in UX guidelines.
class KidsReadTheme {
  KidsReadTheme._();

  // ---------------------------------------------------------------------------
  // Colour palette
  // ---------------------------------------------------------------------------

  static const Color primaryBlue = Color(0xFF2979FF);
  static const Color primaryYellow = Color(0xFFFFD600);
  static const Color primaryGreen = Color(0xFF00C853);
  static const Color primaryOrange = Color(0xFFFF6D00);
  static const Color primaryPink = Color(0xFFFF4081);
  static const Color primaryPurple = Color(0xFFAA00FF);

  static const Color backgroundLight = Color(0xFFF5F9FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFEEF4FF);

  static const Color correctGreen = Color(0xFF00C853);
  static const Color wrongRed = Color(0xFFFF1744);
  static const Color starGold = Color(0xFFFFD600);
  static const Color lockedGrey = Color(0xFFBDBDBD);

  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF4A4A6A);
  static const Color textLight = Color(0xFF9E9EBE);

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  static const String _fontFamily = 'Fredoka';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: textDark,
    letterSpacing: 0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: textDark,
    letterSpacing: 0.5,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textDark,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: textMedium,
  );

  static const TextStyle labelButton = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: surfaceWhite,
    letterSpacing: 0.5,
  );

  // ---------------------------------------------------------------------------
  // Shape
  // ---------------------------------------------------------------------------

  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(32));
  static const BorderRadius radiusCircle = BorderRadius.all(Radius.circular(999));

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;

  /// Minimum touch target size per UX guidelines.
  static const double minTouchTarget = 60;

  // ---------------------------------------------------------------------------
  // ThemeData
  // ---------------------------------------------------------------------------

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        surface: surfaceWhite,
        surfaceContainerLowest: backgroundLight,
        primary: primaryBlue,
        secondary: primaryYellow,
        tertiary: primaryGreen,
        error: wrongRed,
      ),
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: _fontFamily,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: const RoundedRectangleBorder(
            borderRadius: radiusMedium,
          ),
          textStyle: labelButton,
          elevation: 4,
        ),
      ),
      cardTheme: const CardTheme(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: surfaceWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headingLarge,
      ),
    );
  }
}
