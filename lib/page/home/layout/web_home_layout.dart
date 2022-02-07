import 'package:dgo_puzzle/page/home/layout/web_dialog.dart';
import 'package:dgo_puzzle/page/home/widget/home_ranking.dart';
import 'package:dgo_puzzle/page/home/widget/home_rules.dart';
import 'package:dgo_puzzle/page/home/widget/new_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebHomeLayout extends StatelessWidget {
  const WebHomeLayout({Key? key}) : super(key: key);

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
    return [
      _buildAction(
        name: localizedStrings.menu_scores,
        icon: Icons.sports_score,
        action: () => _onRankingClicked(context)
      ),
      _buildAction(
          name: localizedStrings.menu_game_rules,
          icon: Icons.help_outline,
          action: () => _onHelpClicked(context)
      ),
      const SizedBox(width: 12.0,),
    ];
  }

  Widget _buildAction({required String name, required IconData icon, required VoidCallback action}) {
    return IconButton(
        onPressed: action,
        icon: Icon(icon),
      tooltip: name,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
    );
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
            ),
            size: const Size(300, 400),
          );
        });
  }
}
