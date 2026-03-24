import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LearnovaApp());
}

enum UserRole { admin, parent, kid }

class LoginIdentity {
  const LoginIdentity({required this.role, this.child});

  final UserRole role;
  final ChildAccount? child;
}

class ChildAccount {
  const ChildAccount({
    required this.id,
    required this.nickname,
    required this.username,
    required this.password,
    required this.level,
  });

  final String id;
  final String nickname;
  final String username;
  final String password;
  final String level;
}

typedef NavigationHandler = void Function(BuildContext context);
typedef LoginHandler =
    String? Function(BuildContext context, String identifier, String password);
typedef ResetPasswordHandler =
    String? Function(String email, String newPassword);
typedef RememberMeHandler =
    Future<void> Function(bool rememberMe, String identifier);

class LearnovaApp extends StatefulWidget {
  const LearnovaApp({super.key});

  @override
  State<LearnovaApp> createState() => _LearnovaAppState();
}

class _LearnovaAppState extends State<LearnovaApp> {
  static const String _defaultPassword = 'Learnova@123';
  static const String _rememberMeKey = 'learnova.remember_me';
  static const String _rememberedIdentifierKey =
      'learnova.remembered_identifier';

  final Random _random = Random();
  bool _showSplash = true;
  bool _rememberMe = false;
  String _rememberedIdentifier = '';

  final String _adminEmail = 'admin@learnova.com';
  String _adminPassword = _defaultPassword;
  String _parentEmail = 'parent@learnova.com';
  String _parentPassword = _defaultPassword;

