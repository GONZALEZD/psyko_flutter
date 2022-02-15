import 'package:dgo_puzzle/page/home/layout/action_data_layout.dart';
import 'package:dgo_puzzle/page/home/layout/web_dialog.dart';
import 'package:dgo_puzzle/page/home/widget/home_ranking.dart';
import 'package:dgo_puzzle/page/home/widget/home_rules.dart';
import 'package:dgo_puzzle/page/home/widget/new_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabletHomeLayout extends StatelessWidget {
  const TabletHomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(localizedStrings.app_title),
        actions: _buildActions(context),
      ),
      body: const Center(child: HomeNewGame(maxWidth: 400.0)),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    final actionsData = [
      ActionData(
        name: localizedStrings.menu_scores,
        icon: Icons.sports_score,
        onTap: () => _onRankingClicked(context),
      ),
      ActionData(
        name: localizedStrings.menu_game_rules,
        icon: Icons.help_outline,
        onTap: () => _onHelpClicked(context),
      ),
    ];
    return [
      ...actionsData.map((action) => action.buildAsIcon(context)).toList(),
      const SizedBox(width: 12.0,),
    ];
  }

  void _onRankingClicked(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return WebDialog(
            title: AppLocalizations.of(context)!.menu_scores,
            content: const HomeRanking(),
            size: const Size(400, 400),
          );
        });
  }

  void _onHelpClicked(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return WebDialog(
            title: AppLocalizations.of(context)!.menu_game_rules,
            content: HomeTutorial(
              onTutorialEnd: (skipped) => Navigator.of(context).maybePop(),
              viewportFraction: 0.9,
            ),
            size: const Size(300, 450),
          );
        });
  }
}
