import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/score.dart';
import 'package:dgo_puzzle/service/scores.dart';
import 'package:dgo_puzzle/widget/ranking_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeRanking extends StatelessWidget {
  const HomeRanking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Score>>(
      future: PlayerScore.of(context).scoresBoard(),
      builder: (context, snap) {
        if (snap.hasData && (snap.data?.isNotEmpty ?? false)) {
          final scores = snap.data!;
          final data = _computeScoresList(scores);

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Widget? child;
              if (data[index] is Difficulty) {
                child = _buildDifficultyTitle(
                  context,
                  (data[index] as Difficulty),
                );
              } else {
                MapEntry<int, Score> m = data[index] as MapEntry<int, Score>;
                child = RankingTile.score(m.value, m.key + 1);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: child,
              );
            },
            itemCount: data.length,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<dynamic> _computeScoresList(List<Score> scores) {
    buildData(Difficulty difficulty) {
      return scores
          .where((score) => score.difficulty == difficulty)
          .toList()
          .asMap()
          .entries;
    }

    return [
      Difficulty.hard,
      ...buildData(Difficulty.hard),
      Difficulty.medium,
      ...buildData(Difficulty.medium),
      Difficulty.easy,
      ...buildData(Difficulty.easy),
    ];
  }

  Widget _buildDifficultyTitle(BuildContext context, Difficulty difficulty) {
    final puzzleText = AppLocalizations.of(context)!.puzzle;
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 8.0, left: 4.0),
      child: Text("$puzzleText ${difficulty.localizedName(context)}",
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
          color: difficulty.associatedColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
