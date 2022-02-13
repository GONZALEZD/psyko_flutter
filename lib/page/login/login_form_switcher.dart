import 'package:dgo_puzzle/page/login/account_creation_form.dart';
import 'package:dgo_puzzle/page/login/login_form.dart';
import 'package:dgo_puzzle/page/login/login_main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginFormSwitcher extends StatefulWidget {


  const LoginFormSwitcher({Key? key}) : super(key: key);

  @override
  _LoginFormSwitcherState createState() => _LoginFormSwitcherState();
}


class _LoginFormSwitcherState extends State<LoginFormSwitcher> {
  MainMenuChoice? state;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final axis = MediaQuery.of(context).size.aspectRatio > 1.0 ? Axis.horizontal : Axis.vertical;
    buildChild() {
      switch (state) {
        case null:
          return LoginMainMenu(direction: axis, onSelected: _onMenuSelection);
        case MainMenuChoice.createAccount:
          return const AccountCreationForm();
        case MainMenuChoice.login:
          return const LoginForm();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: buildChild(),
        ),
        if (state != null) _buildBackButton(),
      ],
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextButton.icon(
        onPressed: _goToMainMenu,
        icon: const Icon(Icons.arrow_back),
        label: Text(AppLocalizations.of(context)!.login_go_back_button),
      ),
    );
  }

  void _onMenuSelection(MainMenuChoice choice) {
    setState(() {
      state = choice;
    });
  }

  void _goToMainMenu() {
    setState(() {
      state = null;
    });
  }
}
