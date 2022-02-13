import 'package:flutter/material.dart';

class AppThemeConstants {
  final EdgeInsets defaultPadding;
  final EdgeInsets buttonPadding;
  final BorderRadius borderRadius;
  final BorderRadius cardCornerRadius;
  final double cardElevation;
  final double dialogElevation;
  final double body1TextSize;
  final double body2TextSize;
  final double buttonTextSize;

  static const constants = AppThemeConstants(
    defaultPadding: EdgeInsets.all(8.0),
    buttonPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
    borderRadius: BorderRadius.all(Radius.circular(40.0)),
    cardCornerRadius: BorderRadius.all(Radius.circular(8.0)),
    cardElevation: 2.0,
    dialogElevation: 24.0,
    body1TextSize: 16.0,
    body2TextSize: 14.0,
    buttonTextSize: 15.0,
  );

  const AppThemeConstants({
    required this.defaultPadding,
    required this.buttonPadding,
    required this.borderRadius,
    required this.cardCornerRadius,
    required this.cardElevation,
    required this.dialogElevation,
    required this.body1TextSize,
    required this.body2TextSize,
    required this.buttonTextSize,
  });

  AppThemeConstants copyWith({
    EdgeInsets? defaultPadding,
    EdgeInsets? buttonPadding,
    BorderRadius? borderRadius,
    BorderRadius? cardCornerRadius,
    double? cardElevation,
    double? dialogElevation,
    double? body1TextSize,
    double? body2TextSize,
    double? buttonTextSize,
  }) {
    return AppThemeConstants(
      defaultPadding: defaultPadding ?? this.defaultPadding,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      cardCornerRadius: cardCornerRadius ?? this.cardCornerRadius,
      cardElevation: cardElevation ?? this.cardElevation,
      dialogElevation: dialogElevation ?? this.dialogElevation,
      body1TextSize: body1TextSize ?? this.body1TextSize,
      body2TextSize: body2TextSize ?? this.body2TextSize,
      buttonTextSize: buttonTextSize ?? this.buttonTextSize,
    );
  }

  @override
  String toString() {
    var name = runtimeType.toString();
    var paramMap = {
      "defaultPadding": defaultPadding.toString(),
      "buttonPadding": buttonPadding.toString(),
      "borderRadius" : borderRadius.toString(),
      "cardCornerRadius" : cardCornerRadius.toString(),
      "cardElevation" : cardElevation.toString(),
      "dialogElevation" : dialogElevation.toString(),
      "body1TextSize" : body1TextSize.toString(),
      "body2TextSize" : body2TextSize.toString(),
      "buttonTextSize" : buttonTextSize.toString(),

    };
    return "$name(${paramMap.toString()})";
  }
}