  final List<ChildAccount> _children = <ChildAccount>[
    const ChildAccount(
      id: 'seed-child-1',
      nickname: 'Spark',
      username: 'sparkkid',
      password: _defaultPassword,
      level: 'Level 1 - Starter',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    await Future.wait(<Future<void>>[
      _loadRememberMe(),
      Future<void>.delayed(const Duration(milliseconds: 2300)),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _showSplash = false;
    });
  }

  Future<void> _loadRememberMe() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      final String savedIdentifier =
          prefs.getString(_rememberedIdentifierKey) ?? '';

      if (!mounted) {
        return;
      }

      setState(() {
        _rememberMe = rememberMe;
        _rememberedIdentifier = rememberMe ? savedIdentifier : '';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _rememberMe = false;
        _rememberedIdentifier = '';
      });
    }
  }

  ThemeData _buildTheme() {
    final ThemeData baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD72638),
        primary: const Color(0xFF0E2A56),
        secondary: const Color(0xFFE63F4C),
        surface: Colors.white,
      ),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF3F7FF),
      textTheme: GoogleFonts.nunitoTextTheme(baseTheme.textTheme),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCFDBF5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCFDBF5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0E2A56), width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E2A56),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withValues(alpha: 0.92),
        foregroundColor: const Color(0xFF0E2A56),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 24,
          color: const Color(0xFF0E2A56),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return LoginScreen(
      initialIdentifier: _rememberedIdentifier,
      initialRememberMe: _rememberMe,
      onLogin: _handleLogin,
      onRememberMeChanged: _handleRememberMeChanged,
      onCreateAccount: _openRegisterScreen,
      onForgotPassword: _openForgotPasswordScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learnova',
      theme: _buildTheme(),
      home: _showSplash ? const LearnovaSplashScreen() : _buildLoginScreen(),
    );
  }

  LoginIdentity? _authenticate(String identifier, String password) {
    final String normalizedInput = identifier.trim().toLowerCase();

    if (normalizedInput == _adminEmail.toLowerCase() &&
        password == _adminPassword) {
      return const LoginIdentity(role: UserRole.admin);
    }

    if (normalizedInput == _parentEmail.toLowerCase() &&
        password == _parentPassword) {
      return const LoginIdentity(role: UserRole.parent);
    }

    for (final ChildAccount child in _children) {
      if (child.username.toLowerCase() == normalizedInput &&
          child.password == password) {
        return LoginIdentity(role: UserRole.kid, child: child);
      }
    }

    return null;
  }

  String? _handleLogin(
    BuildContext context,
    String identifier,
    String password,
  ) {
    final LoginIdentity? identity = _authenticate(identifier, password);
    if (identity == null) {
      return 'Invalid credentials. Check your email/username and password.';
    }

    _openDashboard(context, identity);
    return null;
  }

  Future<void> _handleRememberMeChanged(
    bool rememberMe,
    String identifier,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe && identifier.isNotEmpty) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_rememberedIdentifierKey, identifier);
    } else {
      await prefs.setBool(_rememberMeKey, false);
      await prefs.remove(_rememberedIdentifierKey);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _rememberMe = rememberMe && identifier.isNotEmpty;
      _rememberedIdentifier = rememberMe ? identifier : '';
    });
  }

  void _openRegisterScreen(BuildContext context) {
    Navigator.of(context).push(
      _buildRoute(
        RegisterScreen(
          random: _random,
          onRegisterParent: _registerParentAccount,
          onGoToLogin: _goToLogin,
        ),
      ),
    );
  }

  void _openForgotPasswordScreen(BuildContext context) {
    Navigator.of(context).push(
      _buildRoute(
        ForgotPasswordScreen(
          random: _random,
          onResetPassword: _resetPassword,
          onGoToLogin: _goToLogin,
        ),
      ),
    );
  }

  void _openDashboard(BuildContext context, LoginIdentity identity) {
    late final Widget screen;
    switch (identity.role) {
      case UserRole.admin:
        screen = AdminDashboardScreen(
          adminEmail: _adminEmail,
          onExit: _goToLogin,
        );
      case UserRole.parent:
        screen = ParentDashboardScreen(
          parentEmail: _parentEmail,
          initialChildren: List<ChildAccount>.from(_children),
          onChildAdded: _addChild,
          onChildUpdated: _updateChild,
          onChildDeleted: _removeChild,
          onExit: _goToLogin,
        );
      case UserRole.kid:
        screen = KidDashboardScreen(
          childName: identity.child?.nickname ?? 'Little Learner',
          level: identity.child?.level ?? 'Level 1 - Starter',
          onExit: _goToLogin,
        );
    }

    Navigator.of(context).pushReplacement(_buildRoute(screen));
  }

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      _buildRoute(_buildLoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _registerParentAccount(String email, String password) {
    setState(() {
      _parentEmail = email.trim();
      _parentPassword = password;
    });
  }

  String? _resetPassword(String email, String newPassword) {
    final String normalizedEmail = email.trim().toLowerCase();
    bool changed = false;

    setState(() {
      if (normalizedEmail == _parentEmail.toLowerCase()) {
        _parentPassword = newPassword;
        changed = true;
      } else if (normalizedEmail == _adminEmail.toLowerCase()) {
        _adminPassword = newPassword;
        changed = true;
      }
    });

    return changed
        ? null
        : 'Email not found. Use $_parentEmail or $_adminEmail for this demo.';
  }

  void _addChild(ChildAccount child) {
    setState(() {
      _children.add(child);
    });
  }

  void _updateChild(ChildAccount child) {
    setState(() {
      final int index = _children.indexWhere(
        (ChildAccount item) => item.id == child.id,
      );
      if (index != -1) {
        _children[index] = child;
      }
    });
  }

  void _removeChild(String id) {
    setState(() {
      _children.removeWhere((ChildAccount child) => child.id == id);
    });
  }

  PageRouteBuilder<void> _buildRoute(Widget child) {
    return PageRouteBuilder<void>(
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return child;
          },
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget pageChild,
          ) {
            final CurvedAnimation curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: pageChild,
              ),
            );
          },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.initialIdentifier,
    required this.initialRememberMe,
    required this.onLogin,
    required this.onRememberMeChanged,
    required this.onCreateAccount,
    required this.onForgotPassword,
    super.key,
  });

  final String initialIdentifier;
  final bool initialRememberMe;
  final LoginHandler onLogin;
  final RememberMeHandler onRememberMeChanged;
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
    _rememberMe = widget.initialRememberMe;
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIdentifier != widget.initialIdentifier &&
        _identifierController.text.isEmpty) {
      _identifierController.text = widget.initialIdentifier;
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
    await widget.onRememberMeChanged(_rememberMe, identifier);
    if (!mounted) {
      return;
    }

    final String? errorMessage = widget.onLogin(
      context,
      identifier,
      _passwordController.text.trim(),
    );

    if (errorMessage != null) {
      _showMessage(context, errorMessage, color: const Color(0xFFE63F4C));
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
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Login Info',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E2A56),
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
                const Text(
                  'Remember me',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E2A56),
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required this.random,
    required this.onRegisterParent,
    required this.onGoToLogin,
    super.key,
  });

  final Random random;
  final void Function(String email, String password) onRegisterParent;
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
        color: const Color(0xFFE63F4C),
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
      color: const Color(0xFF0E2A56),
    );
  }

  void _verifyOtp() {
    if (!_otpSent || _generatedOtp == null) {
      _showMessage(context, 'Send OTP first.', color: const Color(0xFFE63F4C));
      return;
    }

    if (_otpController.text.trim() == _generatedOtp) {
      setState(() {
        _emailVerified = true;
      });
      _showMessage(
        context,
        'Email verified successfully.',
        color: const Color(0xFF1D8F55),
      );
    } else {
      _showMessage(
        context,
        'Invalid OTP code.',
        color: const Color(0xFFE63F4C),
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
        color: const Color(0xFFE63F4C),
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
      color: const Color(0xFF1D8F55),
    );
    widget.onGoToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      pageTitle: 'Parent Registration',
      pageSubtitle: '',
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFF1),
                border: Border.all(color: const Color(0xFFF4B2BA)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Only Parent can register. Kid accounts are created inside the Parent dashboard.',
                style: TextStyle(
                  color: Color(0xFF8A2732),
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    required this.random,
    required this.onResetPassword,
    required this.onGoToLogin,
    super.key,
  });

  final Random random;
  final ResetPasswordHandler onResetPassword;
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
        color: const Color(0xFFE63F4C),
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
      color: const Color(0xFF0E2A56),
    );
  }

  void _verifyCode() {
    if (!_codeSent || _generatedCode == null) {
      _showMessage(
        context,
        'Send reset code first.',
        color: const Color(0xFFE63F4C),
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
        color: const Color(0xFF1D8F55),
      );
    } else {
      _showMessage(context, 'Incorrect code.', color: const Color(0xFFE63F4C));
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
        color: const Color(0xFFE63F4C),
      );
      return;
    }

    final String? error = widget.onResetPassword(
      _emailController.text.trim(),
      _newPasswordController.text.trim(),
    );

    if (error != null) {
      _showMessage(context, error, color: const Color(0xFFE63F4C));
      return;
    }

    _showMessage(
      context,
      'Password updated successfully. Login now.',
      color: const Color(0xFF1D8F55),
    );
    widget.onGoToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      pageTitle: 'Forgot Password',
      pageSubtitle: 'Receive a code by email and create a new secure password.',
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

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({
    required this.parentEmail,
    required this.initialChildren,
    required this.onChildAdded,
    required this.onChildUpdated,
    required this.onChildDeleted,
    required this.onExit,
    super.key,
  });

  final String parentEmail;
  final List<ChildAccount> initialChildren;
  final void Function(ChildAccount child) onChildAdded;
  final void Function(ChildAccount child) onChildUpdated;
  final void Function(String childId) onChildDeleted;
  final NavigationHandler onExit;

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  static const List<String> _levels = <String>[
    'Level 1 - Starter',
    'Level 2 - Explorer',
    'Level 3 - Builder',
    'Level 4 - Challenger',
    'Level 5 - Achiever',
    'Level 6 - Champion',
    'Level 7 - Genius',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late List<ChildAccount> _children;
  bool _isPasswordHidden = true;
  String _selectedLevel = _levels.first;
  String? _editingChildId;

  @override
  void initState() {
    super.initState();
    _children = List<ChildAccount>.from(widget.initialChildren);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _usernameExists(String username, {String? excludingId}) {
    final String normalized = username.trim().toLowerCase();
    return _children.any(
      (ChildAccount child) =>
          child.username.toLowerCase() == normalized && child.id != excludingId,
    );
  }

  void _saveChild() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ChildAccount child = ChildAccount(
      id: _editingChildId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      nickname: _nicknameController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      level: _selectedLevel,
    );

    if (_editingChildId == null) {
      setState(() {
        _children.insert(0, child);
      });
      widget.onChildAdded(child);
      _showMessage(
        context,
        'Child account created.',
        color: const Color(0xFF1D8F55),
      );
    } else {
      setState(() {
        final int index = _children.indexWhere(
          (ChildAccount item) => item.id == _editingChildId,
        );
        if (index != -1) {
          _children[index] = child;
        }
      });
      widget.onChildUpdated(child);
      _showMessage(
        context,
        'Child account updated.',
        color: const Color(0xFF1D8F55),
      );
    }

    _resetForm();
  }

  void _editChild(ChildAccount child) {
    setState(() {
      _editingChildId = child.id;
      _nicknameController.text = child.nickname;
      _usernameController.text = child.username;
      _passwordController.text = child.password;
      _selectedLevel = child.level;
    });
  }

  void _deleteChild(ChildAccount child) {
    final bool wasEditing = _editingChildId == child.id;
    setState(() {
      _children.removeWhere((ChildAccount item) => item.id == child.id);
      if (wasEditing) {
        _editingChildId = null;
        _selectedLevel = _levels.first;
      }
    });

    if (wasEditing) {
      _nicknameController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _formKey.currentState?.reset();
    }

    widget.onChildDeleted(child.id);
    _showMessage(context, 'Child removed.', color: const Color(0xFFE63F4C));
  }

  void _resetForm() {
    setState(() {
      _editingChildId = null;
      _selectedLevel = _levels.first;
    });

    _nicknameController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      roleTitle: 'Parent Dashboard',
      roleSubtitle: 'Manage student accounts and learning levels.',
      onExit: widget.onExit,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth > 1280
              ? 1180
              : constraints.maxWidth;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 100),
                      child: _DashboardInfoCard(
                        icon: Icons.family_restroom,
                        title: 'Parent Account',
                        message:
                            'Logged in as ${widget.parentEmail}. Create kid accounts with username + password and assign a level.',
                      ),
                    ),
                    const SizedBox(height: 14),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 200),
                      child: _buildCreateChildCard(),
                    ),
                    const SizedBox(height: 14),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 300),
                      child: _buildChildrenListCard(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateChildCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _editingChildId == null ? 'Create Student' : 'Update Student',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 19,
                color: Color(0xFF0E2A56),
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool splitFields = constraints.maxWidth > 700;
                if (!splitFields) {
                  final List<Widget> fields = _buildFormFields();
                  return Column(
                    children: <Widget>[
                      for (int i = 0; i < fields.length; i++) ...<Widget>[
                        fields[i],
                        if (i != fields.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                  );
                }

                final List<Widget> fields = _buildFormFields();
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fields.map((Widget widget) {
                    return SizedBox(
                      width: (constraints.maxWidth - 12) / 2,
                      child: widget,
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveChild,
                    icon: Icon(
                      _editingChildId == null ? Icons.add : Icons.save,
                    ),
                    label: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.35),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                      child: Text(
                        _editingChildId == null ? 'Add Child' : 'Save Changes',
                        key: ValueKey<String>(
                          _editingChildId == null ? 'add' : 'save',
                        ),
                      ),
                    ),
                  ),
                ),
                if (_editingChildId != null) ...<Widget>[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      child: const Text('Cancel Edit'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return <Widget>[
      TextFormField(
        controller: _nicknameController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Nick Name',
          hintText: 'e.g. Spark',
        ),
        validator: (String? value) {
          if ((value ?? '').trim().isEmpty) {
            return 'Enter nick name.';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _usernameController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'User Name',
          hintText: 'Kid login username',
        ),
        validator: (String? value) {
          final String username = (value ?? '').trim();
          if (!RegExp(r'^[a-zA-Z0-9_]{4,20}$').hasMatch(username)) {
            return 'Use 4-20 letters, numbers, underscores.';
          }
          if (_usernameExists(username, excludingId: _editingChildId)) {
            return 'Username already exists.';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _passwordController,
        obscureText: _isPasswordHidden,
        textInputAction: TextInputAction.next,
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
        validator: _validateStrongPassword,
      ),
      DropdownButtonFormField<String>(
        initialValue: _selectedLevel,
        decoration: const InputDecoration(labelText: 'Child Level'),
        items: _levels.map((String level) {
          return DropdownMenuItem<String>(value: level, child: Text(level));
        }).toList(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              _selectedLevel = value;
            });
          }
        },
      ),
    ];
  }

  Widget _buildChildrenListCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Child Accounts',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19,
              color: Color(0xFF0E2A56),
            ),
          ),
          const SizedBox(height: 12),
          if (_children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No child accounts yet. Add your first student above.',
              ),
            ),
          if (_children.isNotEmpty)
            ...List<Widget>.generate(_children.length, (int index) {
              final ChildAccount child = _children[index];
              return SlideFadeIn(
                delay: Duration(milliseconds: 70 * (index % 5)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD6E1F8)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: const Color(0xFF0E2A56),
                        foregroundColor: Colors.white,
                        child: Text(
                          child.nickname.substring(0, 1).toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              child.nickname,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0E2A56),
                              ),
                            ),
                            Text('Username: ${child.username}'),
                            Text('Level: ${child.level}'),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () => _editChild(child),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () => _deleteChild(child),
                        color: const Color(0xFFE63F4C),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({
    required this.adminEmail,
    required this.onExit,
    super.key,
  });

  final String adminEmail;
  final NavigationHandler onExit;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      roleTitle: 'Admin Dashboard',
      roleSubtitle: 'System controls and reports will be added here.',
      onExit: onExit,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SlideFadeIn(
            child: _DashboardInfoCard(
              icon: Icons.admin_panel_settings,
              title: 'Admin Space',
              message:
                  'Logged in as $adminEmail.\nThis dashboard is intentionally simple for now and ready for future features.',
            ),
          ),
        ),
      ),
    );
  }
}

