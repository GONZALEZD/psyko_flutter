import 'dart:math';

import 'package:dgo_puzzle/game/level.dart';
import 'package:dgo_puzzle/page/home/widget/level_listview_item.dart';
import 'package:dgo_puzzle/service/levels.dart';
import 'package:flutter/material.dart';

typedef OnLevelSelected = void Function(Level selected);

class LevelSelection extends StatelessWidget {

  final OnLevelSelected onValueChanged;
  final Level? selected;

  const LevelSelection({Key? key, required this.onValueChanged, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Level>>(
      future: Levels.of(context).retrieveLevels(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final levels = snapshot.data ?? [];
          final fraction = min(1.0, 196.0/MediaQuery.of(context).size.width);
          return PageView.builder(
              itemCount: levels.length,
              controller: PageController(viewportFraction: fraction),
              onPageChanged: (index) => onValueChanged(levels[index]),
              itemBuilder: (context, index) {
                return LevelListviewItem(
                  level: levels[index],
                  isSelected: selected == levels[index],
                  onLevelSelected: onValueChanged,
                );
              });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
