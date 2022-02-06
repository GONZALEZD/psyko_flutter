import 'dart:async';
import 'dart:ui';


import 'package:flutter/foundation.dart';

class GameStatus extends ValueNotifier<GameStatusData> {
  Timer? _timer;
  DateTime? _startDate;

  GameStatus() : super(GameStatusData.zero);

  void startTimer({Duration? timerPeriodicTick}) {
    _startDate = DateTime.now();
    _timer = Timer.periodic(
        timerPeriodicTick ?? const Duration(seconds: 1), onTimerPeriodic);
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void updateData(bool isComplete, int numberOfRemainingTiles, int nbMoves) {
    value = value.copyWith(
      isComplete: isComplete,
      remainingTiles: numberOfRemainingTiles,
      moves: nbMoves,
    );
    if(isComplete && numberOfRemainingTiles == 0) {
      stopTimer();
    }
  }

  void onTimerPeriodic(Timer timer) {
    final duration = DateTime.now().difference(_startDate!);
    value = value.copyWith(
      ellapsedTime: duration,
    );
  }
}

class GameStatusData {
  final Duration ellapsedTime;
  final bool isComplete;
  final int remainingTiles;
  final int movesCount;

  static const zero = GameStatusData(
      ellapsedTime: Duration.zero, isComplete: false, remainingTiles: 0, movesCount: 0);

  const GameStatusData({required this.ellapsedTime,
    required this.isComplete,
    required this.remainingTiles, required this.movesCount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GameStatusData &&
              ellapsedTime == other.ellapsedTime &&
              isComplete == other.isComplete &&
              remainingTiles == other.remainingTiles;

  @override
  int get hashCode => hashValues(ellapsedTime, isComplete, remainingTiles);

  GameStatusData copyWith(
      {Duration? ellapsedTime, bool? isComplete, int? remainingTiles, int? moves}) {
    return GameStatusData(
      ellapsedTime: ellapsedTime ?? this.ellapsedTime,
      isComplete: isComplete ?? this.isComplete,
      remainingTiles: remainingTiles ?? this.remainingTiles,
      movesCount: moves ?? this.movesCount,
    );
  }
}