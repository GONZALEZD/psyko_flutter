import 'package:dgo_puzzle/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class AppColor extends MaterialStateProperty<Color> {
  final Color enabled;
  final Color disabled;
  final Color error;
  final Color hoover;

  AppColor(
      {required this.enabled,
        required this.disabled,
        required this.error,
        required this.hoover});

  factory AppColor.fromScheme(Color enabled, ColorScheme scheme) {
    return AppColor(
      enabled: enabled,
      disabled: scheme.disabled,
      error: scheme.error,
      hoover: enabled.withOpacity(0.8),
    );
  }

  @override
  Color resolve(Set<MaterialState> states) {
    if(states.contains(MaterialState.error)) {
      return error;
    }
    else if(states.contains(MaterialState.disabled)) {
      return disabled;
    }
    else {
      return enabled;
    }
  }
}