class KidDashboardScreen extends StatelessWidget {
  const KidDashboardScreen({
    required this.childName,
    required this.level,
    required this.onExit,
    super.key,
  });

  final String childName;
  final String level;
  final NavigationHandler onExit;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      roleTitle: 'Kid Dashboard',
      roleSubtitle: 'Fun learning modules will appear here soon.',
      onExit: onExit,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SlideFadeIn(
            child: _DashboardInfoCard(
              icon: Icons.auto_stories,
              title: 'Hi $childName!',
              message:
                  'You are in $level.\nYour adventures, games, and lessons will be added in the next phase.',
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    required this.roleTitle,
    required this.roleSubtitle,
    required this.onExit,
    required this.body,
    super.key,
  });

  final String roleTitle;
  final String roleSubtitle;
  final NavigationHandler onExit;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wideLayout = constraints.maxWidth >= 980;

        if (!wideLayout) {
          return Scaffold(
            appBar: AppBar(title: Text(roleTitle)),
            drawer: Drawer(
              child: _DashboardMenu(
                roleTitle: roleTitle,
                onExit: onExit,
                inDrawer: true,
              ),
            ),
            body: Column(
              children: <Widget>[
                _DashboardHeader(
                  title: roleTitle,
                  subtitle: roleSubtitle,
                  showTitle: false,
                ),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: <Widget>[
              SizedBox(
                width: 270,
                child: _DashboardMenu(roleTitle: roleTitle, onExit: onExit),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _DashboardHeader(title: roleTitle, subtitle: roleSubtitle),
                    Expanded(child: body),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.title,
    required this.subtitle,
    this.showTitle = true,
  });

  final String title;
  final String subtitle;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFE8F0FF), Color(0xFFF8FAFF)],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFCCD9F5).withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showTitle)
            Text(
              title,
              style: GoogleFonts.fredoka(
                fontSize: 26,
                color: const Color(0xFF0E2A56),
                fontWeight: FontWeight.w600,
              ),
            ),
          if (showTitle) const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Color(0xFF355D8C)),
          ),
        ],
      ),
    );
  }
}

