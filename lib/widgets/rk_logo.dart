import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RkLogo extends StatelessWidget {
  const RkLogo({
    super.key,
    this.monogramSize = 72,
    this.showWordmark = true,
    this.compact = false,
  });

  final double monogramSize;
  final bool showWordmark;
  final bool compact;

  static const _monogramAsset = 'assets/images/rk_monogram.png';
  static const _lockupAsset = 'assets/images/rk_brand_lockup.png';

  @override
  Widget build(BuildContext context) {
    if (showWordmark && !compact) {
      final lockupHeight = monogramSize * 1.55;
      return Image.asset(
        _lockupAsset,
        height: lockupHeight,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          _monogramAsset,
          height: monogramSize * 0.72,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        if (showWordmark) ...[
          const SizedBox(height: 8),
          Text(
            'RAJ KOLLECTIONS',
            style: AppTypography.inter(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              letterSpacing: compact ? 2.6 : 3.4,
              color: AppColors.coffee,
            ),
          ),
        ],
      ],
    );
  }
}
