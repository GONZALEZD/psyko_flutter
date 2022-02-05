import 'dart:ui';

import 'package:engine/engine.dart';

class TileState {
  final double dx;
  final double dy;
  final int id;

  TileState({required this.dx, required this.dy, required this.id});

  static TileState lerp(TileState from, TileState to, double t) {
    assert(from.id == to.id);
    return TileState(
      dx: lerpDouble(from.dx, to.dx, t)!,
      dy: lerpDouble(from.dy, to.dy, t)!,
      id: from.id,
    );
  }

  @override
  String toString() => "TileState(id:$id, x:$dx, y:$dy";
}

class BoardState {
  final List<TileState> tiles;

  BoardState({required this.tiles});

  static BoardState lerp(BoardState from, BoardState to, double t) {
    assert(from.tiles.length == to.tiles.length);
    List<TileState> lerpTiles = [];
    for (int i = 0; i < from.tiles.length; i++) {
      lerpTiles.add(TileState.lerp(from.tiles[i], to.tiles[i], t));
    }
    return BoardState(tiles: lerpTiles);
  }

  factory BoardState.fromBoard(Board board) =>
      BoardState.fromTiles(board.tiles, board.side);

  factory BoardState.fromTiles(List<Tile> tiles, int side) {
    return BoardState(
        tiles: tiles
            .map((tile) => TileState(
                  dx: tile.x.toDouble() / side.toDouble(),
                  dy: tile.y.toDouble() / side.toDouble(),
                  id: tile.id,
                ))
            .toList());
  }

  factory BoardState.identity(int side) {
    final unitPercent = 1.0 / side.toDouble();
    return BoardState(
        tiles: List.generate(
            side * side,
            (index) => TileState(
                dx: (index % side) * unitPercent,
                dy: (index ~/ side) * unitPercent,
                id: index)));
  }

  String debugString(int side) {
    final ids = List.filled(tiles.length, "?");
    for (var tile in tiles) {
      int index = (tile.dx * side + tile.dy * side * side).toInt();
      String separator = index % side == (side - 1) ? "\n" : " | ";
      ids[index] = "${tile.id.toString().padLeft(2, " ")}$separator";
    }
    return ids.join();
  }

  @override
  String toString() => "BoardState(${tiles.toString()})";
}