part of 'package:learnova/main.dart';

class LearnovaApp extends StatefulWidget {
  const LearnovaApp({super.key});

  @override
  State<LearnovaApp> createState() => _LearnovaAppState();
}

class _LearnovaAppState extends State<LearnovaApp> {
  static const String _defaultPassword = 'Learnova@123';
  static const String _defaultAdminEmail = 'admin@learnova.com';
  static const String _rememberMeKey = 'learnova.remember_me';
  static const String _rememberedIdentifierKey =
      'learnova.remembered_identifier';
  // Kept to clear legacy persisted passwords from previous app states.
  static const String _rememberedPasswordKey = 'learnova.remembered_password';
  static const String _visualStyleKey = 'learnova.visual_style';
  static const String _adminEmailStorageKey = 'learnova.app.admin_email';
  static const String _adminPasswordStorageKey = 'learnova.app.admin_password';
  static const String _parentsStorageKey = 'learnova.app.parents';
  static const String _childrenStorageKey = 'learnova.app.children';
  static const int _maxFailedLoginAttempts = 5;
  static const Duration _loginLockDuration = Duration(seconds: 30);
  static const List<ParentAccount> _seedParents = <ParentAccount>[
    ParentAccount(
      id: 'seed-parent-1',
      email: 'parent@learnova.com',
      password: _defaultPassword,
      createdAtEpoch: 1735689600000,
    ),
  ];
  static const List<ChildAccount> _seedChildren = <ChildAccount>[
    ChildAccount(
      id: 'seed-child-1',
      nickname: 'Spark',
      username: 'sparkkid',
      password: _defaultPassword,
      level: 'Level 1 - Starter',
      createdAtEpoch: 1735689600000,
    ),
    ChildAccount(
      id: 'seed-child-2',
      nickname: 'Nova',
      username: 'novakid',
      password: _defaultPassword,
      level: 'Level 2 - Explorer',
      createdAtEpoch: 1735776000000,
    ),
  ];

  final Random _random = Random();
  bool _showSplash = true;
  bool _rememberMe = false;
  String _rememberedIdentifier = '';
  String _rememberedPassword = '';
  LearnovaVisualStyle _visualStyle = LearnovaVisualStyle.greenSpark;
  int _failedLoginAttempts = 0;
  DateTime? _loginLockedUntilUtc;

  String _adminEmail = _defaultAdminEmail;
  String _adminPassword = _defaultPassword;
  final List<ParentAccount> _parents = List<ParentAccount>.from(_seedParents);
  final List<ChildAccount> _children = List<ChildAccount>.from(_seedChildren);

  ParentAccount get _primaryParent => _parents.first;

  @override
  void initState() {
    super.initState();
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    await Future.wait(<Future<void>>[
      _loadRememberMe(),
      _loadPersistedAppData(),
      Future<void>.delayed(const Duration(milliseconds: 3400)),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _showSplash = false;
    });
  }

