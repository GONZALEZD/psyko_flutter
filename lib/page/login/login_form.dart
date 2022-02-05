import 'package:dgo_puzzle/provider/user_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _identifierController;
  late TextEditingController _passwordController;

  String? _errorIdentifier;
  String? _errorPassword;
  bool _enableLoginButton = false;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController(text: "inelokii@gmail.com");
    _passwordController = TextEditingController(text: "Toulouse2022@");
    _enableLoginButton = _identifierController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _identifierController,
          onChanged: _onIdentifierChanged,
          decoration: InputDecoration(
            hintText: localizedStrings.login_email_hint,
            errorText: _errorIdentifier,
          ),
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          onChanged: _onPasswordChanged,
          decoration: InputDecoration(
            hintText: localizedStrings.login_password_hint,
            errorText: _errorPassword,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ElevatedButton(
            onPressed: _enableLoginButton ? _authenticate : null,
            child: Text(localizedStrings.login_text_button),
          ),
        )
      ],
    );
  }

  void _onIdentifierChanged(String text) {
    setState(() {
      _errorIdentifier = null;
      _updateButtonState();
    });
  }

  void _onPasswordChanged(String text) {
    setState(() {
      _errorPassword = null;
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    _enableLoginButton = _passwordController.text.isNotEmpty &&
        _identifierController.text.isNotEmpty;
  }

  Future<void> _authenticate() async {
    final status = await UserLogin.of(context).login(
        email: _identifierController.text, password: _passwordController.text);
    if (status == ConnectionStatus.connected) {
      Navigator.of(context).pushNamed("/home");
    } else {
      _handleError(status);
    }
  }

  void _handleError(ConnectionStatus error) {
    final localizedStrings = AppLocalizations.of(context)!;
    setState(() {
      _errorIdentifier = null;
      _errorPassword = null;
      switch (error) {
        case ConnectionStatus.errorInvalidEmail:
          _errorIdentifier = localizedStrings.login_error_invalid_email;
          break;
        case ConnectionStatus.errorUnknownUser:
          _errorIdentifier = localizedStrings.login_error_unknown_email;
          break;
        case ConnectionStatus.errorWrongPassword:
          _errorPassword = localizedStrings.login_error_incorrect_password;
          break;
        case ConnectionStatus.errorUserDisabled:
          _errorIdentifier = localizedStrings.login_error_disabled_email;
          break;
      }
    });
  }
}
