import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:dgo_puzzle/animations/tween_board.dart';
import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/service/levels.dart';
import 'package:dgo_puzzle/widget/board_widget.dart';
import 'package:dgo_puzzle/widget/image_tile.dart';
import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

mixin AnimatedBoardMixin<T extends StatefulWidget>
on SingleTickerProviderStateMixin<T> {
  GameData? _gameData;

  late AnimationController _controller;
  late Animation<BoardState> _animation;

  late Board board;

  final _tileMoveDuration = const Duration(milliseconds: 300);
  final _finishMoveDuration = const Duration(milliseconds: 500);
  late Duration _tileSetupDuration;
  Future<ImageProvider>? _loading;

  void initBoard(GameData gameData) {
    _gameData = gameData;
    board = Board.sized(gameData.difficulty.boardSide);
    board.shuffle();

    _tileSetupDuration = Duration(milliseconds: 150 * board.tilesCount);
    _controller =
        AnimationController(vsync: this, duration: _tileSetupDuration);
    _animation = AlwaysStoppedAnimation(BoardState.fromBoard(board));
    _controller.forward(from: 0.0);
    board.listener = onBoardUpdate;
  }

  @override
  void didChangeDependencies() {
    assert(_gameData != null, "You must initialize board first.");
    if (_gameData != null) {
      _loading = Levels.of(context)
          .loadPuzzle(_gameData!.level)
          .then((raw) => MemoryImage(raw))
          .then((image) {
        onBoardLoaded();
        return image;
      });
    }
  }

  Widget buildBoard(BuildContext context) {
    final whitespace = board.whitespace;
    return FutureBuilder<ImageProvider>(
      future: _loading,
      builder: (c, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: BoardWidget(
              side: board.side,
              tiles: board.solution
                  .map((tile) =>
                  _buildTile(tile, snapshot.data!,
                      isWhiteSpace: tile.id == whitespace.id,
                      rightPlace: board.isTileInCorrectPlace(tile.id)))
                  .toList(),
              animation: _animation,
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildTile(Tile tile,
      ImageProvider image, {
        bool isWhiteSpace = false,
        bool rightPlace = false,
      }) {
    final isComplete = board.isComplete();

    final beginAnimation = TileUIModel(
      padding: const EdgeInsets.all(2.0),
      opacity: isWhiteSpace ? 0.0 : 1.0,
      borderRadius: BorderRadius.circular(8.0),
    );
    return GestureDetector(
      onTap: isWhiteSpace ? null : () => onTileClicked(tile.id),
      child: TweenAnimationBuilder<TileUIModel>(
        duration: _finishMoveDuration,
        tween: TileTween(
            begin: beginAnimation,
            end: isComplete ? TileUIModel.zero : beginAnimation
        ),
        builder: (context, model, child) {
          return Padding(
            padding: model.padding,
            child: Opacity(opacity: model.opacity, child: ImageTile.fromTile(
              image,
              tile,
              board.side,
              !rightPlace,
              model.borderRadius,
            ),),);
        },
      ),
    );
  }

  void onBoardUpdate(bool isComplete, int remainingTiles, int movesCount);

  void onBoardLoaded();

  void onTileClicked(int tileId) {
    if (board.canBeMoved(tileId)) {
      final before = BoardState.fromTiles(board.tiles, board.side);
      board.move(tileId);
      final after = BoardState.fromTiles(board.tiles, board.side);

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

  @protected
  void resolveGame() {
    board.resolve();
    _animation = AlwaysStoppedAnimation(BoardState.fromBoard(board));
    _controller.forward(from: 1.0);
  }
}

class TileUIModel {
  final EdgeInsets padding;
  final double opacity;
  final BorderRadius borderRadius;

  const TileUIModel(
      {required this.padding, required this.opacity, required this.borderRadius});

  static TileUIModel lerp(TileUIModel begin, TileUIModel end, double t) {
    return TileUIModel(
      padding: EdgeInsets.lerp(begin.padding, end.padding, t) ??
          EdgeInsets.zero,
      opacity: lerpDouble(begin.opacity, end.opacity, t) ?? 0.0,
      borderRadius: BorderRadius.lerp(
          begin.borderRadius, end.borderRadius, t) ?? BorderRadius.zero,
    );
  }

  static const TileUIModel zero = TileUIModel(
      padding: EdgeInsets.zero, opacity: 1.0, borderRadius: BorderRadius.zero);
}

class TileTween extends Tween<TileUIModel> {

  TileTween({TileUIModel? begin, TileUIModel? end})
      :super(begin: begin, end: end);

  @override
  TileUIModel lerp(double t) {
    assert(begin != null);
    assert(end != null);
    return TileUIModel.lerp(begin!, end!, t);
  }
}