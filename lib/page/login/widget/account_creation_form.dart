import 'package:dgo_puzzle/service/user_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountCreationForm extends StatefulWidget {
  final VoidCallback onLoginCreated;
  const AccountCreationForm({Key? key, required this.onLoginCreated}) : super(key: key);

  @override
  _AccountCreationFormState createState() => _AccountCreationFormState();
}

class _AccountCreationFormState extends State<AccountCreationForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _playerNameController;
  bool validationEnabled = false;

  String? _errorEmail;
  String? _errorPassword;
  final List<FocusNode?> _fieldFocus = [null, FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _playerNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildFields(context),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return [
      _buildField(
        name: strings.create_account_email_title,
        hint: strings.create_account_email_hint,
        controller: _emailController,
        errorText: _errorEmail,
        focus: _fieldFocus[0],
        onChanged: () {
          _errorEmail = null;
          _updateValidateButtonState();
        }
      ),
      _buildField(
        name: strings.create_account_password_title,
        hint: strings.create_account_password_hint,
        controller: _passwordController,
        errorText: _errorPassword,
        obscureText: true,
        focus: _fieldFocus[1],
        onChanged: () {
          _errorPassword = null;
          _updateValidateButtonState();
        }
      ),
      _buildField(
        name: strings.create_account_displayname_title,
        hint: strings.create_account_displayname_hint,
        controller: _playerNameController,
        focus: _fieldFocus[2],
        onChanged: _updateValidateButtonState,
      ),
      _buildValidateButton(),
    ];
  }

  Widget _buildField(
      {required String name,
        required String hint,
        String? errorText,
        required TextEditingController controller,
        bool obscureText = false,
        FocusNode? focus,
        required VoidCallback onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        focusNode: focus,
        maxLines: 1,
        autofocus: focus == null,
        onChanged: (_) => onChanged(),
        textInputAction: _fieldFocus[2] == focus ? TextInputAction.done : TextInputAction.next,
        onEditingComplete: () => findNextFocus(focus),
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: name,
            hintText: hint,
            errorText: errorText
        ),
        controller: controller,
      ),
    );
  }

  void _updateValidateButtonState() {
    setState(() {
      validationEnabled = [
        _emailController,
        _passwordController,
        _playerNameController
      ].map((controller) => controller.text.isNotEmpty).reduce((b1, b2) =>
      b1 && b2);
    });
  }

  Widget _buildValidateButton() {
    return Padding(padding: const EdgeInsets.only(top: 40),
      child: ElevatedButton(
        focusNode: _fieldFocus[3],
        child: Text(AppLocalizations.of(context)!.create_account_button),
        onPressed:validationEnabled ? createAccount : null,
      ),
    );
  }

  void findNextFocus(FocusNode? currentFocus){
    final index = _fieldFocus.indexOf(currentFocus)+1;
    if(index < _fieldFocus.length) {
      setState(() {
        _fieldFocus[index]?.requestFocus();
      });
    }
    else {
      setState(() {});
    }
  }

  Future<void> createAccount() async {
    final status = await UserLogin.of(context).createAccount(email: _emailController.text, password: _passwordController.text, playerName: _playerNameController.text);
    if(status != AccountCreationStatus.createdSuccessfully) {
      setState(() {
        final strings = AppLocalizations.of(context)!;
        switch(status) {
          case AccountCreationStatus.errorEmailAlreadyInUse:
            _errorEmail = strings.create_account_error_email_in_use;
            break;
          case AccountCreationStatus.errorInvalidEmail:
            _errorEmail = strings.create_account_error_invalid_email;
            break;
          case AccountCreationStatus.errorOperationNotAllowed:
            _errorEmail = strings.create_account_error_operation_not_allowed;
            break;
          case AccountCreationStatus.errorWeakPassword:
            _errorPassword = strings.create_account_error_weak_password;
            break;
          default:
            break;
        }
      });
    } else {
      widget.onLoginCreated();
    }
  }
}
