import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/game/level.dart';
import 'package:dgo_puzzle/page/home/widget/level_listview_item.dart';
import 'package:dgo_puzzle/provider/levels.dart';
import 'package:dgo_puzzle/widget/board_tile_widget.dart';
import 'package:dgo_puzzle/widget/board_widget.dart';
import 'package:engine/engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeNewGame extends StatefulWidget {
  const HomeNewGame({Key? key}) : super(key: key);

  @override
  _HomeNewGameState createState() => _HomeNewGameState();
}

class _HomeNewGameState extends State<HomeNewGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Board _board;
  Difficulty _difficulty = Difficulty.easy;
  Level? _level;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _board = Board.sized(_difficulty.boardSide);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildSegmentedControl(),
          _buildBoard(),
          _buildLevelSelection(),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    final localizedStrings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CupertinoSlidingSegmentedControl(
        children: {
          Difficulty.easy: Text(localizedStrings.game_difficulty_easy),
          Difficulty.medium: Text(localizedStrings.game_difficulty_medium),
          Difficulty.hard: Text(localizedStrings.game_difficulty_hard),
        },
        onValueChanged: _selectDifficulty,
        groupValue: _difficulty,
      ),
    );
  }

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size.square(100)),
        child: BoardWidget(
            side: _board.side,
            tiles: _board.tiles
                .map(
                  (tile) => BoardTileWidget(
                    color: _difficulty.associatedColor,
                  ),
                )
                .toList()),
      ),
    );
  }

  Widget _buildLevelSelection() {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 240),
      child: FutureBuilder<List<Level>>(
        future: Levels.of(context).retrieveLevels(),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final levels = snapshot.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              itemCount: levels.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  LevelListviewItem(level:levels[index],
                    isSelected: _level == levels[index],
                    onLevelSelected: onLevelSelected,
                  ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void onLevelSelected(Level level) {
    setState(() {
      _level = level;
    });
  }

  Widget _buildForm() {
    final localizedStrings = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 300),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: _level != null ? _playGame : null,
          child: Text(localizedStrings.play_game_button),
        ),
      ),
    );
  }

  void _selectDifficulty(Difficulty? difficulty) {
    setState(() {
      _difficulty = difficulty ?? _difficulty;
      _board = Board.sized(_difficulty.boardSide);
    });
  }

  void _playGame() {
    Navigator.of(context).pushNamed(
      "/play",
      arguments: GameData(
        level: _level!,
        difficulty: _difficulty,
      ),
    );
  }
}
