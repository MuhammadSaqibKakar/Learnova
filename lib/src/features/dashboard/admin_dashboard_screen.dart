part of 'package:learnova/main.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    required this.adminEmail,
    required this.adminPassword,
    required this.parentAccounts,
    required this.initialChildren,
    required this.onAdminCredentialsUpdated,
    required this.onParentAdded,
    required this.onParentUpdated,
    required this.onParentDeleted,
    required this.onChildAdded,
    required this.onChildUpdated,
    required this.onChildDeleted,
    required this.onResetKidProgress,
    required this.onOpenThemePicker,
    required this.onExit,
    super.key,
  });

  final String adminEmail;
  final String adminPassword;
  final List<ParentAccount> parentAccounts;
  final List<ChildAccount> initialChildren;
  final void Function(String email, String password) onAdminCredentialsUpdated;
  final void Function(ParentAccount parent) onParentAdded;
  final void Function(ParentAccount parent) onParentUpdated;
  final bool Function(String parentId) onParentDeleted;
  final void Function(ChildAccount child) onChildAdded;
  final void Function(ChildAccount child) onChildUpdated;
  final void Function(String childId) onChildDeleted;
  final Future<int> Function() onResetKidProgress;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onExit;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const List<String> _kidLevels = <String>[
    'Level 1 - Starter',
    'Level 2 - Explorer',
    'Level 3 - Builder',
    'Level 4 - Challenger',
    'Level 5 - Achiever',
    'Level 6 - Champion',
    'Level 7 - Genius',
  ];

  late final TextEditingController _adminEmailController;
  late final TextEditingController _adminPasswordController;

  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentPasswordController =
      TextEditingController();

  final TextEditingController _kidNicknameController = TextEditingController();
  final TextEditingController _kidUsernameController = TextEditingController();
  final TextEditingController _kidPasswordController = TextEditingController();

  final TextEditingController _lectureTitleController = TextEditingController();
  final TextEditingController _lectureBodyController = TextEditingController();
  final TextEditingController _lectureExampleController =
      TextEditingController();

  final TextEditingController _quizPromptController = TextEditingController();
  final TextEditingController _quizOptionAController = TextEditingController();
  final TextEditingController _quizOptionBController = TextEditingController();
  final TextEditingController _quizOptionCController = TextEditingController();
  final TextEditingController _quizOptionDController = TextEditingController();
  final TextEditingController _quizExplanationController =
      TextEditingController();

  late List<ParentAccount> _parents;
  late List<ChildAccount> _children;

  bool _hideAdminPassword = true;
  bool _hideParentPassword = true;
  bool _hideKidPassword = true;

  String? _editingParentId;
  String? _editingKidId;
  String _selectedKidLevel = _kidLevels.first;

  int _selectedContentLevel = 1;
  _SubjectKind _selectedContentSubject = _SubjectKind.english;
  int _selectedLectureSlot = 1;
  bool _loadingContent = true;
  List<_LectureModule> _contentModules = <_LectureModule>[];
  List<_QuizQuestion> _selectedLectureQuestions = <_QuizQuestion>[];
  int? _editingQuizIndex;
  int _selectedCorrectOption = 0;

  bool _resettingProgress = false;

  @override
  void initState() {
    super.initState();
    _parents = List<ParentAccount>.from(widget.parentAccounts);
    _children = List<ChildAccount>.from(widget.initialChildren);

    _adminEmailController = TextEditingController(text: widget.adminEmail);
    _adminPasswordController = TextEditingController(
      text: widget.adminPassword,
    );

    _loadContentForSelectedSubject();
  }

  @override
  void dispose() {
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _parentEmailController.dispose();
    _parentPasswordController.dispose();
    _kidNicknameController.dispose();
    _kidUsernameController.dispose();
    _kidPasswordController.dispose();
    _lectureTitleController.dispose();
    _lectureBodyController.dispose();
    _lectureExampleController.dispose();
    _quizPromptController.dispose();
    _quizOptionAController.dispose();
    _quizOptionBController.dispose();
    _quizOptionCController.dispose();
    _quizOptionDController.dispose();
    _quizExplanationController.dispose();
    super.dispose();
  }

  LearnovaPalette get _paletteData => _palette(context);

  String _formatDate(int epoch) {
    if (epoch <= 0) {
      return 'Date not available';
    }
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(epoch);
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }

  void _showSnack(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? _paletteData.brandPrimary,
      ),
    );
  }

  bool _isValidEmail(String value) {
    final String email = value.trim();
    return email.isNotEmpty &&
        email.contains('@') &&
        email.contains('.') &&
        email.length >= 6;
  }

  void _saveAdminCredentials() {
    final String email = _adminEmailController.text.trim();
    final String password = _adminPasswordController.text.trim();

    if (!_isValidEmail(email)) {
      _showSnack('Enter a valid admin email.', color: _paletteData.error);
      return;
    }
    if (password.length < 8) {
      _showSnack(
        'Admin password must be at least 8 characters.',
        color: _paletteData.error,
      );
      return;
    }

    widget.onAdminCredentialsUpdated(email, password);
    _showSnack('Admin credentials updated successfully.');
  }

  bool _parentEmailExists(String email, {String? excludingId}) {
    final String normalized = email.trim().toLowerCase();
    return _parents.any(
      (ParentAccount parent) =>
          parent.email.toLowerCase() == normalized && parent.id != excludingId,
    );
  }

  Future<void> _saveParentUser() async {
    final String email = _parentEmailController.text.trim();
    final String password = _parentPasswordController.text.trim();

    if (!_isValidEmail(email)) {
      _showSnack('Enter a valid parent email.', color: _paletteData.error);
      return;
    }
    if (password.length < 8) {
      _showSnack(
        'Parent password must be at least 8 characters.',
        color: _paletteData.error,
      );
      return;
    }
    if (_parentEmailExists(email, excludingId: _editingParentId)) {
      _showSnack('Parent email already exists.', color: _paletteData.error);
      return;
    }

    if (_editingParentId == null) {
      final ParentAccount account = ParentAccount(
        id: 'parent-${DateTime.now().microsecondsSinceEpoch}',
        email: email,
        password: password,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        _parents.insert(0, account);
      });
      widget.onParentAdded(account);
      _showSnack('Parent account created.');
    } else {
      final int index = _parents.indexWhere(
        (ParentAccount parent) => parent.id == _editingParentId,
      );
      if (index == -1) {
        _showSnack(
          'Could not update parent account.',
          color: _paletteData.error,
        );
        return;
      }
      final ParentAccount updated = ParentAccount(
        id: _parents[index].id,
        email: email,
        password: password,
        createdAtEpoch: _parents[index].createdAtEpoch,
      );
      setState(() {
        _parents[index] = updated;
      });
      widget.onParentUpdated(updated);
      _showSnack('Parent account updated.');
    }

    _clearParentEditor();
  }

  void _startEditParent(ParentAccount parent) {
    setState(() {
      _editingParentId = parent.id;
      _parentEmailController.text = parent.email;
      _parentPasswordController.text = parent.password;
    });
  }

  Future<void> _deleteParent(ParentAccount parent) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Parent Account'),
          content: Text('Delete ${parent.email}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: _paletteData.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    final bool removedFromApp = widget.onParentDeleted(parent.id);
    if (!removedFromApp) {
      _showSnack(
        'At least one parent account must remain.',
        color: _paletteData.error,
      );
      return;
    }

    setState(() {
      _parents.removeWhere((ParentAccount item) => item.id == parent.id);
      if (_editingParentId == parent.id) {
        _editingParentId = null;
      }
    });
    if (_editingParentId == null) {
      _clearParentEditor();
    }
    _showSnack('Parent account deleted.');
  }

  void _clearParentEditor() {
    setState(() {
      _editingParentId = null;
    });
    _parentEmailController.clear();
    _parentPasswordController.clear();
  }

  bool _kidUsernameExists(String username, {String? excludingId}) {
    final String normalized = username.trim().toLowerCase();
    return _children.any(
      (ChildAccount child) =>
          child.username.toLowerCase() == normalized && child.id != excludingId,
    );
  }

  Future<void> _saveKidUser() async {
    final String nickname = _kidNicknameController.text.trim();
    final String username = _kidUsernameController.text.trim();
    final String password = _kidPasswordController.text.trim();

    if (nickname.isEmpty || username.isEmpty || password.isEmpty) {
      _showSnack('Fill all kid fields.', color: _paletteData.error);
      return;
    }
    if (password.length < 8) {
      _showSnack(
        'Kid password must be at least 8 characters.',
        color: _paletteData.error,
      );
      return;
    }
    if (_kidUsernameExists(username, excludingId: _editingKidId)) {
      _showSnack('Kid username already exists.', color: _paletteData.error);
      return;
    }

    if (_editingKidId == null) {
      final ChildAccount child = ChildAccount(
        id: 'kid-${DateTime.now().microsecondsSinceEpoch}',
        nickname: nickname,
        username: username,
        password: password,
        level: _selectedKidLevel,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        _children.insert(0, child);
      });
      widget.onChildAdded(child);
      _showSnack('Kid account added.');
    } else {
      final int index = _children.indexWhere(
        (ChildAccount child) => child.id == _editingKidId,
      );
      if (index == -1) {
        _showSnack('Could not update kid account.', color: _paletteData.error);
        return;
      }
      final ChildAccount existing = _children[index];
      final ChildAccount child = ChildAccount(
        id: existing.id,
        nickname: nickname,
        username: username,
        password: password,
        level: _selectedKidLevel,
        createdAtEpoch: existing.createdAtEpoch,
      );
      setState(() {
        _children[index] = child;
      });
      widget.onChildUpdated(child);
      _showSnack('Kid account updated.');
    }

    _clearKidEditor();
  }

  void _startEditKid(ChildAccount child) {
    setState(() {
      _editingKidId = child.id;
      _kidNicknameController.text = child.nickname;
      _kidUsernameController.text = child.username;
      _kidPasswordController.text = child.password;
      _selectedKidLevel = child.level;
    });
  }

  Future<void> _deleteKid(ChildAccount child) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Kid Account'),
          content: Text('Delete ${child.nickname} (@${child.username})?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: _paletteData.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _children.removeWhere((ChildAccount item) => item.id == child.id);
      if (_editingKidId == child.id) {
        _editingKidId = null;
      }
    });
    if (_editingKidId == null) {
      _clearKidEditor();
    }
    widget.onChildDeleted(child.id);
    _showSnack('Kid account deleted.');
  }

  void _clearKidEditor() {
    setState(() {
      _editingKidId = null;
      _selectedKidLevel = _kidLevels.first;
    });
    _kidNicknameController.clear();
    _kidUsernameController.clear();
    _kidPasswordController.clear();
  }

  String _subjectLabel(_SubjectKind subjectKind) {
    return switch (subjectKind) {
      _SubjectKind.english => 'English',
      _SubjectKind.math => 'Math',
      _SubjectKind.gk => 'GK',
    };
  }

  String _contentLevelLabel(int levelNumber) {
    return _levelLabelFromNumber(levelNumber);
  }

  _LectureModule? _customModuleForSlot(int stageNumber) {
    for (final _LectureModule module in _contentModules) {
      if (module.stageNumber == stageNumber) {
        return module;
      }
    }
    return null;
  }

  _LectureModule? _builtInModuleForSlot(int stageNumber) {
    final List<_LectureModule> builtInModules = _builtInLessonModules(
      _selectedContentSubject,
      _selectedContentLevel,
    );
    for (final _LectureModule module in builtInModules) {
      if (module.stageNumber == stageNumber) {
        return module;
      }
    }
    return null;
  }

  _LectureModule? _selectedLectureReference() {
    return _customModuleForSlot(_selectedLectureSlot) ??
        _builtInModuleForSlot(_selectedLectureSlot);
  }

  bool get _selectedSlotHasCustomContent {
    return _customModuleForSlot(_selectedLectureSlot) != null;
  }

  void _populateEditorsFromSelectedSlot() {
    final _LectureModule? module = _selectedLectureReference();
    final _LectureSlide? leadSlide = module != null && module.slides.isNotEmpty
        ? module.slides.first
        : null;
    setState(() {
      _lectureTitleController.text = module?.title ?? '';
      _lectureBodyController.text = leadSlide?.body ?? '';
      _lectureExampleController.text = leadSlide?.example ?? '';
      _selectedLectureQuestions = module == null
          ? <_QuizQuestion>[]
          : List<_QuizQuestion>.from(module.quizQuestions);
      _editingQuizIndex = null;
      _selectedCorrectOption = 0;
    });
    _quizPromptController.clear();
    _quizOptionAController.clear();
    _quizOptionBController.clear();
    _quizOptionCController.clear();
    _quizOptionDController.clear();
    _quizExplanationController.clear();
  }

  Future<void> _loadContentForSelectedSubject() async {
    setState(() {
      _loadingContent = true;
      _editingQuizIndex = null;
    });

    final List<_LectureModule> modules = await _loadCustomLectureModules(
      _selectedContentLevel,
      _selectedContentSubject,
    );

    if (!mounted) {
      return;
    }

    modules.sort(
      (_LectureModule a, _LectureModule b) =>
          a.stageNumber.compareTo(b.stageNumber),
    );
    setState(() {
      _contentModules = modules;
      _loadingContent = false;
    });
    _populateEditorsFromSelectedSlot();
  }

  _LectureModule? _buildLectureModule({
    required List<_QuizQuestion> quizQuestions,
    bool showErrors = true,
  }) {
    final String title = _lectureTitleController.text.trim();
    final String body = _lectureBodyController.text.trim();
    final String example = _lectureExampleController.text.trim();

    if (title.isEmpty || body.isEmpty || example.isEmpty) {
      if (showErrors) {
        _showSnack(
          'Fill title, lesson text, and example.',
          color: _paletteData.error,
        );
      }
      return null;
    }

    return _LectureModule(
      levelNumber: _selectedContentLevel,
      stageNumber: _selectedLectureSlot,
      title: title,
      slides: <_LectureSlide>[
        _LectureSlide(
          title: title,
          body: body,
          example: example,
          icon: _adminSubjectIcon(_selectedContentSubject),
          accentColor: _adminSubjectColor(_selectedContentSubject),
        ),
      ],
      quizQuestions: quizQuestions,
    );
  }

  Future<void> _persistContentModules(String successMessage) async {
    final List<_LectureModule> sortedModules =
        List<_LectureModule>.from(_contentModules)..sort(
          (_LectureModule a, _LectureModule b) =>
              a.stageNumber.compareTo(b.stageNumber),
        );

    await _saveCustomLectureModules(
      _selectedContentLevel,
      _selectedContentSubject,
      sortedModules,
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _contentModules = sortedModules;
    });
    _populateEditorsFromSelectedSlot();
    _showSnack(successMessage);
  }

  Future<void> _saveLecture() async {
    final _LectureModule? module = _buildLectureModule(
      quizQuestions: _selectedLectureQuestions,
    );
    if (module == null) {
      return;
    }

    setState(() {
      _contentModules.removeWhere(
        (_LectureModule item) => item.stageNumber == _selectedLectureSlot,
      );
      _contentModules.add(module);
    });

    await _persistContentModules(
      'Lecture ${_selectedLectureSlot.toString()} saved for ${_contentLevelLabel(_selectedContentLevel)} ${_subjectLabel(_selectedContentSubject)}.',
    );
  }

  Future<void> _deleteLecture() async {
    if (!_selectedSlotHasCustomContent) {
      _showSnack(
        'No custom lecture is saved for this slot yet.',
        color: _paletteData.error,
      );
      return;
    }

    setState(() {
      _contentModules.removeWhere(
        (_LectureModule item) => item.stageNumber == _selectedLectureSlot,
      );
    });

    await _persistContentModules(
      'Custom lecture ${_selectedLectureSlot.toString()} removed. Built-in content is active again.',
    );
  }

  void _clearLectureEditor() {
    _populateEditorsFromSelectedSlot();
  }

  Future<void> _saveQuizQuestion() async {
    final _LectureModule? baseModule = _buildLectureModule(
      quizQuestions: _selectedLectureQuestions,
    );
    if (baseModule == null) {
      _showSnack(
        'Save the lecture details before adding quiz questions.',
        color: _paletteData.error,
      );
      return;
    }

    final String prompt = _quizPromptController.text.trim();
    final String a = _quizOptionAController.text.trim();
    final String b = _quizOptionBController.text.trim();
    final String c = _quizOptionCController.text.trim();
    final String d = _quizOptionDController.text.trim();
    final String explanation = _quizExplanationController.text.trim();

    if (prompt.isEmpty || a.isEmpty || b.isEmpty || c.isEmpty || d.isEmpty) {
      _showSnack('Fill prompt and all 4 options.', color: _paletteData.error);
      return;
    }

    final _QuizQuestion question = _QuizQuestion(
      prompt: prompt,
      options: <String>[a, b, c, d],
      correctIndex: _selectedCorrectOption,
      explanation: explanation,
    );

    final List<_QuizQuestion> updatedQuestions = List<_QuizQuestion>.from(
      _selectedLectureQuestions,
    );

    setState(() {
      if (_editingQuizIndex == null) {
        updatedQuestions.add(question);
      } else {
        updatedQuestions[_editingQuizIndex!] = question;
      }
      _contentModules.removeWhere(
        (_LectureModule item) => item.stageNumber == _selectedLectureSlot,
      );
      _contentModules.add(
        _LectureModule(
          levelNumber: baseModule.levelNumber,
          stageNumber: baseModule.stageNumber,
          title: baseModule.title,
          slides: baseModule.slides,
          quizQuestions: updatedQuestions,
        ),
      );
      _selectedLectureQuestions = updatedQuestions;
    });

    await _persistContentModules(
      'Quiz updated for lecture ${_selectedLectureSlot.toString()}.',
    );
    _clearQuizEditor();
  }

  void _editQuizQuestion(int index) {
    final _QuizQuestion question = _selectedLectureQuestions[index];
    setState(() {
      _editingQuizIndex = index;
      _quizPromptController.text = question.prompt;
      _quizOptionAController.text = question.options[0];
      _quizOptionBController.text = question.options[1];
      _quizOptionCController.text = question.options[2];
      _quizOptionDController.text = question.options[3];
      _quizExplanationController.text = question.explanation;
      _selectedCorrectOption = question.correctIndex.clamp(0, 3);
    });
  }

  Future<void> _deleteQuizQuestion(int index) async {
    final _LectureModule? baseModule = _buildLectureModule(
      quizQuestions: _selectedLectureQuestions,
      showErrors: false,
    );
    if (baseModule == null) {
      return;
    }

    final List<_QuizQuestion> updatedQuestions = List<_QuizQuestion>.from(
      _selectedLectureQuestions,
    )..removeAt(index);

    setState(() {
      _selectedLectureQuestions = updatedQuestions;
      _contentModules.removeWhere(
        (_LectureModule item) => item.stageNumber == _selectedLectureSlot,
      );
      _contentModules.add(
        _LectureModule(
          levelNumber: baseModule.levelNumber,
          stageNumber: baseModule.stageNumber,
          title: baseModule.title,
          slides: baseModule.slides,
          quizQuestions: updatedQuestions,
        ),
      );
      if (_editingQuizIndex == index) {
        _editingQuizIndex = null;
      }
    });

    await _persistContentModules(
      'Quiz question removed from lecture ${_selectedLectureSlot.toString()}.',
    );
    if (_editingQuizIndex == null) {
      _clearQuizEditor();
    }
  }

  void _clearQuizEditor() {
    setState(() {
      _editingQuizIndex = null;
      _selectedCorrectOption = 0;
    });
    _quizPromptController.clear();
    _quizOptionAController.clear();
    _quizOptionBController.clear();
    _quizOptionCController.clear();
    _quizOptionDController.clear();
    _quizExplanationController.clear();
  }

  Future<void> _resetSubjectCustomContent() async {
    await _clearCustomSubjectContent(
      _selectedContentLevel,
      _selectedContentSubject,
    );
    if (!mounted) {
      return;
    }
    await _loadContentForSelectedSubject();
    if (!mounted) {
      return;
    }
    _showSnack(
      '${_subjectLabel(_selectedContentSubject)} for ${_contentLevelLabel(_selectedContentLevel)} is back to built-in lessons.',
    );
  }

  Future<void> _changeContentLevel(int levelNumber) async {
    if (_selectedContentLevel == levelNumber) {
      return;
    }
    setState(() {
      _selectedContentLevel = levelNumber;
      _selectedLectureSlot = 1;
    });
    await _loadContentForSelectedSubject();
  }

  Future<void> _changeContentSubject(_SubjectKind subjectKind) async {
    if (_selectedContentSubject == subjectKind) {
      return;
    }
    setState(() {
      _selectedContentSubject = subjectKind;
      _selectedLectureSlot = 1;
    });
    await _loadContentForSelectedSubject();
  }

  void _selectLectureSlot(int slotNumber) {
    if (_selectedLectureSlot == slotNumber) {
      return;
    }
    setState(() {
      _selectedLectureSlot = slotNumber;
    });
    _populateEditorsFromSelectedSlot();
  }

  String _slotStatusLabel(int stageNumber) {
    if (_customModuleForSlot(stageNumber) != null) {
      return 'Custom';
    }
    if (_builtInModuleForSlot(stageNumber) != null) {
      return 'Built-in';
    }
    return 'Empty';
  }

  Color _slotStatusColor(int stageNumber) {
    if (_customModuleForSlot(stageNumber) != null) {
      return _paletteData.success;
    }
    if (_builtInModuleForSlot(stageNumber) != null) {
      return const Color(0xFF1CB0F6);
    }
    return _paletteData.textSecondary;
  }

  Future<void> _resetKidProgress() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reset Kid Progress'),
          content: const Text(
            'This will clear streak, stars, reports, and lecture progress for all kids. Continue?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: _paletteData.error,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true || _resettingProgress) {
      return;
    }

    setState(() {
      _resettingProgress = true;
    });

    final int cleared = await widget.onResetKidProgress();
    if (!mounted) {
      return;
    }

    setState(() {
      _resettingProgress = false;
    });
    _showSnack('Kid progress reset complete. Cleared $cleared records.');
  }

  Widget _buildOverviewCard() {
    final int customLectureCount = _contentModules.length;
    final int customQuizCount = _contentModules.fold<int>(
      0,
      (int total, _LectureModule module) => total + module.quizQuestions.length,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _paletteData.brandPrimary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 30,
                  color: _paletteData.brandPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Admin Control Center',
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: _paletteData.textPrimary,
                      ),
                    ),
                    Text(
                      'Live users and content controls for Learnova',
                      style: TextStyle(color: _paletteData.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double cardWidth = constraints.maxWidth >= 860
                  ? (constraints.maxWidth - 24) / 3
                  : (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  SizedBox(
                    width: cardWidth,
                    child: _AdminMiniStat(
                      icon: Icons.family_restroom_rounded,
                      value: '${_parents.length}',
                      label: 'Parent Accounts',
                      color: const Color(0xFF1CB0F6),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _AdminMiniStat(
                      icon: Icons.child_care_rounded,
                      value: '${_children.length}',
                      label: 'Kid Accounts',
                      color: const Color(0xFF58CC02),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _AdminMiniStat(
                      icon: Icons.menu_book_rounded,
                      value: '$customLectureCount',
                      label:
                          '${_contentLevelLabel(_selectedContentLevel)} ${_subjectLabel(_selectedContentSubject)} Custom Lectures',
                      color: const Color(0xFFFFB84B),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _AdminMiniStat(
                      icon: Icons.quiz_rounded,
                      value: '$customQuizCount',
                      label:
                          '${_contentLevelLabel(_selectedContentLevel)} ${_subjectLabel(_selectedContentSubject)} Quiz Questions',
                      color: const Color(0xFF7B6BFF),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCredentialsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _AdminSectionTitle(
            title: 'Admin Credentials',
            subtitle: 'Update admin login access',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _adminEmailController,
            decoration: const InputDecoration(
              labelText: 'Admin Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _adminPasswordController,
            obscureText: _hideAdminPassword,
            decoration: InputDecoration(
              labelText: 'Admin Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _hideAdminPassword = !_hideAdminPassword;
                  });
                },
                icon: Icon(
                  _hideAdminPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: _saveAdminCredentials,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Admin Credentials'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentManagementSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _AdminSectionTitle(
            title: 'Parent Users',
            subtitle: 'Add, edit, and delete parent accounts',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget form = _buildParentForm();
              final Widget list = _buildParentList();
              if (constraints.maxWidth < 980) {
                return Column(
                  children: <Widget>[form, const SizedBox(height: 12), list],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: form),
                  const SizedBox(width: 12),
                  Expanded(child: list),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParentForm() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paletteData.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _paletteData.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _editingParentId == null ? 'Create Parent' : 'Edit Parent',
            style: TextStyle(
              color: _paletteData.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _parentEmailController,
            decoration: const InputDecoration(
              labelText: 'Parent Email',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _parentPasswordController,
            obscureText: _hideParentPassword,
            decoration: InputDecoration(
              labelText: 'Parent Password',
              prefixIcon: const Icon(Icons.key_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _hideParentPassword = !_hideParentPassword;
                  });
                },
                icon: Icon(
                  _hideParentPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveParentUser,
                  icon: Icon(
                    _editingParentId == null
                        ? Icons.add_rounded
                        : Icons.save_rounded,
                  ),
                  label: Text(
                    _editingParentId == null
                        ? 'Add Parent'
                        : 'Save Parent Update',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _clearParentEditor,
                icon: const Icon(Icons.close_rounded),
                label: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParentList() {
    if (_parents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _paletteData.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _paletteData.borderSoft),
        ),
        child: Text(
          'No parent users found.',
          style: TextStyle(color: _paletteData.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paletteData.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _paletteData.borderSoft),
      ),
      child: Column(
        children: _parents.map((ParentAccount parent) {
          final bool editing = _editingParentId == parent.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: editing
                    ? _paletteData.brandPrimary
                    : _paletteData.borderSoft,
                width: editing ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _paletteData.brandPrimary.withValues(
                    alpha: 0.16,
                  ),
                  child: Icon(
                    Icons.family_restroom_rounded,
                    color: _paletteData.brandPrimary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        parent.email,
                        style: TextStyle(
                          color: _paletteData.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Created: ${_formatDate(parent.createdAtEpoch)}',
                        style: TextStyle(color: _paletteData.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _startEditParent(parent),
                  icon: Icon(
                    Icons.edit_rounded,
                    color: _paletteData.textSecondary,
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteParent(parent),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: _paletteData.error,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKidManagementSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _AdminSectionTitle(
            title: 'Kid Users',
            subtitle: 'Manage child accounts and levels',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget form = _buildKidForm();
              final Widget list = _buildKidList();
              if (constraints.maxWidth < 980) {
                return Column(
                  children: <Widget>[form, const SizedBox(height: 12), list],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: form),
                  const SizedBox(width: 12),
                  Expanded(child: list),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKidForm() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paletteData.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _paletteData.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _editingKidId == null ? 'Create Kid User' : 'Edit Kid User',
            style: TextStyle(
              color: _paletteData.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _kidNicknameController,
            decoration: const InputDecoration(
              labelText: 'Nick Name',
              prefixIcon: Icon(Icons.face_rounded),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _kidUsernameController,
            decoration: const InputDecoration(
              labelText: 'User Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _kidPasswordController,
            obscureText: _hideKidPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _hideKidPassword = !_hideKidPassword;
                  });
                },
                icon: Icon(
                  _hideKidPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _selectedKidLevel,
            decoration: const InputDecoration(labelText: 'Child Level'),
            isExpanded: true,
            items: _kidLevels
                .map(
                  (String level) => DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedKidLevel = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveKidUser,
                  icon: Icon(
                    _editingKidId == null
                        ? Icons.add_rounded
                        : Icons.save_rounded,
                  ),
                  label: Text(
                    _editingKidId == null ? 'Add Kid' : 'Save Kid Update',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _clearKidEditor,
                icon: const Icon(Icons.close_rounded),
                label: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKidList() {
    if (_children.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _paletteData.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _paletteData.borderSoft),
        ),
        child: Text(
          'No kid users found.',
          style: TextStyle(color: _paletteData.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paletteData.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _paletteData.borderSoft),
      ),
      child: Column(
        children: _children.map((ChildAccount child) {
          final bool editing = _editingKidId == child.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: editing
                    ? _paletteData.brandPrimary
                    : _paletteData.borderSoft,
                width: editing ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _paletteData.brandPrimary.withValues(
                    alpha: 0.16,
                  ),
                  child: Text(
                    child.nickname.isEmpty
                        ? 'K'
                        : child.nickname.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: _paletteData.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${child.nickname}  (@${child.username})',
                        style: TextStyle(
                          color: _paletteData.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${child.level} • Created: ${_formatDate(child.createdAtEpoch)}',
                        style: TextStyle(color: _paletteData.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _startEditKid(child),
                  icon: Icon(
                    Icons.edit_rounded,
                    color: _paletteData.textSecondary,
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteKid(child),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: _paletteData.error,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentSection() {
    final List<int> customSlots =
        _contentModules
            .map(((_LectureModule module) => module.stageNumber))
            .toList()
          ..sort();
    final String customSlotText = customSlots.isEmpty
        ? 'No custom lecture overrides saved yet.'
        : 'Custom lecture slots: ${customSlots.join(', ')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _AdminSectionTitle(
            title: 'Lectures & Quiz Control',
            subtitle:
                'Select level, subject, and lecture number, then manage the lecture and quiz together',
          ),
          const SizedBox(height: 12),
          if (_loadingContent)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: CircularProgressIndicator(
                  color: _paletteData.brandPrimary,
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth < 780) {
                      return Column(
                        children: <Widget>[
                          DropdownButtonFormField<int>(
                            initialValue: _selectedContentLevel,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Level',
                              prefixIcon: Icon(Icons.stairs_rounded),
                            ),
                            items: List<DropdownMenuItem<int>>.generate(7, (
                              int index,
                            ) {
                              final int levelNumber = index + 1;
                              return DropdownMenuItem<int>(
                                value: levelNumber,
                                child: Text(
                                  _contentLevelLabel(levelNumber),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                            onChanged: (int? value) {
                              if (value == null) {
                                return;
                              }
                              _changeContentLevel(value);
                            },
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _SubjectKind.values.map((
                              _SubjectKind subjectKind,
                            ) {
                              return ChoiceChip(
                                label: Text(_subjectLabel(subjectKind)),
                                selected:
                                    _selectedContentSubject == subjectKind,
                                onSelected: (bool value) {
                                  if (!value) {
                                    return;
                                  }
                                  _changeContentSubject(subjectKind);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: _selectedContentLevel,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Level',
                              prefixIcon: Icon(Icons.stairs_rounded),
                            ),
                            items: List<DropdownMenuItem<int>>.generate(7, (
                              int index,
                            ) {
                              final int levelNumber = index + 1;
                              return DropdownMenuItem<int>(
                                value: levelNumber,
                                child: Text(_contentLevelLabel(levelNumber)),
                              );
                            }),
                            onChanged: (int? value) {
                              if (value == null) {
                                return;
                              }
                              _changeContentLevel(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _SubjectKind.values.map((
                              _SubjectKind subjectKind,
                            ) {
                              return ChoiceChip(
                                label: Text(_subjectLabel(subjectKind)),
                                selected:
                                    _selectedContentSubject == subjectKind,
                                onSelected: (bool value) {
                                  if (!value) {
                                    return;
                                  }
                                  _changeContentSubject(subjectKind);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Lecture Number',
                  style: TextStyle(
                    color: _paletteData.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List<Widget>.generate(10, (int index) {
                    final int slotNumber = index + 1;
                    final bool selected = _selectedLectureSlot == slotNumber;
                    final Color slotColor = _slotStatusColor(slotNumber);
                    return ChoiceChip(
                      label: Text(
                        'Lecture $slotNumber',
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : _paletteData.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      avatar: Icon(
                        _customModuleForSlot(slotNumber) != null
                            ? Icons.edit_note_rounded
                            : _builtInModuleForSlot(slotNumber) != null
                            ? Icons.auto_stories_rounded
                            : Icons.add_circle_outline_rounded,
                        size: 18,
                        color: selected ? Colors.white : slotColor,
                      ),
                      selected: selected,
                      selectedColor: slotColor,
                      backgroundColor: Colors.white.withValues(alpha: 0.72),
                      onSelected: (bool value) {
                        if (!value) {
                          return;
                        }
                        _selectLectureSlot(slotNumber);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  customSlotText,
                  style: TextStyle(color: _paletteData.textSecondary),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final Widget lecturePanel = _buildLecturePanel();
                    final Widget quizPanel = _buildQuizPanel();
                    if (constraints.maxWidth < 1120) {
                      return Column(
                        children: <Widget>[
                          lecturePanel,
                          const SizedBox(height: 12),
                          quizPanel,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: lecturePanel),
                        const SizedBox(width: 12),
                        Expanded(child: quizPanel),
                      ],
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLecturePanel() {
    final _LectureModule? customModule = _customModuleForSlot(
      _selectedLectureSlot,
    );
    final _LectureModule? builtInModule = _builtInModuleForSlot(
      _selectedLectureSlot,
    );
    final _LectureModule? activeModule = customModule ?? builtInModule;
    final String status = _slotStatusLabel(_selectedLectureSlot);
    final Color statusColor = _slotStatusColor(_selectedLectureSlot);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paletteData.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _paletteData.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lecture ${_selectedLectureSlot.toString()} Setup',
            style: TextStyle(
              color: _paletteData.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withValues(alpha: 0.36)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$status slot for ${_contentLevelLabel(_selectedContentLevel)} ${_subjectLabel(_selectedContentSubject)}',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activeModule == null
                      ? 'No lesson exists yet for this lecture number. Add one below.'
                      : customModule != null
                      ? 'This custom lesson is live now. Delete it any time to fall back to the built-in lesson.'
                      : 'Built-in lesson "${activeModule.title}" is loaded. Save any changes to create your custom version.',
                  style: TextStyle(color: _paletteData.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _lectureTitleController,
            decoration: const InputDecoration(
              labelText: 'Lecture Title',
              prefixIcon: Icon(Icons.title_rounded),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _lectureBodyController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Lecture Teaching Text',
              prefixIcon: Icon(Icons.school_outlined),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _lectureExampleController,
            minLines: 1,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Example / Practice Line',
              prefixIcon: Icon(Icons.lightbulb_outline_rounded),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveLecture,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Lecture'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _clearLectureEditor,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reload Slot'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectedSlotHasCustomContent
                      ? _deleteLecture
                      : null,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete Custom Lecture'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quiz count: ${_selectedLectureQuestions.length}',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: _paletteData.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paletteData.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _paletteData.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Quiz For Lecture ${_selectedLectureSlot.toString()}',
            style: TextStyle(
              color: _paletteData.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_selectedLectureQuestions.length} questions for this lecture. Best stars keep only the highest score for this lecture slot.',
            style: TextStyle(color: _paletteData.textSecondary),
          ),
          const SizedBox(height: 10),
          if (_selectedLectureQuestions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _paletteData.borderSoft),
              ),
              child: Text(
                'No quiz questions added yet for this lecture.',
                style: TextStyle(color: _paletteData.textSecondary),
              ),
            )
          else
            ...List<Widget>.generate(_selectedLectureQuestions.length, (
              int index,
            ) {
              final _QuizQuestion question = _selectedLectureQuestions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _paletteData.borderSoft),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${index + 1}. ${question.prompt}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _paletteData.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _editQuizQuestion(index),
                      icon: const Icon(Icons.edit_rounded),
                    ),
                    IconButton(
                      onPressed: () => _deleteQuizQuestion(index),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: _paletteData.error,
                      ),
                    ),
                  ],
                ),
              );
            }),
          TextField(
            controller: _quizPromptController,
            minLines: 1,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Question Prompt',
              prefixIcon: Icon(Icons.help_outline_rounded),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _quizOptionAController,
            decoration: const InputDecoration(labelText: 'Option A'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _quizOptionBController,
            decoration: const InputDecoration(labelText: 'Option B'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _quizOptionCController,
            decoration: const InputDecoration(labelText: 'Option C'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _quizOptionDController,
            decoration: const InputDecoration(labelText: 'Option D'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            initialValue: _selectedCorrectOption,
            decoration: const InputDecoration(labelText: 'Correct Option'),
            items: const <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(value: 0, child: Text('Option A')),
              DropdownMenuItem<int>(value: 1, child: Text('Option B')),
              DropdownMenuItem<int>(value: 2, child: Text('Option C')),
              DropdownMenuItem<int>(value: 3, child: Text('Option D')),
            ],
            onChanged: (int? value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedCorrectOption = value;
              });
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _quizExplanationController,
            minLines: 1,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Why this answer is correct (shown on wrong answer)',
              prefixIcon: Icon(Icons.info_outline_rounded),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveQuizQuestion,
                  icon: Icon(
                    _editingQuizIndex == null
                        ? Icons.add_rounded
                        : Icons.save_rounded,
                  ),
                  label: Text(
                    _editingQuizIndex == null
                        ? 'Add Quiz Question'
                        : 'Save Question',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _clearQuizEditor,
                icon: const Icon(Icons.close_rounded),
                label: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _resetSubjectCustomContent,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(
              'Use Built-In Content For ${_contentLevelLabel(_selectedContentLevel)} ${_subjectLabel(_selectedContentSubject)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _AdminSectionTitle(
            title: 'System Tools',
            subtitle: 'Global controls for app maintenance',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: _resettingProgress ? null : _resetKidProgress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _paletteData.error,
                  foregroundColor: Colors.white,
                ),
                icon: _resettingProgress
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      )
                    : const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset All Kid Progress'),
              ),
              OutlinedButton.icon(
                onPressed: () => widget.onOpenThemePicker(context),
                icon: const Icon(Icons.palette_outlined),
                label: const Text('Open Theme Picker'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      roleTitle: 'Admin Dashboard',
      roleSubtitle: '',
      onOpenThemePicker: widget.onOpenThemePicker,
      onExit: widget.onExit,
      menuAccountEmail: _adminEmailController.text.trim(),
      menuLinkedKids: _children.length,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: <Widget>[
              _buildOverviewCard(),
              const SizedBox(height: 14),
              _buildAdminCredentialsSection(),
              const SizedBox(height: 14),
              _buildParentManagementSection(),
              const SizedBox(height: 14),
              _buildKidManagementSection(),
              const SizedBox(height: 14),
              _buildContentSection(),
              const SizedBox(height: 14),
              _buildSystemSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminSectionTitle extends StatelessWidget {
  const _AdminSectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(color: palette.textSecondary)),
      ],
    );
  }
}

class _AdminMiniStat extends StatelessWidget {
  const _AdminMiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: palette.surfaceSoft,
        border: Border.all(color: palette.borderSoft),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.16),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(label, style: TextStyle(color: palette.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