class _DashboardMenu extends StatelessWidget {
  const _DashboardMenu({
    required this.roleTitle,
    required this.onExit,
    this.inDrawer = false,
  });

  final String roleTitle;
  final NavigationHandler onExit;
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0E2A56),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: <Widget>[
                  const LearnovaLogo(size: 44),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Learnova',
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0x445F7FB4), height: 1),
            _MenuTile(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              subtitle: roleTitle,
              onTap: () {
                if (inDrawer) {
                  Navigator.of(context).pop();
                }
              },
            ),
            _MenuTile(
              icon: Icons.menu_book_outlined,
              title: 'Menu',
              subtitle: 'More options soon',
              onTap: () {
                _showMessage(
                  context,
                  'Menu placeholder: more options will be added.',
                  color: const Color(0xFF0E2A56),
                );
                if (inDrawer) {
                  Navigator.of(context).pop();
                }
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE63F4C),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (inDrawer) {
                    Navigator.of(context).pop();
                  }
                  onExit(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Exit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.white.withValues(alpha: 0.08),
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Color(0xFFD2DEF5)),
          ),
        ),
      ),
    );
  }
}

class _DashboardInfoCard extends StatelessWidget {
  const _DashboardInfoCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0E2A56), size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF0E2A56),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF355D8C),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearnovaSplashScreen extends StatefulWidget {
  const LearnovaSplashScreen({super.key});

  @override
  State<LearnovaSplashScreen> createState() => _LearnovaSplashScreenState();
}

