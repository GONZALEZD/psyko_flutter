import 'package:flutter/material.dart';

extension AppColorScheme on ColorScheme {

  Color get divider => onSurface.withOpacity(0.35);
  Color get disabled => onSurface.withOpacity(0.1);

  static ColorScheme light({
    required Color primary,
    required Color accent,
    required Color primaryDark,
    required Color accentDark,
  }) =>
      ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        primaryVariant: primaryDark,
        secondary: accent,
        secondaryVariant: accentDark,
        surface: const Color(0xffFFFFFF),
        onSurface: const Color(0xff464646),
        background: const Color(0xffF5F5F6),
        onBackground: const Color(0xff464646),
        error: Colors.redAccent.shade700,
        onError: const Color(0xffF5F5F5),
        onPrimary: const Color(0xff242424),
        onSecondary: const Color(0xff242424),
      );

  static ColorScheme dark({
    required Color primary,
    required Color accent,
    required Color primaryDark,
    required Color accentDark,
  }) =>
      ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        primaryVariant: primaryDark,
        secondary: accent,
        secondaryVariant: accentDark,
        surface: const Color(0xff151517),
        onSurface: const Color(0xffF0F0F0),
        background: const Color(0xff0F0F0F),
        onBackground: const Color(0xffF0F0F0),
        error: const Color(0xffFF4242),
        onError: const Color(0xffF5F5F5),
        onPrimary: const Color(0xffF5F5F5),
        onSecondary: const Color(0xffF5F5F5),
      );
}
