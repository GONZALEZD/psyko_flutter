import 'dart:math' as math;

import 'package:flutter/material.dart';

// RETRIEVED FROM SDK: material/elevation_overlay.dart
// Compute the opacity for the given elevation
// This formula matches the values in the spec:
// https://material.io/design/color/dark-theme.html#properties
Color createOverlayColor(
    {required double elevation,
    required Color background,
    required Color foreground}) {
  final double opacity = (4.5 * math.log(elevation + 1) + 2) / 100.0;
  return Color.alphaBlend(foreground.withOpacity(opacity), background);
}