class _LearnovaSplashScreenState extends State<LearnovaSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.92,
    end: 1.06,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));

  late final Animation<double> _float = Tween<double>(
    begin: -7,
    end: 7,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const LearnovaAnimatedBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, _float.value),
                        child: Transform.scale(
                          scale: _scale.value,
                          child: child,
                        ),
                      );
                    },
                    child: const LearnovaLogo(size: 128),
                  ),
                  const SizedBox(height: 26),
                  const SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _AnimatedShimmerText(
                        text: 'Learnova',
                        fontSize: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Learning Adventures for Kids',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: const Color(0xFF2E4E79),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  const _AnimatedLoadingDots(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedShimmerText extends StatefulWidget {
  const _AnimatedShimmerText({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  State<_AnimatedShimmerText> createState() => _AnimatedShimmerTextState();
}

class _AnimatedShimmerTextState extends State<_AnimatedShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double center = _controller.value;
        final double start = (center - 0.28).clamp(0.0, 1.0);
        final double end = (center + 0.28).clamp(0.0, 1.0);

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const <Color>[
                Color(0xFF0E2A56),
                Color(0xFFD72638),
                Color(0xFF0E2A56),
              ],
              stops: <double>[start, center, end],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.text,
        style: GoogleFonts.fredoka(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0E2A56),
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _AnimatedLoadingDots extends StatefulWidget {
  const _AnimatedLoadingDots();

  @override
  State<_AnimatedLoadingDots> createState() => _AnimatedLoadingDotsState();
}

class _AnimatedLoadingDotsState extends State<_AnimatedLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final int dotCount = ((_controller.value * 3).floor() % 3) + 1;
        final String dots = '.' * dotCount;
        return Text(
          'Loading$dots',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF355D8C),
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }
}

