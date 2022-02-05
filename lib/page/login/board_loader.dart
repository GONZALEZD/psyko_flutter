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

  Map<int,Color> tileColors = {};

  @override
  void initState() {
    super.initState();
    _board = Board.sized(3);
    tileColors = _board.tiles.asMap().map((index, tile) => MapEntry(tile.id, MaterialColorList.all()[index]));
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = BoardSpreadAnimatable.fromBoard(_board).animate(_controller);
    _controller.forward(from: 0.0);
    _controller.addStatusListener(animStatusListener);
  }

  void animStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _moveBoard();
    }
  }

  void _moveBoard() {
    _controller.duration = const Duration(milliseconds: 250);
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
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _animation = TweenBoard(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOutCirc))
            .animate(_controller);
        _controller.forward(from: 0.0);
      });
    });
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
    Colors.deepPurpleAccent,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.teal,
    Colors.greenAccent,
    Colors.amber,
    Colors.orange,
    Colors.red.shade600,
    Colors.pink,
  ];
}