import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens ported 1:1 from the original :root CSS variables.
class AppColors {
  static const ink = Color(0xFF050807);
  static const app = Color(0xFF0B141A);
  static const chatBg = Color(0xFF0A1310);
  static const panel = Color(0xFF111F1A);
  static const panel2 = Color(0xFF16241F);
  static const line = Color(0x1A78BEAA); // rgba(120,190,170,.10)
  static const line2 = Color(0x3878BEAA); // rgba(120,190,170,.22)
  static const teal = Color(0xFF12B886);
  static const tealDeep = Color(0xFF0A5C48);
  static const gold = Color(0xFFE0B25C);
  static const goldDim = Color(0x24E0B25C); // rgba(224,178,92,.14)
  static const green = Color(0xFF3DDC97);
  static const blue = Color(0xFF53BDEB);
  static const text = Color(0xFFE8F0EC);
  static const dim = Color(0xFF8BA49B);
  static const faint = Color(0xFF5C716A);
  static const mine = Color(0xFF134D3D);
  static const other = Color(0xFF1C2B25);

  static const tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal, tealDeep],
  );
}

class AppText {
  // --fd: Fraunces (display serif)
  static TextStyle display({
    double size = 19,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.text,
    double letterSpacing = -0.2,
  }) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  // --fb: Inter Tight (body sans)
  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.interTight(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  // --fm: JetBrains Mono
  static TextStyle mono({
    double size = 10,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.dim,
    double letterSpacing = 0.06,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.app,
    colorScheme: ColorScheme.dark(
      primary: AppColors.teal,
      secondary: AppColors.gold,
      surface: AppColors.panel,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    dividerColor: AppColors.line,
    textTheme: GoogleFonts.interTightTextTheme(ThemeData.dark().textTheme),
  );
}
