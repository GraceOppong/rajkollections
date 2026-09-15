import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/rk_logo.dart';
import '../../widgets/session_hero_circle.dart';
import '../../widgets/splash_background.dart';
import '../../theme/splash_decor.dart';
/// Width for copy on the left so feature rows stay out of the hero frame.
double _sessionCopyMaxWidth(
  double screenWidth, {
  required bool tablet,
  required double frameWidth,
}) {
  if (tablet) {
    const circleBleed = 0.10;
    const pad = 48.0;
    const gap = 32.0;
    final frameLeft = screenWidth - frameWidth * (1 - circleBleed);
    return (frameLeft - pad - gap).clamp(300.0, screenWidth * 0.52);
  }

  const circleBleed = 0.38;
  const pad = 24.0;
  const gap = 24.0;
  final frameLeft = screenWidth - frameWidth * (1 - circleBleed);
  return (frameLeft - pad - gap).clamp(240.0, screenWidth * 0.72);
}

/// Phase 2: simulated session check (UI only — no backend calls).
class SessionSplashScreen extends StatelessWidget {
  const SessionSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      child: SafeArea(
        child: isTablet(context) ? const _TabletLayout() : const _MobileLayout(),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  static const _frameWidthFactor = 0.54;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final frameWidth = width * _frameWidthFactor;
    final frameTop = SplashDecor.heroFrameTopInContent(context);
    final frameHeight = (height * 0.52).clamp(260.0, 420.0);
    final copyWidth = _sessionCopyMaxWidth(
      width,
      tablet: false,
      frameWidth: frameWidth,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: frameTop,
          right: -(frameWidth * 0.36),
          child: SessionHeroCircle(
            frameWidth: frameWidth,
            frameHeight: frameHeight,
          ),
        ),
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RkLogo(monogramSize: 64, compact: true),
                const SizedBox(height: 68),
                SizedBox(
                  width: copyWidth,
                  child: Text(
                    'Welcome back!',
                    style: AppTypography.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: copyWidth,
                  child: const _WelcomeSessionStatus(fontSize: 14),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: copyWidth,
                  child: const _FeatureList(),
                ),
                const SizedBox(height: 32),
                const Center(child: _SessionLoadingBlock()),
                const SizedBox(height: 16),
                const _SupabaseBadge(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  static const _frameWidthFactor = 0.32;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final frameWidth = width * _frameWidthFactor;
    final frameHeight = height * 0.58;
    final copyWidth = _sessionCopyMaxWidth(
      width,
      tablet: true,
      frameWidth: frameWidth,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 72,
          right: -(frameWidth * 0.12),
          child: SessionHeroCircle(
            frameWidth: frameWidth,
            frameHeight: frameHeight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RkLogo(monogramSize: 72),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: copyWidth,
                      child: Text(
                        'Welcome back!',
                        style: AppTypography.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coffee,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: copyWidth,
                      child: const _WelcomeSessionStatus(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: copyWidth,
                          child: const _FeatureList(spacious: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _SessionLoadingBlock(alignStart: true),
                    const SizedBox(height: 20),
                    const _SupabaseBadge(),
                  ],
                ),
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class _WelcomeSessionStatus extends StatelessWidget {
  const _WelcomeSessionStatus({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final secondary = AppTypography.inter(
      fontSize: fontSize,
      color: AppColors.textSecondary,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Checking your session...',
            maxLines: 1,
            softWrap: false,
            style: secondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Just a moment.',
          style: secondary,
        ),
      ],
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({this.spacious = false});

  final bool spacious;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureRow(
          icon: Icons.shield_outlined,
          title: 'Secure Access',
          subtitle: 'Your data stays safe.',
          spacious: spacious,
        ),
        SizedBox(height: spacious ? 28 : 24),
        _FeatureRow(
          icon: Icons.bolt_outlined,
          title: 'Fast & Reliable',
          subtitle: 'Get to work quickly.',
          spacious: spacious,
        ),
        SizedBox(height: spacious ? 28 : 24),
        _FeatureRow(
          icon: Icons.inventory_2_outlined,
          title: 'Built for the Warehouse',
          subtitle: 'Inventory. Orders. Deliveries.',
          spacious: spacious,
          singleLineTitle: true,
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.spacious,
    this.singleLineTitle = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool spacious;
  final bool singleLineTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacious ? 4 : 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: spacious ? 44 : 40,
            height: spacious ? 44 : 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.creamDark,
            ),
            child: Icon(icon, size: spacious ? 22 : 20, color: AppColors.bronze),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                singleLineTitle
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          maxLines: 1,
                          softWrap: false,
                          style: AppTypography.inter(
                            fontSize: spacious ? 16 : 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.coffee,
                            height: 1.25,
                          ),
                        ),
                      )
                    : Text(
                        title,
                        style: AppTypography.inter(
                          fontSize: spacious ? 16 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coffee,
                          height: 1.25,
                        ),
                      ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTypography.inter(
                    fontSize: spacious ? 14 : 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionLoadingBlock extends StatelessWidget {
  const _SessionLoadingBlock({this.alignStart = false});

  final bool alignStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.bronze,
            backgroundColor: AppColors.sand.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Checking your session...',
          style: AppTypography.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.bronze,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'This won\'t take long.',
          textAlign: alignStart ? TextAlign.start : TextAlign.center,
          style: AppTypography.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SupabaseBadge extends StatelessWidget {
  const _SupabaseBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cream,
            ),
            child: const Icon(Icons.lock_outline, size: 18, color: AppColors.bronze),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Protected by Supabase',
                  style: AppTypography.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffee,
                  ),
                ),
                Text(
                  'Secure authentication for Raj Kollections staff.',
                  style: AppTypography.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
