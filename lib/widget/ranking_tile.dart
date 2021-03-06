import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/score.dart';
import 'package:flutter/material.dart';

class RankingTile extends StatelessWidget {
  final int rank;
  final String playerName;
  final Duration time;
  final int movesCount;
  final int score;

  const RankingTile({Key? key, required this.rank, required this.playerName, required this.time, required this.movesCount, required this.score}) : super(key: key);

  factory RankingTile.score(Score score, int rank) => RankingTile(
    rank: rank,
    playerName: score.playerName,
    time: score.duration,
    movesCount: score.moveCount,
    score: score.score,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text("$rank"),
        title: Row(
          children: [
            Text(playerName),
            const Spacer(),
            Text("$score"),
          ],
        ),
        subtitle: Row(
          children: [
            Text("$movesCount coups"),
            const Spacer(),
            Text(time.toString().split(".")[0])
          ],
        ),
      ),
    );
  }
}
