import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/auth_security_banner.dart';
import '../../widgets/rk_logo.dart';
import '../../widgets/splash_background.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key, this.onSignIn});

  final VoidCallback? onSignIn;

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final maxWidth = tablet ? 440.0 : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SplashBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ListView(
                key: const ValueKey('login-scroll'),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Need help?',
                      style: AppTypography.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bronze,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const RkLogo(monogramSize: 64),
                  const SizedBox(height: 28),
                  Text(
                    'Staff Login',
                    textAlign: TextAlign.center,
                    style: AppTypography.inter(
                      fontSize: tablet ? 32 : 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Access your workspace to manage\ninventory, orders and deliveries.',
                    textAlign: TextAlign.center,
                    style: AppTypography.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: AppTypography.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coffee,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _LoginTextField(
                    controller: _emailController,
                    hint: 'you@rajkollections.com',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: AppTypography.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coffee,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _LoginTextField(
                    controller: _passwordController,
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => widget.onSignIn?.call(),
                    suffix: IconButton(
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: AppTypography.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bronze,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      key: const ValueKey('sign-in-button'),
                      onPressed: widget.onSignIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.bronze,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sign In'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AuthSecurityBanner(
                    title: 'Secure & Private',
                    subtitle:
                        'Your data is protected with industry standard security.',
                    icon: Icons.shield_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.65)),
    );
    final decoration = InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.bronze),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.45),
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary.withValues(alpha: 0.75),
      ),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.bronze),
      ),
    );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(fontSize: 14, color: AppColors.coffee),
      decoration: decoration,
    );
  }
}
