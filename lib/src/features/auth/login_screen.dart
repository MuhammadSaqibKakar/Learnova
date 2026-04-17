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
  final FocusNode _identifierFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordHidden = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  int _dinoTrigger = 0;
  int _dinoGuideStep = 0;

  @override
  void initState() {
    super.initState();
    _identifierController.text = widget.initialIdentifier;
    _passwordController.text = widget.initialPassword;
    _rememberMe = widget.initialRememberMe;
    _identifierFocusNode.addListener(_handleFieldFocus);
    _passwordFocusNode.addListener(_handleFieldFocus);
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
    _identifierFocusNode.removeListener(_handleFieldFocus);
    _passwordFocusNode.removeListener(_handleFieldFocus);
    _identifierFocusNode.dispose();
    _passwordFocusNode.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleFieldFocus() {
    if (!mounted) {
      return;
    }
    if (_identifierFocusNode.hasFocus || _passwordFocusNode.hasFocus) {
      setState(() {
        _dinoTrigger += 1;
        if (_identifierFocusNode.hasFocus) {
          _dinoGuideStep = 1;
        } else if (_passwordFocusNode.hasFocus) {
          _dinoGuideStep = 2;
        } else {
          _dinoGuideStep = 0;
        }
      });
    }
  }

  String get _dinoMessage {
    if (_isLoading) {
      return 'Checking login... Dino is helping!';
    }
    if (_identifierController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty) {
      return 'Great! Tap Login to start your learning adventure.';
    }
    return switch (_dinoGuideStep) {
      1 => 'Step 1: Enter email or your kid username.',
      2 => 'Step 2: Enter password and tap Login.',
      _ => 'Hi! I am Dino. I will guide you step by step.',
    };
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
    final String? errorMessage = await widget.onLogin(
      context,
      identifier,
      password,
    );

    if (!mounted) {
      return;
    }

    if (errorMessage != null) {
      _showMessage(context, errorMessage, color: _palette(context).error);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    await widget.onRememberMeChanged(_rememberMe, identifier, password);
    if (!mounted) {
      return;
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
      showDino: true,
      dinoMessage: _dinoMessage,
      dinoTrigger: _dinoTrigger,
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
              focusNode: _identifierFocusNode,
              onChanged: (_) {
                setState(() {});
              },
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
              focusNode: _passwordFocusNode,
              onChanged: (_) {
                setState(() {});
              },
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
