import 'package:dgo_puzzle/game/difficulty.dart';

class Score {
  final Difficulty difficulty;
  final String levelId;
  final Duration duration;
  final int moveCount;
  final String playerName;
  final String userId;

  int get score =>
      (difficulty.scoreMultiplier * 5000).toInt() -
      moveCount * duration.inMinutes;

  Score({
    required this.difficulty,
    required this.levelId,
    required this.duration,
    required this.moveCount,
    required this.playerName,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'player_name': playerName,
      'player_id': userId,
      'moves_count': moveCount,
      'duration': duration.inSeconds,
      'level_id': levelId,
      'difficulty': difficulty.index,
      'score': score
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      userId: map['player_id'],
      playerName: map['player_name'],
      moveCount: map['moves_count'],
      duration: Duration(seconds: map['duration']),
      levelId: map['level_id'],
      difficulty: Difficulty.values[map['difficulty']],
    );
  }

  @override
  String toString() {
    return "$Score(${toMap()})";
  }
}

extension DifficultyMultiplier on Difficulty {
  double get scoreMultiplier {
    switch (this) {
      case Difficulty.easy:
        return 1.0;
      case Difficulty.medium:
        return 1.5;
      case Difficulty.hard:
        return 2.0;
    }
  }
}
