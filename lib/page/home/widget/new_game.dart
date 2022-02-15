import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/game/level.dart';
import 'package:dgo_puzzle/page/home/widget/difficulty_selection.dart';
import 'package:dgo_puzzle/page/home/widget/level_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeNewGame extends StatefulWidget {
  final double? maxWidth;

  const HomeNewGame({Key? key, this.maxWidth}) : super(key: key);

  @override
  _HomeNewGameState createState() => _HomeNewGameState();
}

class _HomeNewGameState extends State<HomeNewGame>
    with SingleTickerProviderStateMixin {
  Difficulty _difficulty = Difficulty.easy;
  Level? _level;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildDifficultySection(),
          ),
          const SizedBox(height: 20.0),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(height: 240),
            child: LevelSelection(
              selected: _level,
              onValueChanged: _onLevelSelected,
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildForm(context),
          ),
        ],
      ),
    );
  }

  void _onLevelSelected(Level level) {
    setState(() {
      _level = level;
    });
  }

  Widget _buildDifficultySection() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: widget.maxWidth),
        child: DifficultySelection(
          onValueChanged: _selectDifficulty,
          selected: _difficulty,
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints.tightFor(width: widget.maxWidth ?? double.infinity),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ElevatedButton(
            onPressed: _level != null ? _playGame : null,
            child: Text(
              AppLocalizations.of(context)!.play_game_button,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _selectDifficulty(Difficulty? difficulty) {
    setState(() {
      _difficulty = difficulty ?? _difficulty;
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
