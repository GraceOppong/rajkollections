import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../auth/signing_in_screen.dart';
import '../auth/staff_login_screen.dart';
import '../workspace/workspace_screen.dart';
import 'brand_splash_screen.dart';
import 'session_splash_screen.dart';

/// Brand splash → session splash → Staff Login (UI timing only).
class SplashFlow extends StatefulWidget {
  const SplashFlow({super.key});

  @override
  State<SplashFlow> createState() => _SplashFlowState();
}

class _SplashFlowState extends State<SplashFlow> {
  var _showSession = false;
  var _showLogin = false;
  var _showSigningIn = false;
  var _showWorkspace = false;
  Timer? _toSession;
  Timer? _toLogin;

  @override
  void initState() {
    super.initState();
    _toSession = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _showSession = true);
      _toLogin = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _showLogin = true);
      });
    });
  }

  @override
  void dispose() {
    _toSession?.cancel();
    _toLogin?.cancel();
    super.dispose();
  }

  void _openSigningIn() {
    if (!mounted) return;
    setState(() => _showSigningIn = true);
  }

  void _openWorkspace() {
    if (!mounted) return;
    setState(() => _showWorkspace = true);
  }

  void _signOut() {
    if (!mounted) return;
    setState(() {
      _showWorkspace = false;
      _showSigningIn = false;
      _showLogin = true;
      _showSession = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showWorkspace) {
      return WorkspaceScreen(onSignOut: _signOut);
    }

    if (_showSigningIn) {
      return SigningInScreen(onComplete: _openWorkspace);
    }

    if (_showLogin) {
      return StaffLoginScreen(onSignIn: _openSigningIn);
    }

    return Material(
      color: AppColors.cream,
      child: _showSession
          ? const SessionSplashScreen()
          : const BrandSplashScreen(),
    );
  }
}
