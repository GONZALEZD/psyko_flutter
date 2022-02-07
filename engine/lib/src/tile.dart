import 'dart:ui';

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