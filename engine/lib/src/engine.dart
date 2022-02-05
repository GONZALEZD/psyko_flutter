import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

class Tile {
  final int x;
  final int y;
  final int id;

  Tile({
    required this.x,
    required this.y,
    required this.id,
  });

  @override
  int get hashCode => hashValues(x, y, id);

  @override
  bool operator ==(Object other) {
    if (other is Tile) {
      return id == other.id && x == other.x && y == other.y;
    }
    return false;
  }

  @override
  String toString() => "Tile(id=$id, x=$x, y=$y)";
}

typedef BoardStatusListener = Function(bool isComplete, int remainingTiles, int movesCount);

class Board {
  final int _whitespaceId;
  final int side;
  BoardStatusListener? listener;
  int _movesCount;

  int get tilesCount => side * side;

  late final List<int> _current;
  final List<int> _solution;

  List<Tile> get tiles => _current.toTiles(side);

  List<Tile> get solution => _solution.toTiles(side);

  Tile get whitespace {
    final index = _current.indexOf(_whitespaceId);
    final pos = _position(index);
    return Tile(
      id: _whitespaceId,
      x: pos.x,
      y: pos.y,
    );
  }

  Board._(
      {required this.side,
      required List<int> solution,
      required int whitespaceTile,
        this.listener,})
      : _solution = solution,
        _movesCount = 0,
        _whitespaceId = whitespaceTile,
        assert(solution.length == side * side) {
    _current = List.from(solution, growable: false);
  }

  factory Board.sized(int size, {int? whiteTilePos, BoardStatusListener? listener}) {
    final whitePos = whiteTilePos ?? Random().nextInt(size * size);
    assert(0 <= whitePos && whitePos < size * size);
    final tiles = List<int>.generate(size * size, (index) => index);
    return Board._(
        side: size, solution: tiles, whitespaceTile: tiles[whitePos], listener: listener);
  }

  void shuffle({Random? random}) => _current.shuffle(random);

  void resolve() {
    for(int i=0; i< _solution.length; i++) {
      _current[i] = _solution[i];
    }
    listener?.call(isComplete(), numberOfMissingTiles(), _movesCount);
  }

  bool isComplete() => listEquals<int>(_current, _solution);

  int numberOfCorrectTiles() {
    int count = 0;
    for (var i = 0; i < _current.length; i++) {
      if (_solution[i] == _current[i]) {
        count++;
      }
    }
    return count;
  }

  bool isTileInCorrectPlace(int tileId) =>
      _current.indexOf(tileId) == _solution.indexOf(tileId);

  int numberOfMissingTiles() => tilesCount - numberOfCorrectTiles();

  bool isTileMovable(Tile tile) => canBeMoved(tile.id);

  // Determines if the tapped tile can move in the direction of the whitespace
  // tile.
  bool canBeMoved(int tileId) {
    final tilePos = _position(_current.indexOf(tileId));
    final whitespaceTilePos = _position(_current.indexOf(_whitespaceId));
    if (tilePos == whitespaceTilePos) {
      return false;
    }
    // the tile must be adjacent to the whitespace tile,
    // i.e distance equal to 1
    if (tilePos.distanceTo(whitespaceTilePos) > 1.0) {
      return false;
    }
    return true;
  }

  List<Tile> movableTiles() =>
      _current.where((tileId) => canBeMoved(tileId)).toList().toTiles(side);

  void moveTile(Tile tile) => move(tile.id);

  void move(int tileId) {
    if (canBeMoved(tileId)) {
      final wPos = _current.indexOf(_whitespaceId);
      final tPos = _current.indexOf(tileId);
      _movesCount++;
      _current[wPos] = tileId;
      _current[tPos] = _whitespaceId;
      listener?.call(isComplete(), numberOfMissingTiles(), _movesCount);
    }
  }

  int _rowOf(int index) => index ~/ side;

  int _columnOf(int index) => index % side;

  Point<int> _position(int index) => Point(_columnOf(index), _rowOf(index));
}

extension ListToTiles on List<int> {
  List<Tile> toTiles(int side) {
    List<Tile> t = [];
    for (int i = 0; i < length; i++) {
      t.add(Tile(
        id: this[i],
        x: i % side,
        y: i ~/ side,
      ));
    }
    t.sort((t1, t2) => t1.id - t2.id);
    return t;
  }
}
