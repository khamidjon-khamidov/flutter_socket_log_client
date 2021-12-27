import 'package:flutter/material.dart';

import 'colors.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get warning =>
      brightness == Brightness.light ? AppColors.yellowWarning : AppColors.yellowWarning;

  Color get success =>
      brightness == Brightness.light ? AppColors.greenSuccess : AppColors.greenSuccess;

  Color get mediumEmphasisTextDark => brightness == Brightness.light
      ? AppColors.mediumEmphasisTextDark
      : AppColors.mediumEmphasisTextDark;

  Color get disabledTextDark =>
      brightness == Brightness.light ? AppColors.disabledTextDark : AppColors.disabledTextDark;
}
