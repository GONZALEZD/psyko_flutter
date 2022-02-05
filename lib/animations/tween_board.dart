import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:engine/engine.dart';
import 'package:flutter/widgets.dart';

class TweenBoard extends Tween<BoardState> {
  TweenBoard({required BoardState begin, required BoardState end})
      : super(begin: begin, end: end);

  @override
  BoardState lerp(double t) {
    assert(begin != null);
    assert(end != null);
    final l = BoardState.lerp(begin!, end!, t);
    return l;
  }

  static TweenBoard fromBoardTiles(int side, List<Tile> from, List<Tile> to) {
    assert(from.length == side * side);
    assert(to.length == side * side);
    return TweenBoard(
      begin: BoardState.fromTiles(from, side),
      end: BoardState.fromTiles(to, side),
    );
  }
}