import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.bronze,
        brightness: Brightness.light,
        surface: AppColors.cream,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.coffee,
        displayColor: AppColors.coffee,
        decoration: TextDecoration.none,
        decorationColor: Colors.transparent,
      ),
    );
  }
}
