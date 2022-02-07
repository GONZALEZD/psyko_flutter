import 'dart:math';

import 'package:flutter/foundation.dart';

class BoardSolver {
  final int side;
  final List<int> puzzle;
  final List<int> solution;
  final int whitespaceValue;

  BoardSolver({required this.side, required this.solution, required this.puzzle, required this.whitespaceValue});


  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    assert(side * side == puzzle.length, 'tiles must be equal to size * height');
    final whiteMoves = whiteMovesCount();
    final inversions = countInversions();

    return whiteMoves.isEven && inversions.isEven
        || whiteMoves.isOdd && inversions.isOdd;
  }

  int whiteMovesCount() {
    final distance = (puzzle.indexOf(whitespaceValue) - solution.indexOf(whitespaceValue)).abs();
    return distance~/side + (distance%side);
  }

  void _permute(List<int> array, int index1, int index2) {
    final valueTmp = array[index1];
    array[index1] = array[index2];
    array[index2] = valueTmp;
  }

  int countInversions() {
    List<int> tmp = List.of(puzzle, growable: true);
    int inversionCount = 0;

    int posValue = tmp.length-1;
    int placeValue = 0;
    do {
      placeValue = solution[posValue];
      if(posValue == tmp.indexOf(placeValue)) {
        posValue--;
        continue;
      }
      _permute(tmp, posValue, tmp.indexOf(placeValue));

      posValue --;
      inversionCount++;
    } while (!listEquals(tmp, solution));
    return inversionCount;
  }
}