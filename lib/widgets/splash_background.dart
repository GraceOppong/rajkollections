import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/splash_decor.dart';

/// Soft cream backdrop with decorative arcs used on both splash phases.
class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.cream),
        Positioned(
          top: SplashDecor.topOrbTop,
          right: SplashDecor.topOrbRight,
          child: IgnorePointer(
            child: Container(
              width: SplashDecor.topOrbSize,
              height: SplashDecor.topOrbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.creamDark.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          left: -100,
          child: IgnorePointer(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sand.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
