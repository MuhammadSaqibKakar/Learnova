part of 'package:learnova/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.initialIdentifier,
    required this.initialPassword,
    required this.initialRememberMe,
    required this.onLogin,
    required this.onRememberMeChanged,
    required this.onOpenThemePicker,
    required this.onCreateAccount,
    required this.onForgotPassword,
    super.key,
  });

  final String initialIdentifier;
  final String initialPassword;
  final bool initialRememberMe;
  final LoginHandler onLogin;
  final RememberMeHandler onRememberMeChanged;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onCreateAccount;
  final NavigationHandler onForgotPassword;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _identifierController.text = widget.initialIdentifier;
    _passwordController.text = widget.initialPassword;
    _rememberMe = widget.initialRememberMe;
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIdentifier != widget.initialIdentifier &&
        _identifierController.text.isEmpty) {
      _identifierController.text = widget.initialIdentifier;
    }
    if (oldWidget.initialPassword != widget.initialPassword &&
        _passwordController.text.isEmpty) {
      _passwordController.text = widget.initialPassword;
    }
    if (oldWidget.initialRememberMe != widget.initialRememberMe) {
      _rememberMe = widget.initialRememberMe;
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String identifier = _identifierController.text.trim();
    final String password = _passwordController.text.trim();
    await widget.onRememberMeChanged(_rememberMe, identifier, password);
    if (!mounted) {
      return;
    }

    final String? errorMessage = widget.onLogin(context, identifier, password);

    if (errorMessage != null) {
      _showMessage(context, errorMessage, color: _palette(context).error);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      pageTitle: 'Welcome Back',
      pageSubtitle: 'Login to continue learning with Learnova.',
      onOpenThemePicker: widget.onOpenThemePicker,
      showThemeButton: true,
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Login Info',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: _palette(context).textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _identifierController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email or Username',
                hintText: 'Kids use username set by parent',
              ),
              validator: (String? value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Enter email or username.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                _submit();
              },
              decoration: InputDecoration(
                labelText: 'Password',
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
              validator: (String? value) {
                if ((value ?? '').isEmpty) {
                  return 'Enter password.';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Remember me',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _palette(context).textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => widget.onForgotPassword(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _submit();
                    },
              child: Text(_isLoading ? 'Signing in...' : 'Login'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => widget.onCreateAccount(context),
              child: const Text('Create New Parent Account'),
            ),
          ],
        ),
      ),
    );
  }
}
