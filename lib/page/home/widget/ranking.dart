import 'package:dgo_puzzle/game/score.dart';
import 'package:dgo_puzzle/provider/scores.dart';
import 'package:dgo_puzzle/widget/ranking_tile.dart';
import 'package:flutter/material.dart';

class HomeRanking extends StatelessWidget {
  const HomeRanking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Score>>(
      future: PlayerScore.of(context).scoresBoard(),
      builder: (context, snap) {
        if (snap.hasData && (snap.data?.isNotEmpty ?? false)) {
          final scores = snap.data!;
          return Center(
            child: Container(
              alignment: Alignment.center,
              width: 300,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return RankingTile.score(scores[index], index + 1);
                },
                itemCount: scores.length,
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
