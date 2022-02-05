import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoardTileWidget extends StatelessWidget {
  final Color color;

  const BoardTileWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: [color.withOpacity(0.5), color, color.withOpacity(0.5)]
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
