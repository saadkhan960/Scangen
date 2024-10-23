import 'package:flutter/material.dart';
import 'package:scangen/Theme/text%20theme/text_theme.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';

class CustomThemeData {
  static ThemeData customTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark, // Set to dark mode
    ),
    fontFamily: 'Poppins',
    textTheme: STextTheme.textTheme.apply(
      bodyColor: Colors.white, // Set text color to white for readability
      displayColor: Colors.white, // Set display text color to white
    ),
  );
}
