import 'package:dgo_puzzle/page/home/widget/new_game.dart';
import 'package:dgo_puzzle/page/home/widget/ranking.dart';
import 'package:dgo_puzzle/page/home/widget/rules.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return LayoutScaffold(
      actions: [
        LayoutAction(
            id: 0,
            name: localizedStrings.menu_new_game,
            icon: Icons.games_outlined,
            routeName: "/newGame"),
        LayoutAction(
            id: 1, name: localizedStrings.menu_scores, icon: Icons.build, routeName: "/score"),
        LayoutAction(
            id: 2, name: localizedStrings.menu_game_rules, icon: Icons.help_outline, routeName: "/help"),
        LayoutAction(
            id: 10, name: localizedStrings.menu_my_profile, icon: Icons.person, routeName: "/score/me"),
      ],
      selectedActionIndex: controller.index,
      actionCallback: (action) {
        if (action.id < 3) {
          controller.index = action.id;
          setState(() {});
        } else {
          print(action.routeName);
        }
      },
      actionBuilder: (action, platform, size, orientation) {
        if (action.id == 10) {
          return LayoutActionRendering.navBar;
        }
        return LayoutActionRendering.bottomBar;
      },
      selectedActionTint: Colors.red,
      navigationTitle: Text(localizedStrings.app_title),
      bodyBuilder: (platform, actions) => _buildBody(),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: controller,
      children: [
        const HomeNewGame(),
        const HomeRanking(),
        HomeRules(),
      ],
    );
  }
}
