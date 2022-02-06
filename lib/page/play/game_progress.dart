import 'package:dgo_puzzle/game/game_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameProgress extends StatelessWidget {
  final ValueListenable<GameStatusData> gameStatus;

  const GameProgress({Key? key, required this.gameStatus}) : super(key: key);

  TextStyle titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!;
  }

  TextStyle dataTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline5!.copyWith(
          color: Theme.of(context).primaryColor,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GameStatusData>(
      valueListenable: gameStatus,
      builder: (context, data, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildCongratulation(context, data.isComplete),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimer(
                        context,
                        duration: data.ellapsedTime.toString().split(".").first,
                      ),
                    ),
                    Expanded(
                        child: _buildMoves(context, nbMoves: data.movesCount)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCongratulation(BuildContext context, bool hasWon) {
    return AnimatedScale(
      scale: hasWon ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.center,
      curve: Curves.easeOutBack,
      child: hasWon
          ? Text(
              AppLocalizations.of(context)!.play_congratulations,
              style: Theme.of(context).textTheme.headline3,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildTimer(BuildContext context, {required String duration}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context)!.play_timer,
            style: titleStyle(context)),
        Text(duration, style: dataTextStyle(context))
      ],
    );
  }

  Widget _buildMoves(BuildContext context, {required int nbMoves}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context)!.play_moves,
            style: titleStyle(context)),
        Text("$nbMoves", style: dataTextStyle(context))
      ],
    );
  }
}
