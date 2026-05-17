import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  AppPalette._();

  static const Color lightBackground = Color(0xFFFBEFF2);
  static const Color lightForeground = Color(0xFF3A2A4A);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFFA063C8);
  static const Color lightPrimaryFg = Color(0xFFFEFEFE);
  static const Color lightSecondary = Color(0xFFE8C2DB);
  static const Color lightSecondaryFg = Color(0xFF3A2A4A);
  static const Color lightMuted = Color(0xFFEFE1EA);
  static const Color lightMutedFg = Color(0xFF7B6B83);
  static const Color lightAccent = Color(0xFFF1D6DE);
  static const Color lightAccentFg = Color(0xFF3A2A4A);
  static const Color lightDestructive = Color(0xFFD63838);
  static const Color lightBorder = Color(0xFFE7D7E0);

  // Dark palette — matches the home-screen widget's "deep aubergine" feel.
  static const Color darkBackground = Color(0xFF150A1F); // near-black plum
  static const Color darkSurface = Color(0xFF2A1F36); // card / surface
  static const Color darkSurfaceHigh = Color(0xFF362844); // raised surface
  static const Color darkForeground = Color(0xFFF1E1EE);
  static const Color darkCard = darkSurface;
  static const Color darkPrimary = Color(0xFFD9A6E2); // vibrant lavender
  static const Color darkPrimaryContainer = Color(0xFFA063C8); // saturated mor
  static const Color darkPrimaryFg = Color(0xFF2A1F36);
  static const Color darkSecondary = Color(0xFF5A3D70);
  static const Color darkSecondaryFg = Color(0xFFF1E1EE);
  static const Color darkMuted = Color(0xFF3D2B4F);
  static const Color darkMutedFg = Color(0xFFB39CB0);
  static const Color darkAccent = Color(0xFF684C7E);
  static const Color darkAccentFg = Color(0xFFF1E1EE);
  static const Color darkBorder = Color(0xFF4D3858);

  static const Color sky = Color(0xFF38BDF8);
  static const Color amber = Color(0xFFFBBF24);
  static const Color indigo = Color(0xFF818CF8);
  static const Color emerald = Color(0xFF34D399);
  static const Color rose = Color(0xFFFB7185);
  static const Color orange = Color(0xFFFB923C);
}

class AppTheme {
  AppTheme._();

  static const double radius = 16;

  static ThemeData light() => _build(_lightScheme(), Brightness.light);
  static ThemeData dark() => _build(_darkScheme(), Brightness.dark);

  static ColorScheme _lightScheme() => const ColorScheme.light(
        primary: AppPalette.lightPrimary,
        onPrimary: AppPalette.lightPrimaryFg,
        primaryContainer: AppPalette.lightAccent,
        secondary: AppPalette.lightSecondary,
        onSecondary: AppPalette.lightSecondaryFg,
        secondaryContainer: AppPalette.lightSecondary,
        surface: AppPalette.lightCard,
        onSurface: AppPalette.lightForeground,
        surfaceContainerHighest: AppPalette.lightMuted,
        onSurfaceVariant: AppPalette.lightMutedFg,
        error: AppPalette.lightDestructive,
        onError: Colors.white,
        outline: AppPalette.lightBorder,
      );

  static ColorScheme _darkScheme() => const ColorScheme.dark(
        primary: AppPalette.darkPrimary,
        onPrimary: AppPalette.darkPrimaryFg,
        primaryContainer: AppPalette.darkPrimaryContainer,
        onPrimaryContainer: AppPalette.darkForeground,
        secondary: AppPalette.darkSecondary,
        onSecondary: AppPalette.darkSecondaryFg,
        secondaryContainer: AppPalette.darkAccent,
        onSecondaryContainer: AppPalette.darkForeground,
        surface: AppPalette.darkSurface,
        onSurface: AppPalette.darkForeground,
        surfaceContainerLowest: AppPalette.darkBackground,
        surfaceContainerLow: AppPalette.darkSurface,
        surfaceContainer: AppPalette.darkSurface,
        surfaceContainerHigh: AppPalette.darkSurfaceHigh,
        surfaceContainerHighest: AppPalette.darkSurfaceHigh,
        onSurfaceVariant: AppPalette.darkMutedFg,
        error: AppPalette.lightDestructive,
        onError: Colors.white,
        outline: AppPalette.darkBorder,
      );

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);
    // SF Pro is Apple-licensed and unavailable on Google Fonts, but Inter is
    // visually near-identical (same humanist proportions, same x-height, same
    // tabular numerals). Using one family for everything matches the iOS
    // San Francisco system look across both platforms.
    final inter = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    final bg = brightness == Brightness.light
        ? AppPalette.lightBackground
        : AppPalette.darkBackground;

    final textTheme = inter.copyWith(
      displayLarge: inter.displayLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      displayMedium: inter.displayMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineLarge: inter.headlineLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineMedium: inter.headlineMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: inter.headlineSmall?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: inter.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleMedium: inter.titleMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: inter.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: inter.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bg.withValues(alpha: 0.8),
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? AppPalette.lightMuted.withValues(alpha: 0.6)
            : AppPalette.darkMuted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface.withValues(alpha: 0.95),
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            size: 22,
          );
        }),
        height: 64,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surface,
        contentTextStyle: TextStyle(color: scheme.onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withValues(alpha: 0.2),
        thumbColor: scheme.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: 0.18),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant.withValues(alpha: 0.8),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: 0.4)
              : scheme.outline.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
