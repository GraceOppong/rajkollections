import 'package:flutter/material.dart';

class WarehouseImage extends StatelessWidget {
  const WarehouseImage({
    super.key,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.gradientOverlay = true,
  });

  final BorderRadius? borderRadius;
  final BoxFit fit;
  final Alignment alignment;
  final bool gradientOverlay;

  static const assetPath = 'assets/images/warehouse_background.jpg';

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      fit: fit,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,
    );

    if (!gradientOverlay) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: image,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF5F0E8).withValues(alpha: 0.92),
                  const Color(0xFFF5F0E8).withValues(alpha: 0.35),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 0.65],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
