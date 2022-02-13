
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MainMenuChoice {
  login,
  createAccount,
}
typedef OnLoginMenuSelection = void Function(MainMenuChoice choice);

class LoginMainMenu extends StatelessWidget {
  final Axis direction;
  final OnLoginMenuSelection onSelected;

  const LoginMainMenu({Key? key, required this.direction, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = _buildButtons(context);
    switch(direction) {
      case Axis.vertical: {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
      }
      case Axis.horizontal: {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: children,
        );
      }
    }
  }

  List<Widget> _buildButtons(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return [
      TextButton(
          onPressed: () => onSelected(MainMenuChoice.createAccount),
          child: Text(strings.login_create_account_button)),
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
            onPressed: () => onSelected(MainMenuChoice.login),
            child: Text(strings.login_connect_button)),
      ),
    ];
  }
}
