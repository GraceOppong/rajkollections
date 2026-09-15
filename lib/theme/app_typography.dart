import 'package:flutter/material.dart';

/// System fonts only — avoids network font fetches that can hang iOS debug builds.
TextStyle _clean(TextStyle style) {
  return style.copyWith(
    decoration: TextDecoration.none,
    decorationColor: Colors.transparent,
  );
}

abstract final class AppTypography {
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) {
    return _clean(
      TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      ),
    );
  }

  static TextStyle cormorant({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    FontStyle? fontStyle,
  }) {
    return inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }

  static TextStyle script({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return inter(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: color,
      height: height,
    );
  }
}
