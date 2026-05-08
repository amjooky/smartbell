import 'package:flutter/material.dart';

class AppTheme {
  // ── Colors ──────────────────────────────────────────────────────────────────
  static const Color primary       = Color(0xFFEF9F27);
  static const Color background    = Color(0xFF111111);
  static const Color surface       = Color(0xFF1E1E1E);
  static const Color surfaceAlt    = Color(0xFF1A1A1A);
  static const Color border        = Color(0xFF2A2A2A);
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textMuted     = Color(0xFF555555);
  static const Color success       = Color(0xFF1D9E75);
  static const Color error         = Color(0xFFE24B4A);
  static const Color info          = Color(0xFF534AB7);
  static const Color warning       = Color(0xFFEF9F27);

  // ── Expanded Color Palette ─────────────────────────────────────────────
  static const Color primaryLight   = Color(0xFFF4B942);
  static const Color primaryDark    = Color(0xFFD4861A);
  static const Color accent         = Color(0xFF00D4AA);
  static const Color accentLight    = Color(0xFF4DFFCD);
  static const Color surfaceElevated = Color(0xFF252525);
  static const Color surfaceHighest  = Color(0xFF2C2C2C);

  // ── Semantic Colors ─────────────────────────────────────────────────────
  static const Color workoutActive  = Color(0xFF00D4AA);
  static const Color nutritionGreen = Color(0xFF4CAF50);
  static const Color coachBlue      = Color(0xFF2196F3);
  static const Color loyaltyGold    = Color(0xFFFFD700);

  // ── Gradients ───────────────────────────────────────────────────────────────
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF272727), Color(0xFF1A1A1A)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF9F27), Color(0xFFD4861A)],
  );

  static const LinearGradient navActiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33EF9F27), Color(0x18EF9F27)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF161616), Color(0xFF111111)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4AA), Color(0xFF00A388)],
  );

  // ── Shadows ─────────────────────────────────────────────────────────────────
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x44000000), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x1A000000), blurRadius: 6,  offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(color: Color(0x60000000), blurRadius: 32, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x20000000), blurRadius: 8,  offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x20000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> primaryGlow = [
    BoxShadow(color: Color(0x4DEF9F27), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x26EF9F27), blurRadius: 48, spreadRadius: -4),
  ];

  static const List<BoxShadow> subtleGlow = [
    BoxShadow(color: Color(0x26EF9F27), blurRadius: 14, spreadRadius: -2),
  ];

  static const List<BoxShadow> navShadow = [
    BoxShadow(color: Color(0x60000000), blurRadius: 20, offset: Offset(0, -4)),
  ];

  // ── Text Styles ─────────────────────────────────────────────────────────────
  static const TextStyle headingLarge = TextStyle(
    color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3,
  );
  static const TextStyle headingMedium = TextStyle(
    color: textPrimary, fontSize: 17, fontWeight: FontWeight.bold,
  );
  static const TextStyle headingSmall = TextStyle(
    color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
  );
  static const TextStyle sectionTitle = TextStyle(
    color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2,
  );
  static const TextStyle bodyMedium = TextStyle(
    color: textSecondary, fontSize: 13,
  );
  static const TextStyle bodySmall = TextStyle(
    color: textMuted, fontSize: 11,
  );
  static const TextStyle labelAmber = TextStyle(
    color: primary, fontSize: 20, fontWeight: FontWeight.bold,
  );

  // ── Enhanced Text Styles ─────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    color: textPrimary, fontSize: 32, fontWeight: FontWeight.w800,
    letterSpacing: -0.5, height: 1.1,
  );

  static const TextStyle headingXL = TextStyle(
    color: textPrimary, fontSize: 24, fontWeight: FontWeight.w700,
    letterSpacing: -0.3, height: 1.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: textPrimary, fontSize: 16, fontWeight: FontWeight.w500, height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600,
    letterSpacing: 0.5, height: 1.3,
  );

  static const TextStyle caption = TextStyle(
    color: textMuted, fontSize: 11, fontWeight: FontWeight.w400, height: 1.3,
  );

  // ── Theme ───────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: surface,
      onPrimary: Colors.black,
      onSurface: textPrimary,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceAlt,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: textSecondary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceAlt,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border, width: 0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: textMuted, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 0.5, space: 0),
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: primary.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: textPrimary, fontSize: 12),
      side: const BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
