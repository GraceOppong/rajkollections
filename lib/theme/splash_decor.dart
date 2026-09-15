import 'package:flutter/material.dart';

/// Shared geometry for the soft top-right orb on splash screens.
abstract final class SplashDecor {
  static const topOrbSize = 220.0;
  static const topOrbTop = -80.0;
  static const topOrbRight = -60.0;

  /// Where the orb ends on the full-screen stack (below status bar art).
  static double get topOrbBottomScreenY => topOrbTop + topOrbSize;

  /// Y position inside [SafeArea] content where the hero frame should begin.
  static double heroFrameTopInContent(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return (topOrbBottomScreenY - safeTop + 10).clamp(4.0, double.infinity);
  }
}
