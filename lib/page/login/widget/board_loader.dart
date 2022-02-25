import 'dart:math';

import 'package:dgo_puzzle/animations/board_spread_animatable.dart';
import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:dgo_puzzle/animations/tween_board.dart';
import 'package:dgo_puzzle/widget/board_tile_widget.dart';
import 'package:dgo_puzzle/widget/board_widget.dart';
import 'package:engine/engine.dart';
import 'package:flutter/material.dart';

class BoardLoader extends StatefulWidget {
  const BoardLoader({Key? key}) : super(key: key);

  @override
  _BoardLoaderState createState() => _BoardLoaderState();
}

class _BoardLoaderState extends State<BoardLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<BoardState> _animation;
  late Board _board;
  Tile? _previousTile;
  late double cumulatedTime;

  Map<int,Color> tileColors = {};

  @override
  void initState() {
    super.initState();
    cumulatedTime = 0;
    _board = Board.sized(5);
    final colors = MaterialColorList.all();
    tileColors = _board.tiles.asMap().map((index, tile) => MapEntry(tile.id, colors[index%colors.length]));
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = BoardSpreadAnimatable.fromBoard(_board).animate(_controller);
    _controller.forward(from: 0.0);
    _controller.addStatusListener(animStatusListener);
  }

  void animStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      cumulatedTime += _controller.duration!.inMilliseconds;
      _moveBoard();
    }
  }

  void _moveBoard() {
    _controller.duration = const Duration(milliseconds: 1000);
    final begin = BoardState.fromBoard(_board);
    final possibleTiles = _board.movableTiles();
    possibleTiles.shuffle();
    Tile moveTile = possibleTiles.first;
    if (moveTile.id == _previousTile?.id) {
      moveTile = possibleTiles.last;
    }
    _board.moveTile(moveTile);
    _previousTile = moveTile;
    final end = BoardState.fromBoard(_board);
    setState(() {
      _animation = ProceduralTweenBoard(
          begin: begin,
          end: end,
        function: boardProcedure,
      )
          .chain(CurveTween(curve: Curves.easeInOutCirc))
          .animate(_controller);
      _controller.forward(from: 0.0);
    });
  }

  TileState boardProcedure(TileState tile, double t) {
    final time = cumulatedTime + _controller.value*(_controller.duration?.inMilliseconds ?? 0.0);
    final shift = ((tile.dx + tile.dy)/2.5)*pi*2;
    return tile.copyWith(
      scale: sin(time/1000.0 + shift)*0.1 + 0.95,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BoardWidget(
      side: _board.side,
      tiles: _board.tiles.map((tile) {
        if (tile.id == _board.whitespace.id) {
          return const SizedBox.shrink();
        } else {
          return BoardTileWidget(
            color: tileColors[tile.id]!,
          );
        }
      }).toList(),
      animation: _animation,
    );
  }
}

extension MaterialColorList on List<Color> {
  static List<Color> all() => [
    Colors.tealAccent.shade400, Colors.greenAccent.shade400, Colors.cyan, Colors.lightBlue, Colors.blue.shade600,
    Colors.greenAccent.shade400, Colors.cyan, Colors.lightBlue, Colors.blue.shade600, Colors.blue.shade800,
    Colors.cyan, Colors.lightBlue, Colors.blue.shade600, Colors.blue.shade800, Colors.deepPurple,
    Colors.lightBlue, Colors.blue.shade600, Colors.blue.shade800, Colors.deepPurple, Colors.purple.shade600,
    Colors.blue.shade600, Colors.blue.shade800, Colors.deepPurple, Colors.purple.shade600, Colors.pink.shade800
  ];
}