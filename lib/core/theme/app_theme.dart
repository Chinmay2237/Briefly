import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class AppTheme {
  static final ColorScheme _lightScheme =
      ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppConstants.primaryColor,
        onPrimary: const Color(0xFFFFFFFF),
        primaryContainer: const Color(0xFFD9E2FF),
        onPrimaryContainer: const Color(0xFF001A41),
        secondary: const Color(0xFF9C4200),
        onSecondary: const Color(0xFFFFFFFF),
        secondaryContainer: const Color(0xFFFFDCC7),
        onSecondaryContainer: const Color(0xFF331100),
        tertiary: const Color(0xFF006B5E),
        onTertiary: const Color(0xFFFFFFFF),
        tertiaryContainer: const Color(0xFF8AF2DD),
        onTertiaryContainer: const Color(0xFF00201B),
        surface: const Color(0xFFF8F9FF),
        surfaceContainerLowest: const Color(0xFFFFFFFF),
        surfaceContainerLow: const Color(0xFFF1F3FB),
        surfaceContainer: const Color(0xFFE9ECF4),
        surfaceContainerHigh: const Color(0xFFE0E3EC),
        surfaceContainerHighest: const Color(0xFFD8DAE4),
        onSurface: const Color(0xFF171C25),
        onSurfaceVariant: const Color(0xFF454A59),
        outline: const Color(0xFF767B8C),
        outlineVariant: const Color(0xFFC5C7D3),
        inverseSurface: const Color(0xFF2C303A),
        onInverseSurface: const Color(0xFFF0F1FA),
        error: const Color(0xFFBA1A1A),
        onError: const Color(0xFFFFFFFF),
        errorContainer: const Color(0xFFF7D6D3),
        onErrorContainer: const Color(0xFF5C1E1D),
      );

  static final ColorScheme _darkScheme =
      ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFFADC6FF),
        onPrimary: const Color(0xFF002E6A),
        primaryContainer: const Color(0xFF00458E),
        onPrimaryContainer: const Color(0xFFD9E2FF),
        secondary: const Color(0xFFFFB68B),
        onSecondary: const Color(0xFF542000),
        secondaryContainer: const Color(0xFF783000),
        onSecondaryContainer: const Color(0xFFFFDCC7),
        tertiary: const Color(0xFF6DDBC7),
        onTertiary: const Color(0xFF00372F),
        tertiaryContainer: const Color(0xFF005047),
        onTertiaryContainer: const Color(0xFF8AF2DD),
        surface: const Color(0xFF10131A),
        surfaceContainerLowest: const Color(0xFF0B0E14),
        surfaceContainerLow: const Color(0xFF191C24),
        surfaceContainer: const Color(0xFF1D2029),
        surfaceContainerHigh: const Color(0xFF282B34),
        surfaceContainerHighest: const Color(0xFF333640),
        onSurface: const Color(0xFFE1E2EB),
        onSurfaceVariant: const Color(0xFFC4C6D2),
        outline: const Color(0xFF8E909D),
        outlineVariant: const Color(0xFF444651),
        inverseSurface: const Color(0xFFE1E2EB),
        onInverseSurface: const Color(0xFF2D3039),
        error: const Color(0xFFFFB4AB),
        onError: const Color(0xFF690005),
        errorContainer: const Color(0xFF93000A),
        onErrorContainer: const Color(0xFFFFDAD6),
      );

  static ThemeData get lightTheme => _buildTheme(
    colorScheme: _lightScheme,
    scaffoldBackground: AppConstants.backgroundLight,
    cardColor: AppConstants.cardLight,
    textTheme: _textTheme(Brightness.light),
  );

  static ThemeData get darkTheme => _buildTheme(
    colorScheme: _darkScheme,
    scaffoldBackground: AppConstants.backgroundDark,
    cardColor: AppConstants.cardDark,
    textTheme: _textTheme(Brightness.dark),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    return base.copyWith(
      headlineMedium: base.headlineMedium?.copyWith(
        height: 1.15,
        letterSpacing: -0.2,
      ),
      titleLarge: base.titleLarge?.copyWith(height: 1.25, letterSpacing: -0.1),
      titleMedium: base.titleMedium?.copyWith(height: 1.25),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.55),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.5),
      bodySmall: base.bodySmall?.copyWith(height: 1.45),
      labelLarge: base.labelLarge?.copyWith(height: 1.35),
      labelMedium: base.labelMedium?.copyWith(height: 1.35),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required TextTheme textTheme,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: cardColor,
      textTheme: textTheme,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground.withValues(alpha: 0.96),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.36)),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.96),
        indicatorColor: colorScheme.primaryContainer,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.96),
        indicatorColor: colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        modalBackgroundColor: colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.primary,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
          fontWeight: FontWeight.w700,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
