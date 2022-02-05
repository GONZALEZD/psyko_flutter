import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:dgo_puzzle/animations/board_spread_animatable.dart';
import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:dgo_puzzle/animations/tween_board.dart';
import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/game/game_status.dart';
import 'package:dgo_puzzle/game/score.dart';
import 'package:dgo_puzzle/page/play/game_board.dart';
import 'package:dgo_puzzle/provider/levels.dart';
import 'package:dgo_puzzle/provider/scores.dart';
import 'package:dgo_puzzle/provider/user_login.dart';
import 'package:dgo_puzzle/widget/board_widget.dart';
import 'package:dgo_puzzle/widget/image_tile.dart';
import 'package:engine/engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlayPage extends StatelessWidget {
  final GameData game;

  const PlayPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBoard(
        game: game,
      ),
    );
  }
}

class AnimatedBoard extends StatefulWidget {
  final GameData game;

  const AnimatedBoard({Key? key, required this.game}) : super(key: key);

  @override
  _AnimatedBoardState createState() => _AnimatedBoardState();
}

class _AnimatedBoardState extends State<AnimatedBoard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<BoardState> _animation;

  late Board _board;

  final _tileMoveDuration = const Duration(milliseconds: 300);
  late Duration _tileSetupDuration;

  late GameStatus _status;

  @override
  void initState() {
    super.initState();
    _board = Board.sized(widget.game.difficulty.boardSide);
    _board.shuffle();

    _tileSetupDuration = Duration(milliseconds: 150 * _board.tilesCount);
    _controller =
        AnimationController(vsync: this, duration: _tileSetupDuration);
    _animation = AlwaysStoppedAnimation(BoardState.fromBoard(_board));
    _controller.forward(from: 0.0);
    _status = GameStatus();
    _board.listener = onBoardUpdate;
    _status.startTimer();
  }

  void onBoardUpdate(bool isComplete, int remainingTiles, int movesCount) {
    _status.updateData(isComplete, remainingTiles, movesCount);
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

  void onTileClicked(int tileId) {
    if (_board.canBeMoved(tileId)) {
      final before = BoardState.fromTiles(_board.tiles, _board.side);
      _board.move(tileId);
      final after = BoardState.fromTiles(_board.tiles, _board.side);

      setState(() {
        _controller.duration = _tileMoveDuration;
        _animation = TweenBoard(begin: before, end: after)
            .chain(CurveTween(curve: Curves.easeInCubic))
            .animate(_controller);
        _controller.forward(from: 0.0);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    final textColor = Theme.of(context).colorScheme.onSurface;
    const padding = 16.0;
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        centerTitle: true,
        systemOverlayStyle: appBarTheme,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: padding),
              child: GameBoard(
                gameStatus: _status,
              ),
            ),
            AspectRatio(
              aspectRatio: 1.0,
              child: _buildBoard(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    Widget title =
        Text(widget.game.level.fullName(Localizations.localeOf(context)));
    if (kDebugMode) {
      title = GestureDetector(
        onTap: () {
          _board.resolve();
          _animation = AlwaysStoppedAnimation(BoardState.fromBoard(_board));
          _controller.forward(from: 1.0);
        },
        child: title,
      );
    }
    return title;
  }

  Widget _buildBoard(BuildContext context) {
    final whitespace = _board.whitespace;
    return FutureBuilder<ImageProvider>(
      future: Levels.of(context)
          .loadPuzzle(widget.game.level)
          .then((raw) => MemoryImage(raw)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return BoardWidget(
            side: _board.side,
            tiles: _board.solution
                .map((tile) => _buildTile(tile, snapshot.data!,
                    isWhiteSpace: tile.id == whitespace.id,
                    rightPlace: _board.isTileInCorrectPlace(tile.id)))
                .toList(),
            animation: _animation,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildTile(
    Tile tile,
    ImageProvider image, {
    bool isWhiteSpace = false,
    bool rightPlace = false,
  }) {
    final isComplete = _board.isComplete();
    return GestureDetector(
      onTap: isWhiteSpace ? null : () => onTileClicked(tile.id),
      child: AnimatedContainer(
        duration: _tileSetupDuration,
        padding: EdgeInsets.all(isComplete ? 0.0 : 2.0),
        child: AnimatedOpacity(
          opacity: isWhiteSpace && !isComplete ? 0.0 : 1.0,
          duration: _tileSetupDuration,
          child: ImageTile.fromTile(image, tile, _board.side, !rightPlace),
        ),
      ),
    );
  }
}
