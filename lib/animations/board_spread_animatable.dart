import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:engine/engine.dart';
import 'package:flutter/widgets.dart';
import 'package:dgo_puzzle/animations/animation_utils.dart';

class BoardSpreadAnimatable extends Animatable<BoardState> {
  late Animatable<BoardState> parent;

  factory BoardSpreadAnimatable.fromBoard(Board board) {
    return BoardSpreadAnimatable(
      value: BoardState.fromBoard(board),
      side: board.side,
      dx: 0.5 - 1.0/(2.0*board.side),
      dy: 0.5 - 1.0/(2.0*board.side),
    );
  }

  BoardSpreadAnimatable({required BoardState value, required int side, double? dx, double? dy}) : super() {
    double delta = 1/(side*2);
    dx ??= 0.5 - delta;
    dy ??= 0.5 - delta;
    List<TileState> current = value.tiles
        .map((tile) => TileState(dx: dx!, dy: dy!, id: tile.id, scale: 1.0))
        .toList();
    List<BoardState> states = [BoardState(tiles: List.from(current))];
    for (int i = 0; i < value.tiles.length; i++) {
      current[i] = value.tiles[i];
      states.add(BoardState(tiles: List.from(current)));
    }
    parent = states.toSequence();
  }

  @override
  BoardState transform(double t) {
    return parent.transform(t);
  }
}