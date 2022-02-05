import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/level.dart';
import 'package:flutter/cupertino.dart';

class GameData {
  final Level level;
  final Difficulty difficulty;

  GameData(
      {required this.level, required this.difficulty});

  @override
  int get hashCode => hashValues(level, difficulty);

  @override
  bool operator ==(Object other) {
    if (other is GameData) {
      return level == other.level &&
          difficulty == other.difficulty;
    }
    return false;
  }
}
