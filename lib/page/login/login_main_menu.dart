
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
    final strings = AppLocalizations.of(context)!;
    return Wrap(
      direction: direction,
      alignment: WrapAlignment.start,
      spacing: 20.0,
      children: [
        TextButton(
            onPressed: () => onSelected(MainMenuChoice.createAccount),
            child: Text(strings.login_create_account_button)),
        ElevatedButton(
            onPressed: () => onSelected(MainMenuChoice.login),
            child: Text(strings.login_connect_button)),
      ],
    );
  }
}
