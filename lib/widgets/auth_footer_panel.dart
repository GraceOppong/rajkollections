import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'warehouse_image.dart';

/// Warehouse hero strip with script motto — used on login and signing-in screens.
class AuthFooterPanel extends StatelessWidget {
  const AuthFooterPanel({
    super.key,
    required this.scriptLines,
    this.heightFactor = 0.30,
  });

  final List<String> scriptLines;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final preferred = MediaQuery.sizeOf(context).height * heightFactor;
        final height = constraints.maxHeight.isFinite
            ? preferred.clamp(0.0, constraints.maxHeight)
            : preferred;

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(72),
                  topRight: Radius.circular(28),
                ),
                child: const WarehouseImage(
                  alignment: Alignment(-0.15, 0.85),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < scriptLines.length; i++) ...[
                      if (i > 0) const SizedBox(height: 2),
                      Text(
                        scriptLines[i],
                        textAlign: TextAlign.center,
                        style: AppTypography.script(
                          fontSize: scriptLines.length > 1 ? 26 : 30,
                          color: AppColors.bronze,
                          height: 1.05,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Container(
                      width: 48,
                      height: 1,
                      color: AppColors.bronze.withValues(alpha: 0.45),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'INVENTORY  ·  ORDERS  ·  DELIVERIES  ·  GROWTH',
                      textAlign: TextAlign.center,
                      style: AppTypography.inter(
                        fontSize: 8,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w500,
                        color: AppColors.coffeeMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
