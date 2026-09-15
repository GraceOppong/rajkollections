import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Temporary destination after splash until main app screens exist.
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Text(
          'Main app coming next',
          style: AppTypography.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.coffeeMuted,
          ),
        ),
      ),
    );
  }
}
