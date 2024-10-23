import 'package:flutter/material.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [
      AppColors.primary,
      AppColors.secondary,
    ],
  );
}
