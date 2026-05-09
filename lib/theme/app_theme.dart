import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Core Palette ──────────────────────────────────────────────────────────
  static const Color primaryColor   = Color(0xFF00D1FF);
  static const Color accentColor    = Color(0xFF0055FF);
  static const Color dangerColor    = Color(0xFFFF3B5C);
  static const Color successColor   = Color(0xFF00E5A0);
  static const Color warningColor   = Color(0xFFFFB020);

  static const Color bgBase         = Color(0xFF080C1E);   // page background
  static const Color bgRaised       = Color(0xFF0F1428);   // raised card
  static const Color bgSunken       = Color(0xFF060919);   // inset / pressed
  static const Color bgInput        = Color(0xFF0B1030);

  static const Color textPrimary    = Color(0xFFEAEFF8);
  static const Color textSecondary  = Color(0xFF5E6A8C);
  static const Color textHint       = Color(0xFF2E3A5C);

  static const Color shadowDark     = Color(0xFF030610);
  static const Color shadowLight    = Color(0xFF1A2140);

  // ── Shadow Helpers ────────────────────────────────────────────────────────
  static List<BoxShadow> raise({double intensity = 1.0}) => [
    BoxShadow(
      color: shadowDark.withOpacity(0.80 * intensity),
      offset: Offset(6 * intensity, 6 * intensity),
      blurRadius: 14 * intensity,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: shadowLight.withOpacity(0.50 * intensity),
      offset: Offset(-4 * intensity, -4 * intensity),
      blurRadius: 10 * intensity,
      spreadRadius: 1,
    ),
  ];

  static List<BoxShadow> press() => [
    BoxShadow(
      color: shadowDark.withOpacity(0.90),
      offset: const Offset(2, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight.withOpacity(0.20),
      offset: const Offset(-1, -1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glow({Color? color, double intensity = 1.0}) => [
    BoxShadow(
      color: (color ?? primaryColor).withOpacity(0.35 * intensity),
      blurRadius: 24 * intensity,
      spreadRadius: 4 * intensity,
    ),
  ];

  // ── Decoration Helpers ────────────────────────────────────────────────────
  static BoxDecoration card({
    double radius = 20,
    bool isPressed = false,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        color: isPressed ? bgSunken : bgRaised,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows ?? (isPressed ? press() : raise()),
        border: Border.all(
          color: shadowLight.withOpacity(0.15),
          width: 1,
        ),
      );

  static BoxDecoration inset({double radius = 14}) => BoxDecoration(
        color: bgSunken,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: shadowDark.withOpacity(0.80),
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
          BoxShadow(
            color: shadowLight.withOpacity(0.30),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1,
        ),
      );

  static BoxDecoration glowCard({
    double radius = 20,
    Color? glowColor,
  }) =>
      BoxDecoration(
        color: bgRaised,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          ...raise(),
          ...glow(color: glowColor),
        ],
        border: Border.all(
          color: (glowColor ?? primaryColor).withOpacity(0.25),
          width: 1.5,
        ),
      );

  // ── Input Decoration ──────────────────────────────────────────────────────
  static InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffix,
  }) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: textHint, fontSize: 13),
        labelStyle: TextStyle(color: textSecondary, fontSize: 14),
        prefixIcon: Icon(icon, color: textSecondary, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: bgInput,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: shadowLight.withOpacity(0.30), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
      );

  // ── Theme Data ────────────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgBase,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        error: dangerColor,
        surface: bgRaised,
        background: bgBase,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 2.5,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: bgBase,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgRaised,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (s) => s.contains(MaterialState.selected) ? primaryColor : Colors.transparent,
        ),
        checkColor: MaterialStateProperty.all(bgBase),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: textSecondary, width: 1.5),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: bgRaised,
        contentTextStyle: GoogleFonts.poppins(color: textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}