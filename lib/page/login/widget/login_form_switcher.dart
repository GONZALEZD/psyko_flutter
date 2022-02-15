import 'package:dgo_puzzle/page/login/widget/account_creation_form.dart';
import 'package:dgo_puzzle/page/login/widget/login_form.dart';
import 'package:dgo_puzzle/page/login/widget/login_main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef WidthConstraintBuilder = double? Function(LoginMenuChoice menu);

class LoginFormSwitcher extends StatefulWidget {
  final WidthConstraintBuilder? menuWidth;

  const LoginFormSwitcher({Key? key, this.menuWidth}) : super(key: key);

  @override
  _LoginFormSwitcherState createState() => _LoginFormSwitcherState();
}

class _LoginFormSwitcherState extends State<LoginFormSwitcher> {
  late LoginMenuChoice state;

  @override
  void initState() {
    super.initState();
    state = LoginMenuChoice.main;
  }

  @override
  Widget build(BuildContext context) {
    final axis = MediaQuery.of(context).size.aspectRatio > 1.0
        ? Axis.horizontal
        : Axis.vertical;
    buildChild() {
      switch (state) {
        case LoginMenuChoice.main:
          return LoginMainMenu(direction: axis, onSelected: _onMenuSelection);
        case LoginMenuChoice.createAccount:
          return const AccountCreationForm();
        case LoginMenuChoice.login:
          return const LoginForm();
      }
    }

    final width = widget.menuWidth?.call(state);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: width),
            child: buildChild(),
          ),
          if (state != LoginMenuChoice.main)
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: width),
              child: _buildBackButton(),
            ),
        ],
      ),
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

  void _onMenuSelection(LoginMenuChoice choice) {
    setState(() {
      state = choice;
    });
  }

  void _goToMainMenu() {
    setState(() {
      state = LoginMenuChoice.main;
    });
  }
}
