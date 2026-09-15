import 'package:flutter/material.dart';

enum AppFormFactor { mobile, tablet }

AppFormFactor formFactorOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 600) return AppFormFactor.tablet;
  return AppFormFactor.mobile;
}

bool isTablet(BuildContext context) =>
    formFactorOf(context) == AppFormFactor.tablet;

/// Max content width on large screens so tablet layouts stay readable.
double contentMaxWidth(BuildContext context) {
  return isTablet(context) ? 720 : double.infinity;
}
