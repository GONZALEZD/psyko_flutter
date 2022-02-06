import 'package:flutter/material.dart';

enum LayoutType {
  smartphoneAndroid,
  smartphoneIOS,
  tabletAndroid,
  tabletIOS,
  computer,
}

extension LayoutTypeGroups on LayoutType {
  bool get isSmartphone =>
      [LayoutType.smartphoneAndroid, LayoutType.smartphoneIOS].contains(this);

  bool get isTablet =>
      [LayoutType.tabletAndroid, LayoutType.tabletIOS].contains(this);
}

extension LayoutTypeData on BuildContext {
  LayoutType get layoutType {
    final isSmartphoneWidth = MediaQuery.of(this).size.shortestSide < 600;
    switch (Theme.of(this).platform) {
      case TargetPlatform.android:
        return isSmartphoneWidth
            ? LayoutType.smartphoneAndroid
            : LayoutType.tabletAndroid;
      case TargetPlatform.iOS:
        return isSmartphoneWidth
            ? LayoutType.smartphoneIOS
            : LayoutType.tabletIOS;
      default:
        return LayoutType.computer;
    }
  }
}