class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.pageTitle,
    required this.pageSubtitle,
    required this.formChild,
    super.key,
  });

  final String pageTitle;
  final String pageSubtitle;
  final Widget formChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const LearnovaAnimatedBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool wideLayout = constraints.maxWidth >= 1000;
                final EdgeInsets pagePadding = EdgeInsets.symmetric(
                  horizontal: wideLayout ? 30 : 14,
                  vertical: 14,
                );

                if (wideLayout) {
                  return Padding(
                    padding: pagePadding,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: const SlideFadeIn(
                                delay: Duration(milliseconds: 120),
                                child: _HeroSection(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: SlideFadeIn(
                                delay: const Duration(milliseconds: 220),
                                child: _AuthCard(
                                  pageTitle: pageTitle,
                                  pageSubtitle: pageSubtitle,
                                  child: formChild,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: pagePadding,
                  child: Column(
                    children: <Widget>[
                      const SlideFadeIn(
                        delay: Duration(milliseconds: 80),
                        child: _HeroSection(compact: true),
                      ),
                      const SizedBox(height: 14),
                      SlideFadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: _AuthCard(
                          pageTitle: pageTitle,
                          pageSubtitle: pageSubtitle,
                          child: formChild,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const LearnovaLogo(size: 82),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: GoogleFonts.fredoka(
                fontSize: compact ? 34 : 56,
                height: 1.05,
                color: const Color(0xFF0E2A56),
                fontWeight: FontWeight.w600,
              ),
              children: const <TextSpan>[
                TextSpan(text: 'Discover '),
                TextSpan(
                  text: 'Learnova Academy',
                  style: TextStyle(color: Color(0xFFD72638)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'A joyful learning world for ages 4 to 10. Safe, guided, and level-based learning for every child.',
            style: TextStyle(
              fontSize: 19,
              color: Color(0xFF2E4E79),
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.pageTitle,
    required this.pageSubtitle,
    required this.child,
  });

  final String pageTitle;
  final String pageSubtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool hasSubtitle = pageSubtitle.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            pageTitle,
            style: GoogleFonts.fredoka(
              fontSize: 29,
              color: const Color(0xFF0E2A56),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasSubtitle) const SizedBox(height: 6),
          if (hasSubtitle)
            Text(
              pageSubtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF395B88),
                height: 1.4,
              ),
            ),
          SizedBox(height: hasSubtitle ? 16 : 10),
          child,
        ],
      ),
    );
  }
}

class LearnovaLogo extends StatelessWidget {
  const LearnovaLogo({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF0E2A56),
            Color(0xFF1A4C8E),
            Color(0xFFD72638),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x553B63A5),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: size * 0.52,
          ),
          Positioned(
            right: size * 0.16,
            top: size * 0.12,
            child: Icon(
              Icons.star_rounded,
              color: const Color(0xFFFFD45B),
              size: size * 0.24,
            ),
          ),
        ],
      ),
    );
  }
}

