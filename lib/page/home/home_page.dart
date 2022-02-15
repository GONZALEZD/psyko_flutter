import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:dgo_puzzle/page/home/layout/mobile_home_layout.dart';
import 'package:dgo_puzzle/page/home/layout/tablets_home_layout.dart';
import 'package:dgo_puzzle/page/home/layout/web_home_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.layoutType) {
      case LayoutType.smartphoneAndroid:
      case LayoutType.smartphoneIOS:
        return const MobileHomeLayout();
      case LayoutType.tabletAndroid:
      case LayoutType.tabletIOS:
        return const TabletHomeLayout();
      default:
        return const WebHomeLayout();
    }
  }
}
