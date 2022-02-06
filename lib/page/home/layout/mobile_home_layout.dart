import 'package:dgo_puzzle/page/home/widget/home_ranking.dart';
import 'package:dgo_puzzle/page/home/widget/new_game.dart';
import 'package:dgo_puzzle/page/home/widget/rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MobileHomeLayout extends StatefulWidget {
  const MobileHomeLayout({Key? key}) : super(key: key);

  @override
  _MobileHomeLayoutState createState() => _MobileHomeLayoutState();
}

class _MobileHomeLayoutState extends State<MobileHomeLayout>
    with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(localizedStrings.app_title),
      ),
      body: Column(
        children: [
          Expanded(
              child: TabBarView(
            controller: controller,
            children: const [
              HomeNewGame(),
              HomeRanking(),
              HomeRules(),
            ],
          )),
          _buildBottomBar(context, localizedStrings),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppLocalizations strings) {
    return BottomNavigationBar(
        currentIndex: controller.index,
        onTap: (index) => setState(() => controller.index = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.play_arrow_outlined),
            activeIcon: const Icon(Icons.play_arrow),
            label: strings.menu_new_game,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star_border_rounded),
            activeIcon: const Icon(Icons.star_rounded),
            label: strings.menu_scores,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.help_outline),
            activeIcon: const Icon(Icons.help),
            label: strings.menu_game_rules,
          ),
        ]);
  }
}
