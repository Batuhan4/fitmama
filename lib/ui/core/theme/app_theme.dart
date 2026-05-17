import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FitMama renk paleti — hot pink × dark plum, kadına özel postpartum fitness.
class AppPalette {
  AppPalette._();

  // Primary brand
  static const Color primary = Color(0xFFFF2E7E);
  static const Color primarySoft = Color(0xFFFF6FB1);
  static const Color primaryDeepLight = Color(0xFFE91E63);
  static const Color primaryDeepDark = Color(0xFFFF1493);

  // Light theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFFDF2F7);
  static const Color lightForeground = Color(0xFF1A0309);
  static const Color lightMutedForeground = Color(0xFF7A5560);
  static const Color lightBorder = Color(0xFFF0DEE6);

  // Dark theme
  static const Color darkBackground = Color(0xFF0A0309);
  static const Color darkSurface = Color(0xFF1A0F13);
  static const Color darkSurfaceRaised = Color(0xFF26161D);
  static const Color darkForeground = Color(0xFFF7E8F0);
  static const Color darkMutedForeground = Color(0xFFB89BB0);
  static const Color darkBorder = Color(0xFF3A1F2A);

  // Semantic
  static const Color successLight = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF4ADE80);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color destructiveLight = Color(0xFFDC2626);
  static const Color destructiveDark = Color(0xFFF87171);

  // Accent palette — ikon variety
  static const Color accentOrange = Color(0xFFFB923C);
  static const Color accentPurple = Color(0xFFA78BFA);
  static const Color accentPurpleDark = Color(0xFFC4B5FD);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color accentBlue = Color(0xFF60A5FA);
  static const Color accentYellow = Color(0xFFFACC15);
  static const Color accentPink = Color(0xFFEC4899);
}

class AppTheme {
  AppTheme._();

  static const double cardRadius = 18;
  static const double largeCardRadius = 24;
  static const double pillRadius = 999;
  static const double buttonRadius = 14;

  static ThemeData light() => _build(_lightScheme(), Brightness.light);
  static ThemeData dark() => _build(_darkScheme(), Brightness.dark);

