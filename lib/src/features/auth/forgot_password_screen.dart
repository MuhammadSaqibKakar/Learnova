part of 'package:learnova/main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    required this.random,
    required this.onResetPassword,
    required this.onOpenThemePicker,
    required this.onGoToLogin,
    super.key,
  });

  final Random random;
  final ResetPasswordHandler onResetPassword;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onGoToLogin;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _codeSent = false;
  bool _codeVerified = false;
  String? _generatedCode;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendCode() {
    final String email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      _showMessage(
        context,
        'Enter a valid email.',
        color: _palette(context).error,
      );
      return;
    }

    final String code = (100000 + widget.random.nextInt(900000)).toString();
    setState(() {
      _generatedCode = code;
      _codeSent = true;
      _codeVerified = false;
    });

    _showMessage(
      context,
      'Reset code sent. Demo code: $code',
      color: Theme.of(context).colorScheme.primary,
    );
  }

  void _verifyCode() {
    if (!_codeSent || _generatedCode == null) {
      _showMessage(
        context,
        'Send reset code first.',
        color: _palette(context).error,
      );
      return;
    }

    if (_codeController.text.trim() == _generatedCode) {
      setState(() {
        _codeVerified = true;
      });
      _showMessage(
        context,
        'Code verified. Set your new password.',
        color: _palette(context).success,
      );
    } else {
      _showMessage(context, 'Incorrect code.', color: _palette(context).error);
    }
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_codeVerified) {
      _showMessage(
        context,
        'Verify reset code before setting new password.',
        color: _palette(context).error,
      );
      return;
    }

    final String? error = widget.onResetPassword(
      _emailController.text.trim(),
      _newPasswordController.text.trim(),
    );

    if (error != null) {
      _showMessage(context, error, color: _palette(context).error);
      return;
    }

    _showMessage(
      context,
      'Password updated successfully. Login now.',
      color: _palette(context).success,
    );
    widget.onGoToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      pageTitle: 'Forgot Password',
      pageSubtitle: 'Receive a code by email and create a new secure password.',
      onOpenThemePicker: widget.onOpenThemePicker,
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter registered email',
              ),
              validator: (String? value) {
                if (!_isValidEmail((value ?? '').trim())) {
                  return 'Enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _sendCode,
              icon: const Icon(Icons.mark_email_read_outlined),
              label: Text(_codeSent ? 'Resend Code' : 'Send Code'),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      hintText: 'Enter code',
                    ),
                    validator: (String? value) {
                      if (!_codeVerified && (value ?? '').trim().isEmpty) {
                        return 'Enter code';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _verifyCode,
                    icon: Icon(
                      _codeVerified
                          ? Icons.verified_user
                          : Icons.shield_outlined,
                    ),
                    label: Text(_codeVerified ? 'Verified' : 'Verify'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _isNewPasswordHidden,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isNewPasswordHidden = !_isNewPasswordHidden;
                    });
                  },
                  icon: Icon(
                    _isNewPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              validator: _validateStrongPassword,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _isConfirmPasswordHidden,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _resetPassword(),
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                    });
                  },
                  icon: Icon(
                    _isConfirmPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              validator: (String? value) {
                if ((value ?? '').isEmpty) {
                  return 'Confirm your new password.';
                }
                if (value != _newPasswordController.text.trim()) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Set New Password'),
            ),
          ],
        ),
      ),
    );
  }
}
