import 'package:dgo_puzzle/page/login/account_creation_form.dart';
import 'package:dgo_puzzle/page/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginFormSwitcher extends StatefulWidget {
  const LoginFormSwitcher({Key? key}) : super(key: key);

  @override
  _LoginFormSwitcherState createState() => _LoginFormSwitcherState();
}

enum _LoginState {
  mainMenu,
  createAccount,
  login,
}

class _LoginFormSwitcherState extends State<LoginFormSwitcher> {
  _LoginState state = _LoginState.mainMenu;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildChild() {
      switch (state) {
        case _LoginState.mainMenu:
          return _buildInitialState(context);
        case _LoginState.createAccount:
          return const AccountCreationForm();
        case _LoginState.login:
          return const LoginForm();
      }
    }

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: buildChild(),
        ),
        if (state != _LoginState.mainMenu) _buildBackButton(),
      ],
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: _goToMainMenu,
      child: Text(AppLocalizations.of(context)!.login_go_back_button),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
            onPressed: _onLoginClicked,
            child: Text(strings.login_connect_button)),
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: _onCreateAccountClicked,
            child: Text(strings.login_create_account_button)),
      ],
    );
  }

  void _goToMainMenu() {
    setState(() {
      state = _LoginState.mainMenu;
    });
  }

  void _onCreateAccountClicked() {
    setState(() {
      state = _LoginState.createAccount;
    });
  }

  void _onLoginClicked() {
    setState(() {
      state = _LoginState.login;
    });
  }
}
