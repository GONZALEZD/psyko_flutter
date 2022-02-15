import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/game/game_status.dart';
import 'package:dgo_puzzle/game/score.dart';
import 'package:dgo_puzzle/page/play/widget/animated_board_mixin.dart';
import 'package:dgo_puzzle/page/play/widget/game_progress.dart';
import 'package:dgo_puzzle/service/scores.dart';
import 'package:dgo_puzzle/service/user_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final GameData game;

  const GameBoard({Key? key, required this.game}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin, AnimatedBoardMixin {
  late GameStatus _status;

  @override
  void initState() {
    super.initState();
    initBoard(widget.game);
    _status = GameStatus();
  }

  @override
  void onBoardLoaded() {
    _status.startTimer();
  }

  @override
  void onBoardUpdate(bool isComplete, int remainingTiles, int movesCount) {
    _status.updateData(isComplete, remainingTiles, movesCount);
    if (isComplete) {
      _status.stopTimer();
    }
    final userProfile = UserLogin.of(context).profile;
    if (isComplete) {
      PlayerScore.of(context).uploadWin(Score(
        levelId: widget.game.level.id,
        difficulty: widget.game.difficulty,
        duration: _status.value.ellapsedTime,
        moveCount: _status.value.movesCount,
        playerName: userProfile.name,
        userId: userProfile.id,
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget progress = GameProgress(
      gameStatus: _status,
    );
    if (kDebugMode) {
      progress = GestureDetector(
        child: progress,
        onTap: resolveGame,
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: progress,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: buildBoard(context),
          ),
        ),
      ],
    );
  }
}
