import 'dart:math';

import 'package:debug_toolbox/src/widget/config_widget.dart';
import 'package:flutter/material.dart';

class ToolboxDialog extends StatelessWidget {
  const ToolboxDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Size(max(300, MediaQuery.of(context).size.shortestSide),
        max(300, MediaQuery.of(context).size.height * 0.8));
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle(context, size.width),
              SizedBox(
                child: const Divider(),
                width: size.width,
              ),
              SizedBox.fromSize(
                size: size,
                child: const MaterialAppConfigWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, double maxWidth) {
    return Padding(
      padding: const EdgeInsets.all(20.0) - const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              "Debug toolbox",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
