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

  factory TweenBoard.fromBoardTiles(int side, List<Tile> from, List<Tile> to,
      {BoardFunction? function}) {
    assert(from.length == side * side);
    assert(to.length == side * side);
    final begin = BoardState.fromTiles(from, side);
    final end = BoardState.fromTiles(to, side);
    if (function != null) {
      return ProceduralTweenBoard(function: function,
          begin: begin.apply(function, 0.0),
          end: end.apply(function, 1.0),
      );
    }

    return TweenBoard(begin: begin, end: end);
  }
}

class ProceduralTweenBoard extends TweenBoard {
  final BoardFunction function;

  ProceduralTweenBoard(
      {required this.function,
      required BoardState begin,
      required BoardState end})
      : super(begin: begin, end: end);


  @override
  BoardState transform(double t) {
    return super.transform(t).apply(function, t);
  }
}
