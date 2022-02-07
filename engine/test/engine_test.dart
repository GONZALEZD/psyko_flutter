import 'package:engine/engine.dart';
import 'package:engine/src/board_solver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Engine setup', (){
    test('Initialization', (){
      const size = 3;
      const whiteSpaceIndex = 0;
      final board = Board.sized(size, whiteTilePos: whiteSpaceIndex);
      expect(board.side, size);
      expect(board.solution.length, size*size);
      expect(board.tiles, orderedEquals(board.solution));
    });
    test('Wrong initialization : whitespace out of board', (){
      const size = 3;
      int whiteSpaceIndex = 9;
      expect(() => Board.sized(size, whiteTilePos: whiteSpaceIndex), throwsAssertionError);

      whiteSpaceIndex = -1;
      expect(() => Board.sized(size, whiteTilePos: whiteSpaceIndex), throwsAssertionError);
    });
    test('Shuffle', (){
      const size = 4;
      const whiteSpaceIndex = 6;
      final board = Board.sized(size, whiteTilePos: whiteSpaceIndex);
      expect(board.tiles, orderedEquals(board.solution));
      board.shuffle();

      expect(listEquals<Tile>(board.tiles, board.solution), false);
    });
  });
  group('Engine can move tile', () {
    test('isTileMovable center', (){
      /*
       0  1   2  3
       4  5  *6  7
       8  9  10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 6);
      const movable = [2, 5, 7, 10];
      for (var tile in board.tiles) {
        expect(board.isTileMovable(tile), movable.contains(tile.id));
      }
    });
    test('isTileMovable (top left)', (){
      /*
       *0 1  2 3
       4  5   6  7
       8  9  10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 0);
      const movable = [1, 4,];
      for (var tile in board.tiles) {
        expect(board.isTileMovable(tile), movable.contains(tile.id));
      }
    });
    test('isTileMovable (top right)', (){
      /*
       0  1   2 *3
       4  5   6  7
       8  9  10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 3);
      const movable = [2, 7,];
      for (var tile in board.tiles) {
        expect(board.isTileMovable(tile), movable.contains(tile.id));
      }
    });
    test('isTileMovable (bottom left)', (){
      /*
       0    1   2  3
       4    5   6  7
       8    9  10 11
       *12 13  14 15
       */
      final board = Board.sized(4, whiteTilePos: 12);
      const movable = [8, 13,];
      for (var tile in board.tiles) {
        expect(board.isTileMovable(tile), movable.contains(tile.id));
      }
    });
    test('isTileMovable (bottom right)', (){
      /*
       0  1   2   3
       4  5   6   7
       8  9  10  11
       12 13 14 *15
       */
      final board = Board.sized(4, whiteTilePos: 15);
      const movable = [11, 14,];
      for (var tile in board.tiles) {
        expect(board.isTileMovable(tile), movable.contains(tile.id));
      }
    });
  });
  group('Engine move', (){
    test('Move Tile UP', () {
      /*
       0   1  2  3
       4   5  6  7
       8  *9 10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 9);
      const moves = [5, 1,];
      final expectedBoard = [
         0, /**/9,  2,  3,
         4,     1,  6,  7,
         8,     5, 10, 11,
        12,    13, 14, 15,
      ].toTiles(4);
      for (var tile in moves) {
        board.move(tile);
      }
      expect(board.tiles, orderedEquals(expectedBoard));
    });
  });

  group('Board Whitespace', () {
    test('Whitespace accessor', () {
      /*
       0   1  2  3
       4   5  6  7
       8  *9 10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 9);

      final actual = board.whitespace;
      final expected = Tile(id: 9, x: 1, y: 2);
      expect(actual, expected);
    });
    test('Whitespace from tiles', () {
      /*
       0   1  2  3
       4   5  6  7
       8  *9 10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 9);
      final actual = board.tiles.firstWhere((tile) => tile.id == 9);
      final expected = Tile(id: 9, x: 1, y: 2);
      expect(actual, expected);
    });
    test('Expect whitespace accessor equal to whitespace from tiles', () {
      /*
       0   1  2  3
       4   5  6  7
       8  *9 10 11
       12 13 14 15
       */
      final board = Board.sized(4, whiteTilePos: 9);
      final accessor = board.whitespace;
      final fromTiles = board.tiles.firstWhere((tile) => tile.id == 9);
      expect(accessor == fromTiles, true);
    });
  });
  group('Test inversions count', (){
    /**
     * Source: https://fr.wikipedia.org/wiki/Taquin#Algorithmique
     */
    test('Test inversion from wikipedia', () {
      final whitespace = -1;
      final board = BoardSolver(
          puzzle: [13, 2, 3, 12, 9, 11, 1, 10, whitespace, 6, 4, 14, 15, 8, 7, 5],
          solution: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, whitespace],
          side: 4, whitespaceValue: whitespace);

      final actual = board.countInversions();
      expect(actual, 11, reason: "It should be 11 permutations");
      int whitemoveActual = board.whiteMovesCount();
      expect(whitemoveActual, 4);

      expect(board.isSolvable(), false);
    });
  });
}
