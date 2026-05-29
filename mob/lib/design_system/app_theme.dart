import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_extensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.neutralBg,
      textTheme: AppTypography.textTheme,

      // Map standard material pieces
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.tertiary,
      ),

      // Inject custom extensions
      extensions: const [
        TerminalColors(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          neutralBg: AppColors.neutralBg,
        ),
      ],
    );
  }
}
