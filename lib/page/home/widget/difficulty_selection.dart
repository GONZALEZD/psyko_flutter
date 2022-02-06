import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/widget/board_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(2.0)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),

    );
  }

  Widget _buildSegmentedControl(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return CupertinoSlidingSegmentedControl<Difficulty>(
      children: {
        Difficulty.easy: Text(localizedStrings.game_difficulty_easy),
        Difficulty.medium: Text(localizedStrings.game_difficulty_medium),
        Difficulty.hard: Text(localizedStrings.game_difficulty_hard),
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
