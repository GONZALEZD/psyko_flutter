import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

extension BoardDifficulty on Difficulty {
  int get boardSide  {
    switch(this) {
      case Difficulty.easy : return 3;
      case Difficulty.medium: return 4;
      case Difficulty.hard: return 5;
    }
  }

  Color get associatedColor {
    switch(this) {
      case Difficulty.easy : return Colors.lightBlue;
      case Difficulty.medium: return Colors.amberAccent;
      case Difficulty.hard: return Colors.redAccent;
    }
  }
}