class LearnovaAnimatedBackground extends StatelessWidget {
  const LearnovaAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFFEAF2FF),
            Color(0xFFF7FAFF),
            Color(0xFFF3F7FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Stack(
        children: <Widget>[
          _FloatingBubble(
            alignment: Alignment(-0.9, -0.65),
            size: 220,
            color: Color(0x339CC0FF),
            periodInMs: 3500,
          ),
          _FloatingBubble(
            alignment: Alignment(0.88, -0.82),
            size: 170,
            color: Color(0x33FFB0B8),
            periodInMs: 2900,
          ),
          _FloatingBubble(
            alignment: Alignment(-0.76, 0.82),
            size: 180,
            color: Color(0x3368D6C4),
            periodInMs: 3200,
          ),
          _FloatingBubble(
            alignment: Alignment(0.88, 0.72),
            size: 200,
            color: Color(0x33FFC56A),
            periodInMs: 3800,
          ),
        ],
      ),
    );
  }
}

class _FloatingBubble extends StatefulWidget {
  const _FloatingBubble({
    required this.alignment,
    required this.size,
    required this.color,
    required this.periodInMs,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final int periodInMs;

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.periodInMs),
  )..repeat(reverse: true);

  late final Animation<double> _wave = Tween<double>(
    begin: -8,
    end: 8,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: AnimatedBuilder(
        animation: _wave,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, _wave.value),
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class SlideFadeIn extends StatelessWidget {
  const SlideFadeIn({
    required this.child,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 550 + delay.inMilliseconds),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? animatedChild) {
        final double scale = 0.96 + (0.04 * value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: Transform.scale(scale: scale, child: animatedChild),
          ),
        );
      },
      child: child,
    );
  }
}

bool _isValidEmail(String value) {
  return RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$').hasMatch(value);
}

String? _validateStrongPassword(String? value) {
  final String password = (value ?? '').trim();
  final RegExp pattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-]).{8,}$',
  );

  if (password.isEmpty) {
    return 'Enter password.';
  }
  if (!pattern.hasMatch(password)) {
    return 'Use 8+ chars with upper, lower, number, and symbol.';
  }
  return null;
}

void _showMessage(BuildContext context, String text, {required Color color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Text(text),
    ),
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFD3DFF7)),
    boxShadow: const <BoxShadow>[
      BoxShadow(color: Color(0x16396BB0), blurRadius: 18, offset: Offset(0, 9)),
    ],
  );
}
