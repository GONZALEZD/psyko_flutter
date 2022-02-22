import 'package:dgo_puzzle/theme/app_color.dart';
import 'package:dgo_puzzle/theme/app_color_theme.dart';
import 'package:dgo_puzzle/theme/app_theme_constants.dart';
import 'package:dgo_puzzle/theme/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeDataFactory {
  final AppThemeConstants constants;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  ThemeDataFactory(
      {required this.constants,
      required this.colorScheme,
      required TextTheme textTheme})
      : textTheme = buildCustomTextTheme(textTheme, colorScheme, constants);

  ThemeData build() {
    return ThemeData.from(colorScheme: colorScheme, textTheme: textTheme)
        .copyWith(
      primaryColorDark: colorScheme.primaryVariant,
      scaffoldBackgroundColor: colorScheme.background,
      backgroundColor: colorScheme.background,
      splashColor: colorScheme.onBackground.withOpacity(0.05),
      highlightColor: colorScheme.onBackground.withOpacity(0.05),
      textSelectionTheme: buildTextFieldTheme(),
      buttonTheme: buildButtonTheme(),
      textButtonTheme: buildTextButtonTheme(),
      elevatedButtonTheme: buildElevatedButtonTheme(),
      cupertinoOverrideTheme: buildCupertinoTheme(),
      inputDecorationTheme: buildInputDecorationTheme(),
      cardTheme: buildCardTheme(),
      chipTheme: buildChipTheme(),
      dialogBackgroundColor: elevatedSurfaceColor,
      dialogTheme: buildDialogTheme(),
      iconTheme: buildIconTheme(),
      toggleableActiveColor: colorScheme.primary,
      dividerColor: colorScheme.divider,
      dividerTheme: buildDividerTheme(),
      appBarTheme: _buildAppBarTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
    );
  }

  SnackBarThemeData _buildSnackBarTheme() {
    return SnackBarThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 12.0,
      contentTextStyle: textTheme.bodyText1?.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }

  BottomNavigationBarThemeData _buildBottomNavigationBarTheme() {
    return BottomNavigationBarThemeData(
      elevation: 20.0,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.divider,
    );
  }

  AppBarTheme _buildAppBarTheme() {
    final overlayStyle = colorScheme.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    return AppBarTheme(
        foregroundColor: colorScheme.onBackground,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        toolbarHeight: 60.0,
        titleTextStyle: textTheme.headline6,
        systemOverlayStyle: overlayStyle);
  }

  ChipThemeData buildChipTheme() {
    return ChipThemeData.fromDefaults(
      primaryColor: colorScheme.onBackground,
      secondaryColor: colorScheme.onBackground,
      labelStyle: textTheme.bodyText2!,
    );
  }

  DividerThemeData buildDividerTheme() {
    return DividerThemeData(
      color: colorScheme.divider,
      thickness: 1.0,
      space: 1.0,
    );
  }

  IconThemeData buildIconTheme() {
    return IconThemeData(
      color: colorScheme.onSurface,
    );
  }

  static TextTheme buildCustomTextTheme(
      TextTheme from, ColorScheme colorScheme, AppThemeConstants constants) {
    return from
        .apply(
            displayColor: colorScheme.onSurface,
            bodyColor: colorScheme.onBackground)
        .copyWith(
          bodyText1: from.bodyText1?.copyWith(
              color: colorScheme.onSurface, fontSize: constants.body1TextSize),
          bodyText2:
              from.bodyText2?.copyWith(fontSize: constants.body2TextSize),
          button: from.button?.copyWith(fontSize: constants.buttonTextSize),
        );
  }

  CardTheme buildCardTheme() {
    return CardTheme(
      elevation: constants.cardElevation,
      shape: RoundedRectangleBorder(borderRadius: constants.cardCornerRadius),
    );
  }

  Color get elevatedSurfaceColor {
    bool isDark = colorScheme.brightness == Brightness.dark;
    return isDark
        ? createOverlayColor(
            elevation: constants.dialogElevation,
            background: colorScheme.surface,
            foreground: colorScheme.onSurface,
          )
        : colorScheme.background;
  }

  DialogTheme buildDialogTheme() {
    return DialogTheme(
      backgroundColor: elevatedSurfaceColor,
      elevation: constants.dialogElevation,
      shape: RoundedRectangleBorder(borderRadius: constants.cardCornerRadius),
    );
  }

  ButtonThemeData buildButtonTheme() {
    return ButtonThemeData(
      height: 44,
      padding: constants.buttonPadding,
      buttonColor: colorScheme.primary,
      textTheme: ButtonTextTheme.primary,
      splashColor: colorScheme.background.withOpacity(0.25),
      shape: RoundedRectangleBorder(
        borderRadius: constants.borderRadius,
      ),
    );
  }

  TextButtonThemeData buildTextButtonTheme() {
    return TextButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        padding: MaterialStateProperty.all(constants.buttonPadding),
        side: MaterialStateProperty.all(BorderSide(
          color: colorScheme.primary,
          width: 2.0,
        )),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: constants.borderRadius,
        )),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(colorScheme.primary),
      ),
    );
  }

  ElevatedButtonThemeData buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
        style: ButtonStyle(
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(48)),
      backgroundColor: AppColor.fromScheme(colorScheme.primary, colorScheme),
      padding: MaterialStateProperty.all(constants.buttonPadding),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: constants.borderRadius,
      )),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ));
  }

  CupertinoThemeData buildCupertinoTheme() {
    const defaultIOSTextTheme = CupertinoTextThemeData();
    return CupertinoThemeData(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      primaryContrastingColor: colorScheme.onPrimary,
      barBackgroundColor: Colors.transparent,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: CupertinoTextThemeData(
        primaryColor: colorScheme.primary,
        navTitleTextStyle: defaultIOSTextTheme.navTitleTextStyle.copyWith(
          color: colorScheme.onBackground,
        ),
        navLargeTitleTextStyle:
            defaultIOSTextTheme.navLargeTitleTextStyle.copyWith(
          color: colorScheme.onBackground,
        ),
      ),
    );
  }

  TextSelectionThemeData buildTextFieldTheme() {
    return TextSelectionThemeData(
      cursorColor: colorScheme.primary,
      selectionColor: colorScheme.primary.withOpacity(0.3),
      selectionHandleColor: colorScheme.primary,
    );
  }

  InputDecorationTheme buildInputDecorationTheme() {
    var hintColor = colorScheme.onSurface.withOpacity(0.6);
    var enabledBorderColor = colorScheme.primary.withOpacity(0.5);
    borderFactory(Color color) {
      return OutlineInputBorder(
        borderRadius: constants.borderRadius,
        borderSide: BorderSide(color: color, width: 2.0),
      );
    }

    return InputDecorationTheme(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: borderFactory(enabledBorderColor),
      enabledBorder: borderFactory(enabledBorderColor),
      focusedBorder: borderFactory(colorScheme.primary),
      focusColor: colorScheme.primary,
      disabledBorder: borderFactory(colorScheme.divider),
      errorBorder: borderFactory(colorScheme.error),
      labelStyle: TextStyle(fontSize: 17, color: colorScheme.onSurface),
      hintStyle: TextStyle(fontStyle: FontStyle.italic, color: hintColor),
      helperStyle: TextStyle(color: hintColor, fontSize: 14),
      helperMaxLines: 3,
    );
  }
}
