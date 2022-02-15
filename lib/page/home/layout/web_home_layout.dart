import 'package:dgo_puzzle/page/home/layout/web_dialog.dart';
import 'package:dgo_puzzle/page/home/widget/home_ranking.dart';
import 'package:dgo_puzzle/page/home/widget/home_rules.dart';
import 'package:dgo_puzzle/page/home/widget/new_game.dart';
import 'package:dgo_puzzle/widget/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebHomeLayout extends StatelessWidget {
  const WebHomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: WebAppBar(
        title: Text(localizedStrings.app_title),
        centeredActions: _buildActions(context),
      ),
      body: const Center(child: HomeNewGame(maxWidth: 400.0)),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return [
      _buildAction(context,
          name: localizedStrings.menu_scores,
          action: () => _onRankingClicked(context)),
      _buildAction(context,
          name: localizedStrings.menu_game_rules,
          action: () => _onHelpClicked(context)),
      const SizedBox(
        width: 12.0,
      ),
    ];
  }

  Widget _buildAction(BuildContext context,
      {required String name, required VoidCallback action}) {
    return TextButton(
      onPressed: action,
      child: Text(name),
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(120, 40)),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.w500)),
          shape: MaterialStateProperty.all(null),
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor.withOpacity(0.05)),
          side: MaterialStateProperty.all(BorderSide.none)),
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
              viewportFraction: 0.9,
            ),
            size: const Size(300, 450),
          );
        });
  }
}
