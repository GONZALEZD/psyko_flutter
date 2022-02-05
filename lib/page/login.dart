import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:dgo_puzzle/page/login/board_loader.dart';
import 'package:dgo_puzzle/page/login/login_form.dart';
import 'package:dgo_puzzle/page/login/login_form_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: Column(
        children: [
          const Spacer(),
          _buildTitle(context),
          const Spacer(),
          _buildLoader(context),
          const Spacer(),
          _buildForm(context),
          const Spacer()
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {

    return Text(
      AppLocalizations.of(context)!.app_title,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _buildLoader(BuildContext context) {
    final loader = Container(
      constraints: BoxConstraints.tight(const Size.square(200)),
      child: const BoardLoader(),
    );
    if (kDebugMode) {
      return GestureDetector(
        onLongPress: () {
          HapticFeedback.selectionClick();
          Toolbox.maybeShowToolbox(context);
        },
        child: loader,
      );
    } else {
      return loader;
    }
  }

  Widget _buildForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 200),
      child: const LoginFormSwitcher(),
    );
  }
}
