
import 'package:dgo_puzzle/theme/app_color_theme.dart';
import 'package:dgo_puzzle/theme/app_theme_constants.dart';
import 'package:dgo_puzzle/theme/theme_data_factory.dart';
import 'package:flutter/material.dart';

class AppTheme {

  final light = ThemeDataFactory(
      constants: AppThemeConstants.constants,
      colorScheme: AppColorScheme.light(
          primary: Colors.lightBlue,
          primaryDark: Colors.blueGrey.shade900,
          accent: Colors.white,
          accentDark: Colors.grey.shade100,
      ),
      textTheme: Typography.material2018().englishLike,
  ).build();

  final dark = ThemeDataFactory(
    constants: AppThemeConstants.constants,
    colorScheme: AppColorScheme.dark(
      primary: Colors.blue.shade700,
      primaryDark: Colors.blueGrey.shade900,
      accent: Colors.black,
      accentDark: Colors.grey.shade800,
    ),
    textTheme: Typography.material2018().englishLike,
  ).build();
}