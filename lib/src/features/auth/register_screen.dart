part of 'package:learnova/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required this.random,
    required this.onRegisterParent,
    required this.onOpenThemePicker,
    required this.onGoToLogin,
    super.key,
  });

  final Random random;
  final void Function(String email, String password) onRegisterParent;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onGoToLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _otpSent = false;
  bool _emailVerified = false;
  String? _generatedOtp;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final String email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      _showMessage(
        context,
        'Enter a valid parent email first.',
        color: _palette(context).error,
      );
      return;
    }

    final String code = (100000 + widget.random.nextInt(900000)).toString();
    setState(() {
      _generatedOtp = code;
      _otpSent = true;
      _emailVerified = false;
    });

    _showMessage(
      context,
      'OTP sent to $email. Demo OTP: $code',
      color: Theme.of(context).colorScheme.primary,
    );
  }

  void _verifyOtp() {
    if (!_otpSent || _generatedOtp == null) {
      _showMessage(context, 'Send OTP first.', color: _palette(context).error);
      return;
    }

    if (_otpController.text.trim() == _generatedOtp) {
      setState(() {
        _emailVerified = true;
      });
      _showMessage(
        context,
        'Email verified successfully.',
        color: _palette(context).success,
      );
    } else {
      _showMessage(
        context,
        'Invalid OTP code.',
        color: _palette(context).error,
      );
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_emailVerified) {
      _showMessage(
        context,
        'Verify email through OTP before registration.',
        color: _palette(context).error,
      );
      return;
    }

    widget.onRegisterParent(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    _showMessage(
      context,
      'Parent account created. Please login now.',
      color: _palette(context).success,
    );
    widget.onGoToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      pageTitle: 'Parent Registration',
      pageSubtitle: '',
      onOpenThemePicker: widget.onOpenThemePicker,
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _palette(context).noticeBackground,
                border: Border.all(color: _palette(context).noticeBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Only Parent can register. Kid accounts are created inside the Parent dashboard.',
                style: TextStyle(
                  color: _palette(context).noticeText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Parent Email',
                hintText: 'parent@example.com',
              ),
              validator: (String? value) {
                if (!_isValidEmail((value ?? '').trim())) {
                  return 'Enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sendOtp,
                    icon: const Icon(Icons.send_outlined),
                    label: Text(_otpSent ? 'Resend OTP' : 'Send OTP'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      hintText: '6-digit code',
                    ),
                    validator: (String? value) {
                      if (!_emailVerified && (value ?? '').trim().isEmpty) {
                        return 'Enter OTP';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _verifyOtp,
              icon: Icon(
                _emailVerified ? Icons.verified : Icons.shield_outlined,
              ),
              label: Text(_emailVerified ? 'Email Verified' : 'Verify OTP'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Create secure password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
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
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
                  return 'Confirm your password.';
                }
                if (value != _passwordController.text.trim()) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Register Parent Account'),
            ),
          ],
        ),
      ),
    );
  }
}
