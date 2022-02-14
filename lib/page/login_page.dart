import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:dgo_puzzle/page/login/board_loader.dart';
import 'package:dgo_puzzle/page/login/login_form_switcher.dart';
import 'package:dgo_puzzle/page/login/login_main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuWidth = !context.layoutType.isSmartphone ? (choice){
      switch(choice) {
        case LoginMenuChoice.main: return 500.0;
        default: return 300.0;
      }
    } : null;
    Widget body = ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildLoader(context),
        _buildForm(context, menuWidth),
      ],
    );
    if (!context.layoutType.isSmartphone) {
      body = Center( child: body);
    }
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        centerTitle: true,
      ),
      extendBody: true,
      body: body,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return DebugAccessWrapper(child: Text(
      AppLocalizations.of(context)!.app_title,
    ));
  }

  Widget _buildLoader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40.0),
      constraints: BoxConstraints.tight(const Size.square(200)),
      child: const BoardLoader(),
    );
  }

  Widget _buildForm(BuildContext context, WidthConstraintBuilder? menuWidth) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: LoginFormSwitcher(menuWidth: menuWidth,),
      ),
    );
  }
}
