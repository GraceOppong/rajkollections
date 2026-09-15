import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'warehouse_image.dart';

/// Tall oval frame on the right edge, matching the session splash mockup.
class SessionHeroCircle extends StatelessWidget {
  const SessionHeroCircle({
    super.key,
    this.frameWidth,
    this.frameHeight,
  });

  final double? frameWidth;
  final double? frameHeight;

  /// Source art is cream on top and warehouse on the bottom — anchor the crop
  /// on the boxed aisle so the label reads like the mockup.
  static const imageAlignment = Alignment(-0.22, 0.88);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;
    final width = frameWidth ?? screenW * 0.60;
    final height = frameHeight ?? screenH * 0.50;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.all(Radius.elliptical(width / 2, height / 2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.sand.withValues(alpha: 0.4),
              blurRadius: 28,
              offset: const Offset(-6, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipOval(
            child: ColoredBox(
              color: AppColors.creamDark,
              child: WarehouseImage(
                gradientOverlay: false,
                fit: BoxFit.cover,
                alignment: imageAlignment,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
