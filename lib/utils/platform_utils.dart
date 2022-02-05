import 'package:flutter/foundation.dart';

extension MobilePlatform on TargetPlatform {
  bool get isMobile {
    switch(this) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return true;
      default: return false;
    }
  }
}