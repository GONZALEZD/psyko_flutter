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
      ),
      body: const Center(child: HomeNewGame(maxWidth: 400.0)),
    );
  }
}
