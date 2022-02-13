import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugAccessWrapper extends StatelessWidget {
  final Widget child;
  const DebugAccessWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      return GestureDetector(
        onLongPress: () {
          HapticFeedback.selectionClick();
          Toolbox.maybeShowToolbox(context);
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}
