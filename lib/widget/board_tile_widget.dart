import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoardTileWidget extends StatelessWidget {
  final Color color;

  const BoardTileWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.5), color, color.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.7, 1.0]
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