  Future<void> _loadPersistedAppData() async {
    try {
      final SharedPreferences prefs = await _sharedPrefs(syncFirst: true);
      final String storedAdminEmail =
          prefs.getString(_adminEmailStorageKey) ?? _defaultAdminEmail;
      final String storedAdminPassword =
          prefs.getString(_adminPasswordStorageKey) ?? _defaultPassword;
      final List<ParentAccount> storedParents = _decodeParentAccounts(
        prefs.getStringList(_parentsStorageKey),
      );
      final List<ChildAccount> storedChildren = _decodeChildAccounts(
        prefs.getStringList(_childrenStorageKey),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _adminEmail = storedAdminEmail.trim().isEmpty
            ? _defaultAdminEmail
            : storedAdminEmail.trim();
        _adminPassword = storedAdminPassword.isEmpty
            ? _defaultPassword
            : storedAdminPassword;
        _parents
          ..clear()
          ..addAll(storedParents.isEmpty ? _seedParents : storedParents);
        _children
          ..clear()
          ..addAll(storedChildren.isEmpty ? _seedChildren : storedChildren);
      });
    } catch (_) {}
  }

  List<ParentAccount> _decodeParentAccounts(List<String>? rawValues) {
    if (rawValues == null || rawValues.isEmpty) {
      return const <ParentAccount>[];
    }
    final List<ParentAccount> parents = <ParentAccount>[];
    for (final String rawValue in rawValues) {
      try {
        final dynamic decoded = jsonDecode(rawValue);
        if (decoded is! Map<String, dynamic>) {
          continue;
        }
        final ParentAccount parent = ParentAccount.fromMap(decoded);
        if (parent.id.isEmpty ||
            parent.email.isEmpty ||
            parent.password.isEmpty) {
          continue;
        }
        parents.add(parent);
      } catch (_) {
        continue;
      }
    }
    return parents;
  }

  List<ChildAccount> _decodeChildAccounts(List<String>? rawValues) {
    if (rawValues == null || rawValues.isEmpty) {
      return const <ChildAccount>[];
    }
    final List<ChildAccount> children = <ChildAccount>[];
    for (final String rawValue in rawValues) {
      try {
        final dynamic decoded = jsonDecode(rawValue);
        if (decoded is! Map<String, dynamic>) {
          continue;
        }
        final ChildAccount child = ChildAccount.fromMap(decoded);
        if (child.id.isEmpty ||
            child.nickname.isEmpty ||
            child.username.isEmpty ||
            child.password.isEmpty) {
          continue;
        }
        children.add(child);
      } catch (_) {
        continue;
      }
    }
    return children;
  }

  Future<void> _persistAppData() async {
    try {
      final SharedPreferences prefs = await _sharedPrefs();
      await prefs.setString(_adminEmailStorageKey, _adminEmail);
      await prefs.setString(_adminPasswordStorageKey, _adminPassword);
      await prefs.setStringList(
        _parentsStorageKey,
        _parents
            .map((ParentAccount parent) => jsonEncode(parent.toMap()))
            .toList(),
      );
      await prefs.setStringList(
        _childrenStorageKey,
        _children
            .map((ChildAccount child) => jsonEncode(child.toMap()))
            .toList(),
      );
      await _syncSharedKeysToRemote(prefs, <String>[
        _adminEmailStorageKey,
        _adminPasswordStorageKey,
        _parentsStorageKey,
        _childrenStorageKey,
      ]);
    } catch (_) {}
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

    for (final ParentAccount parent in _parents) {
      if (normalizedInput == parent.email.toLowerCase() &&
          password == parent.password) {
        return LoginIdentity(role: UserRole.parent, parentEmail: parent.email);
      }
    }

    for (final ChildAccount child in _children) {
      if (child.username.toLowerCase() == normalizedInput &&
          child.password == password) {
        return LoginIdentity(role: UserRole.kid, child: child);
      }
    }

    return null;
  }

  Future<String?> _handleLogin(
    BuildContext context,
    String identifier,
    String password,
  ) async {
    final DateTime nowUtc = DateTime.now().toUtc();
    final DateTime? lockUntil = _loginLockedUntilUtc;
    if (lockUntil != null && nowUtc.isBefore(lockUntil)) {
      final int secondsLeft = lockUntil.difference(nowUtc).inSeconds + 1;
      return 'Too many attempts. Try again in ${secondsLeft}s.';
    }

    await _loadPersistedAppData();
    final LoginIdentity? identity = _authenticate(identifier, password);
    if (identity == null) {
      _failedLoginAttempts += 1;
      if (_failedLoginAttempts >= _maxFailedLoginAttempts) {
        _loginLockedUntilUtc = nowUtc.add(_loginLockDuration);
        _failedLoginAttempts = 0;
      }
      return 'Invalid credentials. Check your email/username and password.';
    }

    _failedLoginAttempts = 0;
    _loginLockedUntilUtc = null;
    if (!context.mounted) {
      return 'Login screen is no longer active.';
    }
    _openDashboard(context, identity);
    return null;
  }

  Future<void> _handleRememberMeChanged(
    bool rememberMe,
    String identifier,
    String password,
  ) async {
    final String normalizedIdentifier = identifier.trim();
    final String normalizedPassword = password.trim();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe &&
        normalizedIdentifier.isNotEmpty &&
        normalizedPassword.isNotEmpty) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_rememberedIdentifierKey, normalizedIdentifier);
      await prefs.setString(_rememberedPasswordKey, normalizedPassword);
    } else {
      await prefs.setBool(_rememberMeKey, false);
      await prefs.remove(_rememberedIdentifierKey);
      await prefs.remove(_rememberedPasswordKey);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _rememberMe =
          rememberMe &&
          normalizedIdentifier.isNotEmpty &&
          normalizedPassword.isNotEmpty;
      _rememberedIdentifier = _rememberMe ? normalizedIdentifier : '';
      _rememberedPassword = _rememberMe ? normalizedPassword : '';
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
          adminPassword: _adminPassword,
          parentAccounts: List<ParentAccount>.from(_parents),
          initialChildren: List<ChildAccount>.from(_children),
          onAdminCredentialsUpdated: _updateAdminCredentials,
          onParentAdded: _addParentAccount,
          onParentUpdated: _updateParentAccount,
          onParentDeleted: _removeParentAccount,
          onChildAdded: _addChild,
          onChildUpdated: _updateChild,
          onChildDeleted: _removeChild,
          onResetKidProgress: _resetAllKidProgress,
          onOpenThemePicker: _openThemePicker,
          onExit: _goToLogin,
        );
      case UserRole.parent:
        screen = ParentDashboardScreen(
          parentEmail: identity.parentEmail ?? _primaryParent.email,
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
          allChildren: List<ChildAccount>.from(_children),
          onLevelAdvanced: _advanceChildLevel,
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
    final String normalizedEmail = email.trim().toLowerCase();
    setState(() {
      final int existingIndex = _parents.indexWhere(
        (ParentAccount parent) => parent.email.toLowerCase() == normalizedEmail,
      );
      if (existingIndex == -1) {
        _parents.insert(
          0,
          ParentAccount(
            id: 'parent-${DateTime.now().microsecondsSinceEpoch}',
            email: email.trim(),
            password: password,
            createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      } else {
        final ParentAccount existing = _parents[existingIndex];
        _parents[existingIndex] = ParentAccount(
          id: existing.id,
          email: email.trim(),
          password: password,
          createdAtEpoch: existing.createdAtEpoch,
        );
      }
    });
    unawaited(_persistAppData());
  }

  void _updateAdminCredentials(String email, String password) {
    setState(() {
      _adminEmail = email.trim();
      _adminPassword = password;
    });
    unawaited(_persistAppData());
  }

  void _addParentAccount(ParentAccount parent) {
    setState(() {
      _parents.add(parent);
    });
    unawaited(_persistAppData());
  }

  void _updateParentAccount(ParentAccount parent) {
    setState(() {
      final int index = _parents.indexWhere(
        (ParentAccount item) => item.id == parent.id,
      );
      if (index != -1) {
        _parents[index] = parent;
      }
    });
    unawaited(_persistAppData());
  }

  bool _removeParentAccount(String id) {
    if (_parents.length <= 1) {
      return false;
    }
    setState(() {
      _parents.removeWhere((ParentAccount parent) => parent.id == id);
    });
    unawaited(_persistAppData());
    return true;
  }

  Future<int> _resetAllKidProgress() async {
    const String progressPrefix = 'learnova.kid.progress.';
    final SharedPreferences prefs = await _sharedPrefs(syncFirst: true);
    final List<String> keys = prefs
        .getKeys()
        .where((String key) => key.startsWith(progressPrefix))
        .toList();
    for (final String key in keys) {
      await prefs.remove(key);
    }
    await _syncRemovedSharedKeys(prefs, keys);
    return keys.length;
  }

  String? _resetPassword(String email, String newPassword) {
    final String normalizedEmail = email.trim().toLowerCase();
    bool changed = false;

    setState(() {
      if (normalizedEmail == _adminEmail.toLowerCase()) {
        _adminPassword = newPassword;
        changed = true;
      } else {
        final int parentIndex = _parents.indexWhere(
          (ParentAccount parent) =>
              parent.email.toLowerCase() == normalizedEmail,
        );
        if (parentIndex != -1) {
          final ParentAccount parent = _parents[parentIndex];
          _parents[parentIndex] = ParentAccount(
            id: parent.id,
            email: parent.email,
            password: newPassword,
            createdAtEpoch: parent.createdAtEpoch,
          );
          changed = true;
        }
      }
    });

    if (changed) {
      unawaited(_persistAppData());
    }

    return changed
        ? null
        : 'Email not found. Use ${_primaryParent.email} or $_adminEmail for this demo.';
  }

  void _addChild(ChildAccount child) {
    final ChildAccount normalized = child.createdAtEpoch == 0
        ? ChildAccount(
            id: child.id,
            nickname: child.nickname,
            username: child.username,
            password: child.password,
            level: child.level,
            createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
          )
        : child;
    setState(() {
      _children.add(normalized);
    });
    unawaited(_persistAppData());
  }

  void _updateChild(ChildAccount child) {
    setState(() {
      final int index = _children.indexWhere(
        (ChildAccount item) => item.id == child.id,
      );
      if (index != -1) {
        final int createdAt = _children[index].createdAtEpoch;
        _children[index] = ChildAccount(
          id: child.id,
          nickname: child.nickname,
          username: child.username,
          password: child.password,
          level: child.level,
          createdAtEpoch: child.createdAtEpoch == 0
              ? createdAt
              : child.createdAtEpoch,
        );
      }
    });
    unawaited(_persistAppData());
  }

  Future<void> _advanceChildLevel(String childId, String newLevel) async {
    final String normalizedLevel = newLevel.trim();
    if (normalizedLevel.isEmpty) {
      return;
    }

    bool changed = false;
    setState(() {
      final int index = _children.indexWhere(
        (ChildAccount item) => item.id == childId,
      );
      if (index == -1) {
        return;
      }

      final ChildAccount existing = _children[index];
      if (existing.level == normalizedLevel) {
        return;
      }

      _children[index] = ChildAccount(
        id: existing.id,
        nickname: existing.nickname,
        username: existing.username,
        password: existing.password,
        level: normalizedLevel,
        createdAtEpoch: existing.createdAtEpoch,
      );
      changed = true;
    });

    if (changed) {
      await _persistAppData();
    }
  }

  void _removeChild(String id) {
    setState(() {
      _children.removeWhere((ChildAccount child) => child.id == id);
    });
    unawaited(_persistAppData());
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
