import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:dgo_puzzle/page/home/layout/action_data_layout.dart';
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
    final width = MediaQuery.of(context).size.width;
    print("COUCOU $width");
    return Scaffold(
      appBar: _buildAppBar(context, width > 800.0),
      body: const Center(child: HomeNewGame(maxWidth: 400.0)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool extendedDisplay) {
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
    if (extendedDisplay) {
      return WebAppBar(
        title: DebugAccessWrapper(child: Text(localizedStrings.app_title)),
        centeredActions: _buildActions(context, actionsData, true),
      );
    } else {
      return AppBar(
        title: DebugAccessWrapper(child: Text(localizedStrings.app_title)),
        actions: _buildActions(context, actionsData, false),
        automaticallyImplyLeading: false,
      );
    }
  }

  List<Widget> _buildActions(
      BuildContext context, List<ActionData> actionData, bool displayIcon) {
    return [
      ...actionData
          .map((action) => displayIcon
              ? action.buildAsLink(context)
              : action.buildAsIcon(context))
          .toList(),
      const SizedBox(width: 12.0),
    ];
  }

  void _onRankingClicked(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return WebDialog(
            title: AppLocalizations.of(context)!.menu_scores,
            content: const HomeRanking(),
            size: const Size(350, 450),
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
              viewportFraction: 0.8,
            ),
            size: const Size(350, 450),
          );
        });
  }
}