  static ColorScheme _lightScheme() => const ColorScheme.light(
        primary: AppPalette.primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFFFE0EC),
        onPrimaryContainer: AppPalette.lightForeground,
        secondary: AppPalette.primarySoft,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFFCE7F0),
        onSecondaryContainer: AppPalette.lightForeground,
        tertiary: AppPalette.accentPurple,
        onTertiary: Colors.white,
        surface: AppPalette.lightSurface,
        onSurface: AppPalette.lightForeground,
        surfaceContainerLowest: AppPalette.lightBackground,
        surfaceContainerLow: AppPalette.lightSurface,
        surfaceContainer: AppPalette.lightSurfaceRaised,
        surfaceContainerHigh: AppPalette.lightSurfaceRaised,
        surfaceContainerHighest: AppPalette.lightSurfaceRaised,
        onSurfaceVariant: AppPalette.lightMutedForeground,
        error: AppPalette.destructiveLight,
        onError: Colors.white,
        outline: AppPalette.lightBorder,
        outlineVariant: AppPalette.lightBorder,
      );

  static ColorScheme _darkScheme() => const ColorScheme.dark(
        primary: AppPalette.primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF4A0E22),
        onPrimaryContainer: AppPalette.darkForeground,
        secondary: AppPalette.primarySoft,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFF3B1726),
        onSecondaryContainer: AppPalette.darkForeground,
        tertiary: AppPalette.accentPurpleDark,
        onTertiary: AppPalette.darkBackground,
        surface: AppPalette.darkSurface,
        onSurface: AppPalette.darkForeground,
        surfaceContainerLowest: AppPalette.darkBackground,
        surfaceContainerLow: AppPalette.darkSurface,
        surfaceContainer: AppPalette.darkSurfaceRaised,
        surfaceContainerHigh: AppPalette.darkSurfaceRaised,
        surfaceContainerHighest: AppPalette.darkSurfaceRaised,
        onSurfaceVariant: AppPalette.darkMutedForeground,
        error: AppPalette.destructiveDark,
        onError: Colors.white,
        outline: AppPalette.darkBorder,
        outlineVariant: AppPalette.darkBorder,
      );

  /// Tüm platformlarda Apple'ın San Francisco Pro fontunu kullanırız.
  ///
  /// `assets/fonts/` altındaki `.otf` dosyaları pubspec'te kayıtlı. Dosyaların
  /// nasıl indirileceği için `assets/fonts/README.md`'ye bak. Dosyalar yoksa
  /// `flutter build` font asset hatası verir; geçici olarak Inter'e geçmek
  /// için [setCustomBodyFont]('Inter') çağrılabilir.
  ///
  /// `SF Pro Display` — başlık ve büyük metin (display, headline, title)
  /// `SF Pro Text`     — gövde, label, küçük metin
  static String displayFontFamily() => _customDisplayFont ?? 'SF Pro Display';
  static String bodyFontFamily() => _customBodyFont ?? 'SF Pro Text';

  static String? _customBodyFont;
  static String? _customDisplayFont;
  static void setCustomBodyFont(String? family) {
    _customBodyFont = family;
  }

  static void setCustomDisplayFont(String? family) {
    _customDisplayFont = family;
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);

    final displayFamily = displayFontFamily();
    final bodyFamily = bodyFontFamily();

    TextStyle body([double size = 14, FontWeight w = FontWeight.w400,
            double? letterSpacing, double height = 1.4]) =>
        TextStyle(
          fontFamily: bodyFamily,
          fontSize: size,
          fontWeight: w,
          letterSpacing: letterSpacing,
          height: height,
          color: scheme.onSurface,
        );

    TextStyle display(double size, FontWeight w,
            {double letter = -0.5, double height = 1.1}) =>
        TextStyle(
          fontFamily: displayFamily,
          fontSize: size,
          fontWeight: w,
          letterSpacing: letter,
          height: height,
          color: scheme.onSurface,
        );

    final TextTheme inter = TextTheme(
      displayLarge: display(40, FontWeight.w800, letter: -0.8, height: 1.05),
      displayMedium: display(30, FontWeight.w800, letter: -0.6),
      displaySmall: display(26, FontWeight.w800, letter: -0.5, height: 1.15),
      headlineLarge: display(24, FontWeight.w800, letter: -0.5, height: 1.2),
      headlineMedium: display(20, FontWeight.w700, letter: -0.3, height: 1.25),
      headlineSmall: display(18, FontWeight.w700, letter: -0.2, height: 1.25),
      titleLarge: display(17, FontWeight.w700, letter: -0.2, height: 1.25),
      titleMedium: body(15, FontWeight.w600),
      titleSmall: body(13, FontWeight.w600),
      bodyLarge: body(15, FontWeight.w500),
      bodyMedium: body(14, FontWeight.w400).copyWith(
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: body(12, FontWeight.w400).copyWith(
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: body(14, FontWeight.w600),
      labelMedium: body(12, FontWeight.w600, 0.1),
      labelSmall: body(11, FontWeight.w600, 0.2),
    );

    final bg = brightness == Brightness.light
        ? AppPalette.lightBackground
        : AppPalette.darkBackground;

    final textTheme = inter;

    final systemOverlay = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: systemOverlay,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(color: scheme.outline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          backgroundColor: brightness == Brightness.dark
              ? AppPalette.darkSurfaceRaised
              : AppPalette.lightSurfaceRaised,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? AppPalette.darkSurfaceRaised
            : AppPalette.lightSurfaceRaised,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark
            ? AppPalette.darkSurfaceRaised
            : AppPalette.lightSurfaceRaised,
        selectedColor: scheme.primary,
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        secondaryLabelStyle: TextStyle(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? AppPalette.darkBackground
            : AppPalette.lightBackground,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? AppPalette.darkSurfaceRaised
            : AppPalette.lightSurfaceRaised,
        contentTextStyle: TextStyle(color: scheme.onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withValues(alpha: 0.18),
        thumbColor: scheme.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: 0.18),
        linearMinHeight: 6,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : scheme.onSurfaceVariant.withValues(alpha: 0.8),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.outline,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
