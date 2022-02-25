import 'dart:ui';

import 'package:engine/engine.dart';

class TileState {
  final double dx;
  final double dy;
  final double scale;
  final int id;

  TileState(
      {required this.dx,
      required this.dy,
      required this.id,
      required this.scale});

  static TileState lerp(TileState from, TileState to, double t) {
    assert(from.id == to.id);
    return TileState(
      dx: lerpDouble(from.dx, to.dx, t)!,
      dy: lerpDouble(from.dy, to.dy, t)!,
      scale: lerpDouble(from.scale, to.scale, t)!,
      id: from.id,
    );
  }

  TileState copyWith({double? dx, double? dy, double? scale}) {
    return TileState(
        dx: dx ?? this.dx,
        dy: dy ?? this.dy,
        id: id,
        scale: scale ?? this.scale);
  }

  @override
  String toString() => "TileState(id:$id, x:$dx, y:$dy";
}

typedef BoardFunction = TileState Function(TileState, double t);

class BoardState {
  final List<TileState> tiles;

  BoardState({required this.tiles});

  static BoardState lerp(BoardState from, BoardState to, double t,
      {BoardFunction? function}) {
    assert(from.tiles.length == to.tiles.length);
    List<TileState> lerpTiles = [];
    TileState currentTile;
    for (int i = 0; i < from.tiles.length; i++) {
      currentTile = TileState.lerp(from.tiles[i], to.tiles[i], t);
      currentTile = function?.call(currentTile, t) ?? currentTile;
      lerpTiles.add(currentTile);
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
                  scale: 1.0,
                  id: tile.id,
                ))
            .toList());
  }
  BoardState apply(BoardFunction function, double t) {
    return BoardState(
      tiles: tiles.map((e) => function(e, t)).toList()
    );
  }

  factory BoardState.identity(int side) {
    final unitPercent = 1.0 / side.toDouble();
    return BoardState(
        tiles: List.generate(
            side * side,
            (index) => TileState(
                dx: (index % side) * unitPercent,
                dy: (index ~/ side) * unitPercent,
                scale: 1.0,
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
