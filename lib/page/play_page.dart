import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/page/play/game_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayPage extends StatelessWidget {
  final GameData game;

  const PlayPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
        appBar: AppBar(
          title: _buildTitle(context),
          centerTitle: true,
          systemOverlayStyle: appBarTheme,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: textColor,
        ),
        body: Builder(
          builder: (c) => _buildBody(c),
        ));
  }

  Widget _buildBody(BuildContext context) {
    Widget body = GameBoard(
      game: game,
    );
    if (context.layoutType.isSmartphone) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: body,
      );
    } else {
      final side = MediaQuery.of(context).size.shortestSide;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: side, height: side),
          child: body,
        ),
      );
    }
  }

  Widget _buildTitle(BuildContext context) {
    return DebugAccessWrapper(
      child: Text(
        game.level.fullName(Localizations.localeOf(context)),
      ),
    );
  }
}
