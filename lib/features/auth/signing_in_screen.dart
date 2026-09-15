import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/auth_security_banner.dart';
import '../../widgets/rk_logo.dart';
import '../../widgets/splash_background.dart';

class SigningInScreen extends StatefulWidget {
  const SigningInScreen({super.key, this.onComplete});

  /// Called after the simulated sign-in steps finish (UI only).
  final VoidCallback? onComplete;

  @override
  State<SigningInScreen> createState() => _SigningInScreenState();
}

class _SigningInScreenState extends State<SigningInScreen> {
  int _completedSteps = 0;
  Timer? _stepTimer;

  @override
  void initState() {
    super.initState();
    _stepTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _completedSteps = 1);
      _stepTimer = Timer(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        setState(() => _completedSteps = 2);
        _stepTimer = Timer(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          setState(() => _completedSteps = 3);
          _stepTimer = Timer(const Duration(milliseconds: 450), () {
            if (!mounted) return;
            widget.onComplete?.call();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SplashBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              const RkLogo(monogramSize: 64),
              const SizedBox(height: 32),
              const Center(
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.bronze,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Signing you in...',
                textAlign: TextAlign.center,
                style: AppTypography.inter(
                  fontSize: tablet ? 26 : 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please wait while we securely\nauthenticate your account.',
                textAlign: TextAlign.center,
                style: AppTypography.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 32),
              _SignInStepRow(
                title: 'Verifying credentials',
                subtitle: 'Checking your email and password',
                done: _completedSteps > 0,
                active: _completedSteps == 0,
              ),
              const SizedBox(height: 22),
              _SignInStepRow(
                title: 'Setting up your session',
                subtitle: 'Creating a secure connection',
                done: _completedSteps > 1,
                active: _completedSteps == 1,
              ),
              const SizedBox(height: 22),
              _SignInStepRow(
                title: 'Loading your workspace',
                subtitle: 'Almost there...',
                done: _completedSteps > 2,
                active: _completedSteps == 2,
              ),
              const SizedBox(height: 28),
              const AuthSecurityBanner(
                title: 'Your data is encrypted and protected',
                subtitle:
                    'We use industry-standard security to keep your information safe.',
                icon: Icons.shield_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInStepRow extends StatelessWidget {
  const _SignInStepRow({
    required this.title,
    required this.subtitle,
    required this.done,
    required this.active,
  });

  final String title;
  final String subtitle;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? AppColors.bronze : null,
            border: done
                ? null
                : Border.all(
                    color: active ? AppColors.bronze : AppColors.sand,
                    width: 2,
                  ),
          ),
          child: done
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
