part of 'package:learnova/main.dart';

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
  static const String _rememberedPasswordKey = 'learnova.remembered_password';
  static const String _visualStyleKey = 'learnova.visual_style';

  final Random _random = Random();
  bool _showSplash = true;
  bool _rememberMe = false;
  String _rememberedIdentifier = '';
  String _rememberedPassword = '';
  LearnovaVisualStyle _visualStyle = LearnovaVisualStyle.greenSpark;

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
    const ChildAccount(
      id: 'seed-child-2',
      nickname: 'Nova',
      username: 'novakid',
      password: _defaultPassword,
      level: 'Level 2 - Explorer',
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
      final String savedPassword =
          prefs.getString(_rememberedPasswordKey) ?? '';
      final String storedStyle =
          prefs.getString(_visualStyleKey) ??
          LearnovaVisualStyle.greenSpark.name;
      final LearnovaVisualStyle style = LearnovaVisualStyle.values.firstWhere(
        (LearnovaVisualStyle value) => value.name == storedStyle,
        orElse: () => LearnovaVisualStyle.greenSpark,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _rememberMe = rememberMe;
        _rememberedIdentifier = rememberMe ? savedIdentifier : '';
        _rememberedPassword = rememberMe ? savedPassword : '';
        _visualStyle = style;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _rememberMe = false;
        _rememberedIdentifier = '';
        _rememberedPassword = '';
        _visualStyle = LearnovaVisualStyle.greenSpark;
      });
    }
  }

  ThemeData _buildTheme() {
    final LearnovaPalette palette = switch (_visualStyle) {
      LearnovaVisualStyle.greenSpark => _greenSparkPalette,
      LearnovaVisualStyle.light => _lightPalette,
      LearnovaVisualStyle.dark => _darkPalette,
    };
    final bool isDark = _visualStyle == LearnovaVisualStyle.dark;
    final Color inputFill = isDark
        ? const Color(0xFF17233A).withValues(alpha: 0.96)
        : Colors.white.withValues(alpha: 0.92);
    final Color hintColor = isDark
        ? palette.textSecondary.withValues(alpha: 0.76)
        : palette.textSecondary.withValues(alpha: 0.78);

    final ThemeData baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.brandPrimary,
        primary: palette.brandPrimary,
        secondary: palette.brandAccent,
        surface: isDark ? const Color(0xFF111827) : Colors.white,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: palette.surfaceSoft,
      textTheme: GoogleFonts.nunitoTextTheme(baseTheme.textTheme).apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          color: palette.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: TextStyle(
          color: palette.brandPrimary,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: TextStyle(color: hintColor),
        prefixIconColor: palette.textSecondary,
        suffixIconColor: palette.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.brandPrimary, width: 1.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.brandPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? palette.textPrimary : palette.brandPrimary,
          side: BorderSide(color: palette.borderStrong, width: 1.5),
          minimumSize: const Size(96, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark
              ? const Color(0xFFA8F56F)
              : palette.brandPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF111C31) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF0D1729).withValues(alpha: 0.97)
            : Colors.white.withValues(alpha: 0.92),
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 24,
          color: palette.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return palette.brandPrimary;
          }
          return isDark ? const Color(0xFF172036) : Colors.white;
        }),
        side: BorderSide(color: palette.borderStrong, width: 1.8),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? const Color(0xFF0E172A) : Colors.white,
        modalBackgroundColor: isDark ? const Color(0xFF0E172A) : Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      extensions: <ThemeExtension<dynamic>>[palette],
    );
  }

  Widget _buildLoginScreen() {
    return LoginScreen(
      initialIdentifier: _rememberedIdentifier,
      initialPassword: _rememberedPassword,
      initialRememberMe: _rememberMe,
      onLogin: _handleLogin,
      onRememberMeChanged: _handleRememberMeChanged,
      onOpenThemePicker: _openThemePicker,
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
    String password,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe && identifier.isNotEmpty && password.isNotEmpty) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_rememberedIdentifierKey, identifier);
      await prefs.setString(_rememberedPasswordKey, password);
    } else {
      await prefs.setBool(_rememberMeKey, false);
      await prefs.remove(_rememberedIdentifierKey);
      await prefs.remove(_rememberedPasswordKey);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _rememberMe = rememberMe && identifier.isNotEmpty && password.isNotEmpty;
      _rememberedIdentifier = rememberMe ? identifier : '';
      _rememberedPassword = rememberMe ? password : '';
    });
  }

  Future<void> _setVisualStyle(LearnovaVisualStyle style) async {
    if (_visualStyle == style) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_visualStyleKey, style.name);
    if (!mounted) {
      return;
    }
    setState(() {
      _visualStyle = style;
    });
  }

  void _openThemePicker(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: _visualStyle == LearnovaVisualStyle.dark
          ? palette.menuBackground
          : Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Choose Theme',
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _ThemeOptionTile(
                  title: 'Green Spark',
                  subtitle: 'Playful green style',
                  selected: _visualStyle == LearnovaVisualStyle.greenSpark,
                  color: _greenSparkPalette.brandPrimary,
                  onTap: () async {
                    await _setVisualStyle(LearnovaVisualStyle.greenSpark);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _ThemeOptionTile(
                  title: 'Light Theme',
                  subtitle: 'Clean classic Learnova look',
                  selected: _visualStyle == LearnovaVisualStyle.light,
                  color: _lightPalette.brandPrimary,
                  onTap: () async {
                    await _setVisualStyle(LearnovaVisualStyle.light);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _ThemeOptionTile(
                  title: 'Dark Theme',
                  subtitle: 'Low-light focus mode',
                  selected: _visualStyle == LearnovaVisualStyle.dark,
                  color: _darkPalette.brandPrimary,
                  onTap: () async {
                    await _setVisualStyle(LearnovaVisualStyle.dark);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openRegisterScreen(BuildContext context) {
    Navigator.of(context).push(
      _buildRoute(
        RegisterScreen(
          random: _random,
          onRegisterParent: _registerParentAccount,
          onOpenThemePicker: _openThemePicker,
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
          onOpenThemePicker: _openThemePicker,
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
          onOpenThemePicker: _openThemePicker,
          onExit: _goToLogin,
        );
      case UserRole.parent:
        screen = ParentDashboardScreen(
          parentEmail: _parentEmail,
          initialChildren: List<ChildAccount>.from(_children),
          onChildAdded: _addChild,
          onChildUpdated: _updateChild,
          onChildDeleted: _removeChild,
          onOpenThemePicker: _openThemePicker,
          onExit: _goToLogin,
        );
      case UserRole.kid:
        screen = KidDashboardScreen(
          childId: identity.child?.id ?? 'kid-default',
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
