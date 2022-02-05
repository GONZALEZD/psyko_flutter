import 'package:debug_toolbox/src/debug_toolbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Toolbox extends StatefulWidget {
  final MaterialAppBuilder appBuilder;

  const Toolbox({Key? key, required this.appBuilder})
      : super(key: key);

  @override
  _ToolboxState createState() => _ToolboxState();

  static DebugToolbox? of(BuildContext context) {
    final state = context.findAncestorStateOfType<_ToolboxState>();
    return state!.toolbox;
  }
  static maybeShowToolbox(BuildContext context) {
    if(kDebugMode) {
      final toolbox = Toolbox.of(context);
      if(toolbox != null) {
        Actions.maybeInvoke(context, ShowToolboxIntent(toolbox: toolbox));
      }
    }
  }
}

typedef MaterialAppBuilder = MaterialApp Function(
    BuildContext context, MaterialAppConfig config);

class _ToolboxState extends State<Toolbox> {
  late DebugToolbox toolbox;

  @override
  void initState() {
    super.initState();
    toolbox = DebugToolbox();
    if (kDebugMode) {
      toolbox.shortcuts = {
        const SingleActivator(LogicalKeyboardKey.f12):
        ShowToolboxIntent(toolbox: toolbox)
      };
      toolbox.actions = {
        ShowToolboxIntent : ShowToolboxAction()
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MaterialAppConfig>(
      valueListenable: toolbox,
      builder: (context, value, child) {
        return widget.appBuilder(context, toolbox.value);
      },
    );
  }
}