import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/rk_logo.dart';
import '../../widgets/splash_background.dart';
import '../../widgets/warehouse_image.dart';

/// Phase 1: brand mark, loading copy, warehouse hero at the bottom.
class BrandSplashScreen extends StatelessWidget {
  const BrandSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return SplashBackground(
      child: SafeArea(
        child: tablet ? const _TabletLayout() : const _MobileLayout(),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        const RkLogo(monogramSize: 80),
        const SizedBox(height: 48),
        const _LoadingRing(),
        const SizedBox(height: 16),
        Text(
          'Loading your workspace...',
          style: AppTypography.cormorant(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: AppColors.coffeeMuted,
          ),
        ),
        const Spacer(flex: 2),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.34,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const WarehouseImage(
                alignment: Alignment(0, 0.35),
              ),
              const _BottomMessaging(compact: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RkLogo(monogramSize: 96),
                const SizedBox(height: 56),
                const _LoadingRing(size: 44),
                const SizedBox(height: 20),
                Text(
                  'Loading your workspace...',
                  style: AppTypography.cormorant(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: AppColors.coffeeMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const WarehouseImage(
                  gradientOverlay: false,
                  alignment: Alignment(-0.2, 0.1),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.cream.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const _BottomMessaging(compact: true, alignStart: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingRing extends StatelessWidget {
  const _LoadingRing({this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: AppColors.bronze,
        backgroundColor: AppColors.sand.withValues(alpha: 0.45),
      ),
    );
  }
}

class _BottomMessaging extends StatelessWidget {
  const _BottomMessaging({
    required this.compact,
    this.alignStart = false,
  });

  final bool compact;
  final bool alignStart;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignStart ? Alignment.bottomLeft : Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          alignStart ? 32 : 24,
          0,
          24,
          compact ? 28 : 36,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              'From Imports to Smiles',
              textAlign: alignStart ? TextAlign.start : TextAlign.center,
              style: AppTypography.script(
                fontSize: compact ? 32 : 28,
                color: AppColors.bronze,
                height: 1.1,
              ),
            ),
            SizedBox(height: compact ? 10 : 8),
            Text(
              'INVENTORY  ·  ORDERS  ·  DELIVERIES  ·  GROWTH',
              textAlign: alignStart ? TextAlign.start : TextAlign.center,
              style: AppTypography.inter(
                fontSize: compact ? 9 : 8,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
