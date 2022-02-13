import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/widget/board_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnDifficultySelected = void Function(Difficulty? difficulty);

class DifficultySelection extends StatelessWidget {
  final OnDifficultySelected onValueChanged;
  final Difficulty selected;

  const DifficultySelection(
      {Key? key, required this.onValueChanged, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSegmentedControl(context),
                ],
              ),
            ),
            _buildDivider(context),
            _buildBoard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 2.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2.0)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),

    );
  }

  Widget _buildSegmentedControl(BuildContext context) {
    return CupertinoSlidingSegmentedControl<Difficulty>(
      children: {
        Difficulty.easy: Text(Difficulty.easy.localizedName(context)),
        Difficulty.medium: Text(Difficulty.medium.localizedName(context)),
        Difficulty.hard: Text(Difficulty.hard.localizedName(context)),
      },
      onValueChanged: onValueChanged,
      groupValue: selected,
    );
  }

  Widget _buildBoard(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 40.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: BoardWidget(
          side: selected.boardSide,
          tiles: List.generate(selected.boardSide * selected.boardSide,
              (index) => __buildBoardTile()),
        ),
      ),
    );
  }

  Widget __buildBoardTile() {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: selected.associatedColor,
        borderRadius: BorderRadius.circular(2.0)
      ),
    );
  }
}
