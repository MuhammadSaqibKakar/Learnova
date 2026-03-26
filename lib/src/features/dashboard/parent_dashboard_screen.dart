part of 'package:learnova/main.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({
    required this.parentEmail,
    required this.initialChildren,
    required this.onChildAdded,
    required this.onChildUpdated,
    required this.onChildDeleted,
    required this.onOpenThemePicker,
    required this.onExit,
    super.key,
  });

  final String parentEmail;
  final List<ChildAccount> initialChildren;
  final void Function(ChildAccount child) onChildAdded;
  final void Function(ChildAccount child) onChildUpdated;
  final void Function(String childId) onChildDeleted;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onExit;

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  static const String _kidProgressPrefix = 'learnova.kid.progress';

  static const List<String> _fallbackAvatars = <String>[
    '\u{1F600}',
    '\u{1F604}',
    '\u{1F642}',
    '\u{1F60A}',
    '\u{1F929}',
    '\u{1F60E}',
    '\u{1F9D2}',
    '\u{1F467}',
    '\u{1F466}',
    '\u{1F98A}',
    '\u{1F43C}',
    '\u{1F42F}',
    '\u{1F430}',
    '\u{1F438}',
  ];

  static const List<int> _fallbackFrameColors = <int>[
    0xFF58CC02,
    0xFF1CB0F6,
    0xFFFFC800,
    0xFFFF8C42,
    0xFF7B6BFF,
    0xFFFF5C8A,
  ];

  static const List<int> _fallbackAccentColors = <int>[
    0xFFA8E46B,
    0xFF8EDBFF,
    0xFFFFE17E,
    0xFFFFBA86,
    0xFFC7B7FF,
    0xFFFFA5BE,
  ];

  late List<ChildAccount> _children;
  bool _loadingReports = true;
  Map<String, _KidPerformanceReport> _kidReports =
      <String, _KidPerformanceReport>{};

  @override
  void initState() {
    super.initState();
    _children = List<ChildAccount>.from(widget.initialChildren);
    _refreshKidReports();
  }

  String _kidStorageKey(String childId, String suffix) {
    return '$_kidProgressPrefix.$childId.$suffix';
  }

  String _kidReportKey(String childId, String suffix) {
    return '$_kidProgressPrefix.$childId.report.$suffix';
  }

  String _subjectLabel(String value) {
    switch (value.trim().toLowerCase()) {
      case 'english':
        return 'English';
      case 'math':
        return 'Math';
      case 'gk':
        return 'GK';
      default:
        return value.trim().isEmpty ? 'Subject' : value.trim();
    }
  }

  String _fallbackAvatarForChild(ChildAccount child) {
    final int seed = child.id.codeUnits.fold<int>(0, (int a, int b) => a + b);
    return _fallbackAvatars[seed % _fallbackAvatars.length];
  }

  int _fallbackFrameColorForChild(ChildAccount child) {
    final int seed = child.id.codeUnits.fold<int>(0, (int a, int b) => a + b);
    return _fallbackFrameColors[seed % _fallbackFrameColors.length];
  }

  int _fallbackAccentColorForChild(ChildAccount child) {
    final int seed = child.id.codeUnits.fold<int>(0, (int a, int b) => a + b);
    return _fallbackAccentColors[seed % _fallbackAccentColors.length];
  }

  _KidQuizAttempt? _parseAttempt(String raw) {
    final List<String> parts = raw.split('|');
    if (parts.length < 4) {
      return null;
    }
    final int? scoreValue = int.tryParse(parts[2]);
    if (scoreValue == null) {
      return null;
    }
    final int score = scoreValue < 0
        ? 0
        : scoreValue > 10
        ? 10
        : scoreValue;
    final bool passed =
        parts[3] == '1' || parts[3].trim().toLowerCase() == 'true';
    return _KidQuizAttempt(
      subject: _subjectLabel(parts[1]),
      stage: 1,
      score: score,
      passed: passed,
      timestamp: DateTime.tryParse(parts[0])?.toLocal(),
      totalQuestions: 10,
      mistakes: const <_KidAnswerMistake>[],
    );
  }

  _KidQuizAttempt? _parseAttemptJson(String raw) {
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final int score = (decoded['score'] is int)
          ? decoded['score'] as int
          : int.tryParse('${decoded['score']}') ?? 0;
      final int total = (decoded['total'] is int)
          ? decoded['total'] as int
          : int.tryParse('${decoded['total']}') ?? 10;
      final bool passed =
          decoded['passed'] == true ||
          '${decoded['passed']}'.trim().toLowerCase() == 'true' ||
          '${decoded['passed']}' == '1';
      final List<_KidAnswerMistake> mistakes = <_KidAnswerMistake>[];
      final dynamic rawMistakes = decoded['mistakes'];
      if (rawMistakes is List<dynamic>) {
        for (final dynamic item in rawMistakes) {
          if (item is! Map<String, dynamic>) {
            continue;
          }
          mistakes.add(
            _KidAnswerMistake(
              prompt: '${item['prompt'] ?? ''}'.trim(),
              selected: '${item['selected'] ?? ''}'.trim(),
              correct: '${item['correct'] ?? ''}'.trim(),
              explanation: '${item['explanation'] ?? ''}'.trim(),
            ),
          );
        }
      }

      return _KidQuizAttempt(
        subject: _subjectLabel('${decoded['subject'] ?? ''}'),
        stage: (decoded['stage'] is int)
            ? decoded['stage'] as int
            : int.tryParse('${decoded['stage']}') ?? 1,
        score: score < 0
            ? 0
            : score > total
            ? total
            : score,
        passed: passed,
        timestamp: DateTime.tryParse(
          '${decoded['timestamp'] ?? ''}',
        )?.toLocal(),
        totalQuestions: total <= 0 ? 10 : total,
        mistakes: mistakes,
      );
    } catch (_) {
      return null;
    }
  }

  _KidPerformanceReport _emptyReportForChild(ChildAccount child) {
    return _KidPerformanceReport(
      streak: 0,
      stars: 0,
      testsTaken: 0,
      highestMark: 0,
      attempts: const <_KidQuizAttempt>[],
      avatarEmoji: _fallbackAvatarForChild(child),
      avatarFrameColor: _fallbackFrameColorForChild(child),
      avatarAccentColor: _fallbackAccentColorForChild(child),
    );
  }

  _KidPerformanceReport _loadKidReport(
    SharedPreferences prefs,
    ChildAccount child,
  ) {
    final int streak = prefs.getInt(_kidStorageKey(child.id, 'streak')) ?? 0;
    final int stars = prefs.getInt(_kidStorageKey(child.id, 'stars')) ?? 0;
    final List<String> rawAttemptsJson =
        prefs.getStringList(_kidReportKey(child.id, 'attempts_json')) ??
        const <String>[];
    final List<_KidQuizAttempt> attempts = rawAttemptsJson.isNotEmpty
        ? rawAttemptsJson
              .map(_parseAttemptJson)
              .whereType<_KidQuizAttempt>()
              .toList()
        : (prefs.getStringList(_kidReportKey(child.id, 'attempts')) ??
                  const <String>[])
              .map(_parseAttempt)
              .whereType<_KidQuizAttempt>()
              .toList();
    attempts.sort((_KidQuizAttempt a, _KidQuizAttempt b) {
      final int aTime = a.timestamp?.millisecondsSinceEpoch ?? 0;
      final int bTime = b.timestamp?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });

    int testsTaken = prefs.getInt(_kidReportKey(child.id, 'tests_taken')) ?? 0;
    if (testsTaken < attempts.length) {
      testsTaken = attempts.length;
    }

    int highestMark =
        prefs.getInt(_kidReportKey(child.id, 'highest_mark')) ?? 0;
    for (final _KidQuizAttempt attempt in attempts) {
      highestMark = max(highestMark, attempt.score);
    }

    final String avatarEmoji =
        prefs.getString(_kidStorageKey(child.id, 'avatar_emoji')) ??
        _fallbackAvatarForChild(child);
    final int avatarFrameColor =
        prefs.getInt(_kidStorageKey(child.id, 'avatar_frame')) ??
        _fallbackFrameColorForChild(child);
    final int avatarAccentColor =
        prefs.getInt(_kidStorageKey(child.id, 'avatar_accent')) ??
        _fallbackAccentColorForChild(child);

    return _KidPerformanceReport(
      streak: streak,
      stars: stars,
      testsTaken: testsTaken,
      highestMark: highestMark,
      attempts: attempts,
      avatarEmoji: avatarEmoji,
      avatarFrameColor: avatarFrameColor,
      avatarAccentColor: avatarAccentColor,
    );
  }

  Future<void> _refreshKidReports() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _loadingReports = true;
    });

    final List<ChildAccount> snapshot = List<ChildAccount>.from(_children);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, _KidPerformanceReport> loaded =
        <String, _KidPerformanceReport>{};

    for (final ChildAccount child in snapshot) {
      loaded[child.id] = _loadKidReport(prefs, child);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _kidReports = loaded;
      _loadingReports = false;
    });
  }

  void _handleChildAdded(ChildAccount child) {
    setState(() {
      _children.insert(0, child);
    });
    widget.onChildAdded(child);
    _refreshKidReports();
  }

  void _handleChildUpdated(ChildAccount child) {
    setState(() {
      final int index = _children.indexWhere(
        (ChildAccount item) => item.id == child.id,
      );
      if (index != -1) {
        _children[index] = child;
      }
    });
    widget.onChildUpdated(child);
    _refreshKidReports();
  }

  void _handleChildDeleted(String childId) {
    setState(() {
      _children.removeWhere((ChildAccount child) => child.id == childId);
      _kidReports.remove(childId);
    });
    widget.onChildDeleted(childId);
    _refreshKidReports();
  }

  Future<void> _openKidManagement() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return KidManagementScreen(
            parentEmail: widget.parentEmail,
            initialChildren: List<ChildAccount>.from(_children),
            onChildAdded: _handleChildAdded,
            onChildUpdated: _handleChildUpdated,
            onChildDeleted: _handleChildDeleted,
          );
        },
      ),
    );
    if (!mounted) {
      return;
    }
    _refreshKidReports();
  }

  void _openKidReportDetails(ChildAccount child) {
    final _KidPerformanceReport report =
        _kidReports[child.id] ?? _emptyReportForChild(child);
    final _KidWeeklyInsight insight = _weeklyInsightFor(child, report);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _KidReportDetailsScreen(
            child: child,
            report: report,
            weeklyInsight: insight,
          );
        },
      ),
    );
  }

  Widget _buildKidReportsSection() {
    final LearnovaPalette palette = _palette(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: <Widget>[
              Text(
                'Kid Reports',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_children.length} students',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_loadingReports)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(context),
            child: const Center(child: CircularProgressIndicator()),
          ),
        if (!_loadingReports && _children.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(context),
            child: Text(
              'No kids found yet. Add children from Kid Management to see reports.',
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
        if (!_loadingReports && _children.isNotEmpty)
          ...List<Widget>.generate(_children.length, (int index) {
            final ChildAccount child = _children[index];
            final _KidPerformanceReport report =
                _kidReports[child.id] ?? _emptyReportForChild(child);
            return SlideFadeIn(
              delay: Duration(milliseconds: 90 * (index % 5)),
              child: _KidReportPreviewCard(
                child: child,
                report: report,
                index: index,
                onTap: () => _openKidReportDetails(child),
              ),
            );
          }),
      ],
    );
  }

  DateTime _rollingWeekStart() {
    final DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
  }

  _KidWeeklyInsight _weeklyInsightFor(
    ChildAccount child,
    _KidPerformanceReport report,
  ) {
    final DateTime weekStart = _rollingWeekStart();
    final List<_KidQuizAttempt> weeklyAttempts = report.attempts.where((
      _KidQuizAttempt attempt,
    ) {
      final DateTime? when = attempt.timestamp;
      return when != null && !when.isBefore(weekStart);
    }).toList();
    weeklyAttempts.sort((_KidQuizAttempt a, _KidQuizAttempt b) {
      final int aTime = a.timestamp?.millisecondsSinceEpoch ?? 0;
      final int bTime = b.timestamp?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });

    final Map<String, List<double>> bySubject = <String, List<double>>{};
    final List<_KidWeeklyMistake> mistakes = <_KidWeeklyMistake>[];
    int totalScore = 0;
    int totalQuestions = 0;

    for (final _KidQuizAttempt attempt in weeklyAttempts) {
      bySubject
          .putIfAbsent(attempt.subject, () => <double>[])
          .add(attempt.score / max(attempt.totalQuestions, 1));
      totalScore += attempt.score;
      totalQuestions += max(attempt.totalQuestions, 1);
      for (final _KidAnswerMistake mistake in attempt.mistakes) {
        mistakes.add(
          _KidWeeklyMistake(
            childName: child.nickname,
            subject: attempt.subject,
            prompt: mistake.prompt,
            selected: mistake.selected,
            correct: mistake.correct,
            explanation: mistake.explanation,
            timestamp: attempt.timestamp,
          ),
        );
      }
    }

    String strength = 'No weekly data yet';
    String weakArea = 'No weak area yet';
    if (bySubject.isNotEmpty) {
      final List<MapEntry<String, List<double>>> entries = bySubject.entries
          .toList();
      entries.sort((
        MapEntry<String, List<double>> a,
        MapEntry<String, List<double>> b,
      ) {
        final double aAvg =
            a.value.reduce((double x, double y) => x + y) / a.value.length;
        final double bAvg =
            b.value.reduce((double x, double y) => x + y) / b.value.length;
        return bAvg.compareTo(aAvg);
      });
      final MapEntry<String, List<double>> best = entries.first;
      final MapEntry<String, List<double>> worst = entries.last;
      final double bestAvg =
          best.value.reduce((double x, double y) => x + y) / best.value.length;
      final double worstAvg =
          worst.value.reduce((double x, double y) => x + y) /
          worst.value.length;
      strength = '${best.key} (${(bestAvg * 100).round()}%)';
      weakArea = '${worst.key} (${(worstAvg * 100).round()}%)';
    }

    final double averagePercent = totalQuestions == 0
        ? 0
        : (totalScore / totalQuestions) * 100;
    return _KidWeeklyInsight(
      weekStart: weekStart,
      attempts: weeklyAttempts,
      mistakes: mistakes,
      strength: strength,
      weakArea: weakArea,
      averagePercent: averagePercent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int kidCount = _children.length;
    return DashboardShell(
      roleTitle: 'Parent Dashboard',
      roleSubtitle: '',
      onOpenThemePicker: widget.onOpenThemePicker,
      onExit: widget.onExit,
      menuAccountEmail: widget.parentEmail,
      menuLinkedKids: kidCount,
      onOpenKidManagement: _openKidManagement,
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
                      delay: const Duration(milliseconds: 120),
                      child: _KidManagementEntryCard(
                        totalKids: kidCount,
                        onTap: _openKidManagement,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 210),
                      child: _buildKidReportsSection(),
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
}

class _KidManagementEntryCard extends StatelessWidget {
  const _KidManagementEntryCard({required this.totalKids, required this.onTap});

  final int totalKids;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color startColor = Color.alphaBlend(
      Colors.white.withValues(alpha: isDark ? 0.05 : 0.08),
      palette.brandPrimary,
    );
    final Color endColor = Color.alphaBlend(
      palette.brandAccent.withValues(alpha: isDark ? 0.18 : 0.3),
      palette.brandPrimary.withValues(alpha: isDark ? 0.8 : 0.9),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[startColor, endColor],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.brandPrimary.withValues(alpha: 0.26),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.34),
                      ),
                    ),
                    child: const Icon(
                      Icons.groups_2_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kid Management',
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                totalKids == 1
                    ? '1 kid account linked. Tap to open full management page.'
                    : '$totalKids kid accounts linked. Tap to open full management page.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.93),
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _KidManagementPill(
                    icon: Icons.groups_rounded,
                    text: '$totalKids Kids',
                  ),
                  const _KidManagementPill(
                    icon: Icons.tune_rounded,
                    text: 'Levels',
                  ),
                  const _KidManagementPill(
                    icon: Icons.edit_note_rounded,
                    text: 'Add / Update',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KidManagementPill extends StatelessWidget {
  const _KidManagementPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _KidReportPreviewCard extends StatelessWidget {
  const _KidReportPreviewCard({
    required this.child,
    required this.report,
    required this.index,
    required this.onTap,
  });

  final ChildAccount child;
  final _KidPerformanceReport report;
  final int index;
  final VoidCallback onTap;

  List<Color> _gradient() {
    if (index.isEven) {
      return const <Color>[Color(0xFF0F2C63), Color(0xFF081A3B)];
    }
    return const <Color>[Color(0xFF0E4F4F), Color(0xFF082D2D)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradient(),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Kid Report',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      child.username,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    _KidReportAvatarBubble(
                      emoji: report.avatarEmoji,
                      frameColorValue: report.avatarFrameColor,
                      accentColorValue: report.avatarAccentColor,
                      radius: 25,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            child.nickname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            child.level,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.86),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withValues(alpha: 0.84),
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _KidReportMetricChip(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Streak',
                      value: '${report.streak}',
                    ),
                    _KidReportMetricChip(
                      icon: Icons.star_rounded,
                      label: 'Stars',
                      value: '${report.stars}',
                    ),
                    _KidReportMetricChip(
                      icon: Icons.quiz_rounded,
                      label: 'Tests Total',
                      value: '${report.testsTaken}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KidReportDetailsScreen extends StatelessWidget {
  const _KidReportDetailsScreen({
    required this.child,
    required this.report,
    required this.weeklyInsight,
  });

  final ChildAccount child;
  final _KidPerformanceReport report;
  final _KidWeeklyInsight weeklyInsight;

  String _formatTime(DateTime? value) {
    if (value == null) {
      return 'Time not available';
    }
    final DateTime local = value.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}  ${two(local.hour)}:${two(local.minute)}';
  }

  List<MapEntry<String, List<_KidQuizAttempt>>> _groupedAttempts() {
    final Map<String, List<_KidQuizAttempt>> groups =
        <String, List<_KidQuizAttempt>>{};
    for (final _KidQuizAttempt attempt in report.attempts) {
      final String key = '${attempt.subject}|${attempt.stage}';
      groups.putIfAbsent(key, () => <_KidQuizAttempt>[]).add(attempt);
    }
    final List<MapEntry<String, List<_KidQuizAttempt>>> entries = groups.entries
        .toList();
    entries.sort((
      MapEntry<String, List<_KidQuizAttempt>> a,
      MapEntry<String, List<_KidQuizAttempt>> b,
    ) {
      int latestMs(List<_KidQuizAttempt> items) {
        int ms = 0;
        for (final _KidQuizAttempt item in items) {
          final int time = item.timestamp?.millisecondsSinceEpoch ?? 0;
          if (time > ms) {
            ms = time;
          }
        }
        return ms;
      }

      return latestMs(b.value).compareTo(latestMs(a.value));
    });
    for (final MapEntry<String, List<_KidQuizAttempt>> entry in entries) {
      entry.value.sort((_KidQuizAttempt a, _KidQuizAttempt b) {
        final int aMs = a.timestamp?.millisecondsSinceEpoch ?? 0;
        final int bMs = b.timestamp?.millisecondsSinceEpoch ?? 0;
        return aMs.compareTo(bMs);
      });
    }
    return entries;
  }

  String _groupLabel(String key) {
    final List<String> parts = key.split('|');
    if (parts.length < 2) {
      return '$key Quiz';
    }
    final int stage = int.tryParse(parts[1]) ?? 1;
    return '${parts[0]} Quiz - Stage $stage';
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final List<MapEntry<String, List<_KidQuizAttempt>>> groupedAttempts =
        _groupedAttempts();
    return Scaffold(
      appBar: AppBar(title: Text('${child.nickname} Report')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFF0F2C63), Color(0xFF091A3A)],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        _KidReportAvatarBubble(
                          emoji: report.avatarEmoji,
                          frameColorValue: report.avatarFrameColor,
                          accentColorValue: report.avatarAccentColor,
                          radius: 33,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                child.nickname,
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontSize: 29,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Username: ${child.username}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.88),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                child.level,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.82),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      _KidReportDetailTile(
                        icon: Icons.local_fire_department_rounded,
                        title: 'Current Streak',
                        value: '${report.streak}',
                      ),
                      _KidReportDetailTile(
                        icon: Icons.star_rounded,
                        title: 'Total Stars',
                        value: '${report.stars}',
                      ),
                      _KidReportDetailTile(
                        icon: Icons.quiz_rounded,
                        title: 'Tests Taken Total',
                        value: '${report.testsTaken}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return _WeeklyReportDetailsScreen(
                                child: child,
                                insight: weeklyInsight,
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                      label: const Text('Get Weekly Report'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Quiz Results Details',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.attempts.isEmpty
                              ? 'No attempts yet. Attempts will appear here once the kid takes quizzes.'
                              : '${report.attempts.length} attempts recorded',
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (report.attempts.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 12),
                          ...List<Widget>.generate(groupedAttempts.length, (
                            int groupIndex,
                          ) {
                            final MapEntry<String, List<_KidQuizAttempt>>
                            group = groupedAttempts[groupIndex];
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: groupIndex == groupedAttempts.length - 1
                                    ? 0
                                    : 10,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: palette.surfaceSoft,
                                border: Border.all(color: palette.borderSoft),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _groupLabel(group.key),
                                    style: TextStyle(
                                      color: palette.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ...List<Widget>.generate(group.value.length, (
                                    int attemptIndex,
                                  ) {
                                    final _KidQuizAttempt attempt =
                                        group.value[attemptIndex];
                                    final bool passed = attempt.passed;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: attemptIndex == 0 ? 0 : 6,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.white.withValues(
                                            alpha: 0.78,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: passed
                                                    ? const Color(0xFFE4F7CF)
                                                    : const Color(0xFFFFE8D9),
                                              ),
                                              child: Icon(
                                                passed
                                                    ? Icons.check_rounded
                                                    : Icons.replay_rounded,
                                                color: passed
                                                    ? const Color(0xFF4B9A1D)
                                                    : const Color(0xFFD56A28),
                                                size: 19,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Attempt ${attemptIndex + 1}: ${attempt.score}/${attempt.totalQuestions}',
                                                    style: TextStyle(
                                                      color:
                                                          palette.textPrimary,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    passed
                                                        ? 'Passed'
                                                        : 'Failed',
                                                    style: TextStyle(
                                                      color: passed
                                                          ? const Color(
                                                              0xFF3A8B1C,
                                                            )
                                                          : const Color(
                                                              0xFFC35C24,
                                                            ),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Mistakes: ${attempt.mistakes.length} - ${_formatTime(attempt.timestamp)}',
                                                    style: TextStyle(
                                                      color:
                                                          palette.textSecondary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KidReportAvatarBubble extends StatelessWidget {
  const _KidReportAvatarBubble({
    required this.emoji,
    required this.frameColorValue,
    required this.accentColorValue,
    required this.radius,
  });

  final String emoji;
  final int frameColorValue;
  final int accentColorValue;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(frameColorValue), Color(accentColorValue)],
            ),
          ),
          child: Center(
            child: Text(emoji, style: TextStyle(fontSize: radius * 1.08)),
          ),
        ),
      ),
    );
  }
}

class _KidReportMetricChip extends StatelessWidget {
  const _KidReportMetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _KidReportDetailTile extends StatelessWidget {
  const _KidReportDetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return SizedBox(
      width: 210,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: palette.surfaceSoft,
          border: Border.all(color: palette.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: palette.brandPrimary, size: 21),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: palette.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.fredoka(
                color: palette.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyBadge extends StatelessWidget {
  const _WeeklyBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: palette.brandPrimary.withValues(alpha: 0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: palette.brandPrimary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyReportDetailsScreen extends StatelessWidget {
  const _WeeklyReportDetailsScreen({
    required this.child,
    required this.insight,
  });

  final ChildAccount child;
  final _KidWeeklyInsight insight;

  String _formatTime(DateTime? value) {
    if (value == null) {
      return 'Time not available';
    }
    final DateTime local = value.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)} ${two(local.hour)}:${two(local.minute)}';
  }

  String _formatDate(DateTime value) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final DateTime now = DateTime.now();
    final DateTime weekEnd = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(title: Text('${child.nickname} Weekly Report')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Weekly Performance Window',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'From ${_formatDate(insight.weekStart)} to ${_formatDate(weekEnd)}',
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(context),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _WeeklyBadge(
                          icon: Icons.insights_rounded,
                          text: 'Average ${insight.averagePercent.round()}%',
                        ),
                        _WeeklyBadge(
                          icon: Icons.emoji_events_rounded,
                          text: 'Strength: ${insight.strength}',
                        ),
                        _WeeklyBadge(
                          icon: Icons.flag_rounded,
                          text: 'Weak Area: ${insight.weakArea}',
                        ),
                        _WeeklyBadge(
                          icon: Icons.quiz_rounded,
                          text: 'Quizzes: ${insight.attempts.length}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Weekly Quiz Attempts',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (insight.attempts.isEmpty)
                          Text(
                            'No quiz attempts in the last 7 days.',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (insight.attempts.isNotEmpty)
                          ...List<Widget>.generate(insight.attempts.length, (
                            int index,
                          ) {
                            final _KidQuizAttempt item =
                                insight.attempts[index];
                            return Container(
                              margin: EdgeInsets.only(
                                top: index == 0 ? 4 : 0,
                                bottom: index == insight.attempts.length - 1
                                    ? 0
                                    : 10,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: palette.surfaceSoft,
                                border: Border.all(color: palette.borderSoft),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.passed
                                          ? const Color(0xFFE7F7D6)
                                          : const Color(0xFFFFEAD7),
                                    ),
                                    child: Icon(
                                      item.passed
                                          ? Icons.check_rounded
                                          : Icons.close_rounded,
                                      color: item.passed
                                          ? const Color(0xFF3F8A20)
                                          : const Color(0xFFC95A2D),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${item.subject} - Stage ${item.stage}',
                                          style: TextStyle(
                                            color: palette.textPrimary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Score: ${item.score}/${item.totalQuestions} - ${item.passed ? 'Passed' : 'Failed'}',
                                          style: TextStyle(
                                            color: palette.textSecondary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(item.timestamp),
                                          style: TextStyle(
                                            color: palette.textSecondary
                                                .withValues(alpha: 0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Weekly Mistakes',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (insight.mistakes.isEmpty)
                          Text(
                            'No mistakes this week. Great progress!',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (insight.mistakes.isNotEmpty)
                          ...List<Widget>.generate(insight.mistakes.length, (
                            int index,
                          ) {
                            final _KidWeeklyMistake item =
                                insight.mistakes[index];
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: index == insight.mistakes.length - 1
                                    ? 0
                                    : 10,
                                top: index == 0 ? 4 : 0,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFFFF4E9),
                                border: Border.all(
                                  color: const Color(0xFFFFD9B0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${item.subject} - ${_formatTime(item.timestamp)}',
                                    style: TextStyle(
                                      color: palette.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.prompt,
                                    style: TextStyle(
                                      color: palette.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Child answered: ${item.selected}',
                                    style: const TextStyle(
                                      color: Color(0xFFC85A30),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Correct answer: ${item.correct}',
                                    style: const TextStyle(
                                      color: Color(0xFF2F8D40),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (item.explanation.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        item.explanation,
                                        style: TextStyle(
                                          color: palette.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KidAnswerMistake {
  const _KidAnswerMistake({
    required this.prompt,
    required this.selected,
    required this.correct,
    required this.explanation,
  });

  final String prompt;
  final String selected;
  final String correct;
  final String explanation;
}

class _KidQuizAttempt {
  const _KidQuizAttempt({
    required this.subject,
    required this.stage,
    required this.score,
    required this.passed,
    required this.timestamp,
    required this.totalQuestions,
    required this.mistakes,
  });

  final String subject;
  final int stage;
  final int score;
  final bool passed;
  final DateTime? timestamp;
  final int totalQuestions;
  final List<_KidAnswerMistake> mistakes;
}

class _KidWeeklyMistake {
  const _KidWeeklyMistake({
    required this.childName,
    required this.subject,
    required this.prompt,
    required this.selected,
    required this.correct,
    required this.explanation,
    required this.timestamp,
  });

  final String childName;
  final String subject;
  final String prompt;
  final String selected;
  final String correct;
  final String explanation;
  final DateTime? timestamp;
}

class _KidWeeklyInsight {
  const _KidWeeklyInsight({
    required this.weekStart,
    required this.attempts,
    required this.mistakes,
    required this.strength,
    required this.weakArea,
    required this.averagePercent,
  });

  final DateTime weekStart;
  final List<_KidQuizAttempt> attempts;
  final List<_KidWeeklyMistake> mistakes;
  final String strength;
  final String weakArea;
  final double averagePercent;
}

class _KidPerformanceReport {
  const _KidPerformanceReport({
    required this.streak,
    required this.stars,
    required this.testsTaken,
    required this.highestMark,
    required this.attempts,
    required this.avatarEmoji,
    required this.avatarFrameColor,
    required this.avatarAccentColor,
  });

  final int streak;
  final int stars;
  final int testsTaken;
  final int highestMark;
  final List<_KidQuizAttempt> attempts;
  final String avatarEmoji;
  final int avatarFrameColor;
  final int avatarAccentColor;
}
