
import 'package:dgo_puzzle/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum LoginMenuChoice {
  main,
  login,
  createAccount,
}
typedef OnLoginMenuSelection = void Function(LoginMenuChoice choice);

class LoginMainMenu extends StatelessWidget {
  final Axis direction;
  final OnLoginMenuSelection onSelected;

  const LoginMainMenu({Key? key, required this.direction, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    switch(direction) {
      case Axis.vertical: {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCreateAccount(context, strings),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _buildLogin(context, strings),
            ),
          ],
        );
      }
      case Axis.horizontal: {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _buildCreateAccount(context, strings)),
            const SizedBox(width: 40.0),
            Expanded(child: _buildLogin(context, strings)),
          ],
        );
      }
    }
  }

  Widget _buildCreateAccount(BuildContext context, AppLocalizations strings) {
    return TextButton(
        onPressed: () => onSelected(LoginMenuChoice.createAccount),
        child: Text(strings.login_create_account_button));
  }

  Widget _buildLogin(BuildContext context, AppLocalizations strings) {
    return ElevatedButton(
        onPressed: () => onSelected(LoginMenuChoice.login),
        child: Text(strings.login_connect_button));
  }
}
