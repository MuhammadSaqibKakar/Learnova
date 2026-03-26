part of 'package:learnova/main.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({
    required this.adminEmail,
    required this.onOpenThemePicker,
    required this.onExit,
    super.key,
  });

  final String adminEmail;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onExit;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      roleTitle: 'Admin Dashboard',
      roleSubtitle: 'System controls and reports will be added here.',
      onOpenThemePicker: onOpenThemePicker,
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

class KidDashboardScreen extends StatefulWidget {
  const KidDashboardScreen({
    required this.childId,
    required this.childName,
    required this.level,
    required this.onExit,
    super.key,
  });

  final String childId;
  final String childName;
  final String level;
  final NavigationHandler onExit;

  @override
  State<KidDashboardScreen> createState() => _KidDashboardScreenState();
}

class _KidDashboardScreenState extends State<KidDashboardScreen> {
  static const String _kidProgressPrefix = 'learnova.kid.progress';

  int _currentStreak = 0;
  int _currentStars = 0;

  static const List<Color> _skinTones = <Color>[
    Color(0xFFFFDFC4),
    Color(0xFFF4C49C),
    Color(0xFFE1AA7B),
    Color(0xFFC6865A),
    Color(0xFF8D5524),
  ];

  static const List<Color> _hairColors = <Color>[
    Color(0xFF2D1B12),
    Color(0xFF4C2E1F),
    Color(0xFF705138),
    Color(0xFFCDA67A),
    Color(0xFFD8C3A5),
    Color(0xFF1B2735),
  ];

  static const List<Color> _avatarFrameColors = <Color>[
    Color(0xFF58CC02),
    Color(0xFF1CB0F6),
    Color(0xFFFFC800),
    Color(0xFFFF6B6B),
    Color(0xFF8E7CFF),
    Color(0xFFFF8C42),
    Color(0xFF00BFA5),
    Color(0xFFFF5C8A),
    Color(0xFF7ABF35),
    Color(0xFF4D96FF),
  ];

  static const List<Color> _outfitColors = <Color>[
    Color(0xFF58CC02),
    Color(0xFF1CB0F6),
    Color(0xFFFF9600),
    Color(0xFFFF5C8A),
    Color(0xFF6F42C1),
    Color(0xFF00BFA5),
    Color(0xFFFF4B4B),
    Color(0xFF3F51B5),
  ];

  static const List<Color> _accentColors = <Color>[
    Color(0xFFFFD166),
    Color(0xFF9BDEAC),
    Color(0xFF8EC5FC),
    Color(0xFFFFAFCC),
    Color(0xFFC7B8FF),
    Color(0xFFFFC784),
  ];

  static const List<_KidAvatarCategory> _avatarCategories =
      _KidAvatarCategory.values;

  static const Map<_KidAvatarCategory, List<String>> _categoryEmojiPool =
      <_KidAvatarCategory, List<String>>{
        _KidAvatarCategory.kids: <String>[
          '😀',
          '😃',
          '😄',
          '😁',
          '😆',
          '😊',
          '🙂',
          '😉',
          '🤗',
          '😍',
          '😋',
          '😜',
          '🤩',
          '🥳',
          '😎',
          '🤓',
          '🧒',
          '👧',
          '👦',
          '👧🏽',
          '👦🏽',
          '👧🏾',
          '👦🏾',
          '🧑‍🎓',
        ],
        _KidAvatarCategory.animals: <String>[
          '🐶',
          '🐱',
          '🐭',
          '🐹',
          '🐰',
          '🦊',
          '🐻',
          '🐼',
          '🐨',
          '🐯',
          '🦁',
          '🐮',
          '🐷',
          '🐸',
          '🐵',
          '🐔',
          '🐧',
          '🐦',
          '🦉',
          '🦆',
          '🐤',
          '🐣',
          '🦄',
          '🐙',
        ],
        _KidAvatarCategory.birds: <String>[
          '🐦',
          '🐦‍⬛',
          '🦜',
          '🦉',
          '🦅',
          '🦆',
          '🕊️',
          '🐧',
          '🐤',
          '🐥',
          '🐣',
          '🪽',
          '🐦',
          '🐦‍⬛',
          '🦜',
          '🦉',
          '🦅',
          '🦆',
          '🕊️',
          '🐧',
          '🐤',
          '🐥',
          '🐣',
          '🪽',
        ],
        _KidAvatarCategory.cars: <String>[
          '🚗',
          '🚕',
          '🚙',
          '🚌',
          '🚎',
          '🏎️',
          '🚓',
          '🚑',
          '🚒',
          '🚐',
          '🛻',
          '🚚',
          '🚛',
          '🚜',
          '🛺',
          '🚘',
          '🚖',
          '🚍',
          '🚔',
          '🚗',
          '🚕',
          '🚙',
          '🏎️',
          '🚐',
        ],
        _KidAvatarCategory.bikes: <String>[
          '🚲',
          '🚴',
          '🚴‍♀️',
          '🚴‍♂️',
          '🚵',
          '🚵‍♀️',
          '🚵‍♂️',
          '🏍️',
          '🛵',
          '🚲',
          '🚴',
          '🚴‍♀️',
          '🚴‍♂️',
          '🚵',
          '🚵‍♀️',
          '🚵‍♂️',
          '🏍️',
          '🛵',
          '🚲',
          '🚴',
          '🚴‍♀️',
          '🚴‍♂️',
          '🏍️',
          '🛵',
        ],
        _KidAvatarCategory.nature: <String>[
          '🌳',
          '🌲',
          '🌴',
          '🌵',
          '🍀',
          '🌿',
          '🌱',
          '🌷',
          '🌹',
          '🌻',
          '🌼',
          '🌸',
          '🌺',
          '🍄',
          '🏔️',
          '⛰️',
          '🌈',
          '☀️',
          '🌤️',
          '⛅',
          '☁️',
          '🌦️',
          '🌊',
          '🌙',
        ],
      };

  static const List<String> _leaderboardLevels = <String>[
    'Level 1 - Starter',
    'Level 2 - Explorer',
    'Level 3 - Builder',
    'Level 4 - Challenger',
    'Level 5 - Achiever',
    'Level 6 - Champion',
    'Level 7 - Genius',
  ];

  late final List<_KidAvatarOption> _avatarOptions = _buildAvatarOptions();
  late _KidAvatarOption _selectedAvatar = _avatarOptions.first;
  late _KidAvatarCategory _activeAvatarCategory;
  late final Map<String, List<_KidLeaderboardEntry>> _leaderboardByLevel =
      <String, List<_KidLeaderboardEntry>>{
        'Level 1 - Starter': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Ayaan', stars: 180, avatarIndex: 7),
          _KidLeaderboardEntry(nickname: 'Lily', stars: 150, avatarIndex: 29),
          _KidLeaderboardEntry(nickname: 'Noah', stars: 120, avatarIndex: 54),
        ],
        'Level 2 - Explorer': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Zara', stars: 170, avatarIndex: 11),
          _KidLeaderboardEntry(nickname: 'Adam', stars: 145, avatarIndex: 34),
          _KidLeaderboardEntry(nickname: 'Mia', stars: 132, avatarIndex: 61),
        ],
        'Level 3 - Builder': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Ray', stars: 190, avatarIndex: 5),
          _KidLeaderboardEntry(nickname: 'Hania', stars: 162, avatarIndex: 38),
          _KidLeaderboardEntry(nickname: 'Taha', stars: 137, avatarIndex: 72),
        ],
        'Level 4 - Challenger': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Aisha', stars: 210, avatarIndex: 14),
          _KidLeaderboardEntry(nickname: 'Bilal', stars: 176, avatarIndex: 48),
          _KidLeaderboardEntry(nickname: 'Sara', stars: 153, avatarIndex: 83),
        ],
        'Level 5 - Achiever': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Hamza', stars: 225, avatarIndex: 19),
          _KidLeaderboardEntry(nickname: 'Esha', stars: 193, avatarIndex: 43),
          _KidLeaderboardEntry(nickname: 'Ali', stars: 168, avatarIndex: 87),
        ],
        'Level 6 - Champion': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Noor', stars: 246, avatarIndex: 21),
          _KidLeaderboardEntry(nickname: 'Saad', stars: 214, avatarIndex: 56),
          _KidLeaderboardEntry(nickname: 'Iqra', stars: 188, avatarIndex: 90),
        ],
        'Level 7 - Genius': const <_KidLeaderboardEntry>[
          _KidLeaderboardEntry(nickname: 'Ari', stars: 270, avatarIndex: 26),
          _KidLeaderboardEntry(nickname: 'Rida', stars: 238, avatarIndex: 64),
          _KidLeaderboardEntry(nickname: 'Zayan', stars: 207, avatarIndex: 95),
        ],
      };
  late String _selectedLeaderboardLevel;

  List<_KidAvatarOption> _buildAvatarOptions() {
    final List<_KidAvatarOption> options = <_KidAvatarOption>[];
    int nextId = 0;
    for (
      int categoryIndex = 0;
      categoryIndex < _avatarCategories.length;
      categoryIndex++
    ) {
      final _KidAvatarCategory category = _avatarCategories[categoryIndex];
      final List<String> symbols =
          _categoryEmojiPool[category] ?? const <String>[];
      for (int localId = 0; localId < symbols.length; localId++) {
        options.add(
          _KidAvatarOption(
            id: nextId++,
            category: category,
            emoji: symbols[localId],
            frameColor:
                _avatarFrameColors[(localId + categoryIndex) %
                    _avatarFrameColors.length],
            skinColor:
                _skinTones[(localId + categoryIndex) % _skinTones.length],
            hairColor:
                _hairColors[(localId + categoryIndex * 2) % _hairColors.length],
            outfitColor:
                _outfitColors[(localId + categoryIndex * 3) %
                    _outfitColors.length],
            accentColor:
                _accentColors[(localId + categoryIndex * 2) %
                    _accentColors.length],
            eyeStyle: localId % 4,
            mouthStyle: (localId ~/ 2) % 4,
            hairStyle: localId % 8,
            accessoryStyle: (localId ~/ 3) % 7,
            poseStyle: localId % 3,
            simpleStyle: false,
          ),
        );
      }
    }
    return options;
  }

  String _kidStorageKey(String suffix) {
    return '$_kidProgressPrefix.${widget.childId}.$suffix';
  }

  _KidAvatarOption _avatarFromId(int id) {
    for (final _KidAvatarOption option in _avatarOptions) {
      if (option.id == id) {
        return option;
      }
    }
    return _avatarOptions.first;
  }

  Future<void> _persistAvatarSelection(
    _KidAvatarOption option, {
    SharedPreferences? prefs,
  }) async {
    final SharedPreferences storage =
        prefs ?? await SharedPreferences.getInstance();
    await storage.setInt(_kidStorageKey('avatar_id'), option.id);
    await storage.setString(_kidStorageKey('avatar_emoji'), option.emoji);
    await storage.setInt(
      _kidStorageKey('avatar_frame'),
      option.frameColor.toARGB32(),
    );
    await storage.setInt(
      _kidStorageKey('avatar_accent'),
      option.accentColor.toARGB32(),
    );
  }

  int _dayStamp(DateTime value) {
    final DateTime d = DateTime(value.year, value.month, value.day);
    return d.millisecondsSinceEpoch;
  }

  Future<void> _syncDailyStreak() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int today = _dayStamp(DateTime.now());
    final String lastLoginKey = _kidStorageKey('last_login_day');
    final String streakKey = _kidStorageKey('streak');
    final String starsKey = _kidStorageKey('stars');

    final int? lastLoginDay = prefs.getInt(lastLoginKey);
    int streak = prefs.getInt(streakKey) ?? 0;

    if (lastLoginDay == null) {
      streak = 1;
    } else {
      final int diffDays =
          ((today - lastLoginDay) ~/ Duration.millisecondsPerDay);
      if (diffDays <= 0) {
        streak = max(streak, 1);
      } else if (diffDays == 1) {
        streak = max(streak + 1, 1);
      } else {
        streak = 1;
      }
    }

    await prefs.setInt(lastLoginKey, today);
    await prefs.setInt(streakKey, streak);
    final int stars = prefs.getInt(starsKey) ?? 0;
    final int? savedAvatarId = prefs.getInt(_kidStorageKey('avatar_id'));
    final _KidAvatarOption savedAvatar = savedAvatarId == null
        ? _selectedAvatar
        : _avatarFromId(savedAvatarId);

    if (savedAvatarId == null) {
      await _persistAvatarSelection(savedAvatar, prefs: prefs);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _currentStreak = streak;
      _currentStars = stars;
      _selectedAvatar = savedAvatar;
      _activeAvatarCategory = savedAvatar.category;
    });
  }

  @override
  void initState() {
    super.initState();
    _activeAvatarCategory = _selectedAvatar.category;
    _selectedLeaderboardLevel = _leaderboardLevels.contains(widget.level)
        ? widget.level
        : _leaderboardLevels.first;
    _syncDailyStreak();
  }

  List<_KidLeaderboardEntry> get _activeLeaderboard {
    final List<_KidLeaderboardEntry> source =
        _leaderboardByLevel[_selectedLeaderboardLevel] ??
        const <_KidLeaderboardEntry>[];
    final List<_KidLeaderboardEntry> sorted = List<_KidLeaderboardEntry>.from(
      source,
    );
    sorted.sort(
      (_KidLeaderboardEntry a, _KidLeaderboardEntry b) =>
          b.stars.compareTo(a.stars),
    );
    return sorted;
  }

  void _openAvatarPicker(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    _KidAvatarCategory activeCategory = _activeAvatarCategory;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            final List<_KidAvatarOption> visibleOptions = _avatarOptions
                .where(
                  (_KidAvatarOption option) =>
                      option.category == activeCategory,
                )
                .toList();
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.84,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Choose Avatar',
                        style: GoogleFonts.fredoka(
                          fontSize: 26,
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${activeCategory.subtitle} • ${visibleOptions.length} styles',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _avatarCategories.map((
                            _KidAvatarCategory category,
                          ) {
                            final bool selected = category == activeCategory;
                            return ChoiceChip(
                              avatar: Icon(
                                category.icon,
                                size: 16,
                                color: selected
                                    ? Colors.white
                                    : palette.textSecondary,
                              ),
                              label: Text(category.label),
                              selected: selected,
                              onSelected: (_) {
                                setSheetState(() {
                                  activeCategory = category;
                                  _activeAvatarCategory = category;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: LayoutBuilder(
                          builder:
                              (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                final int crossAxisCount =
                                    constraints.maxWidth >= 760
                                    ? 6
                                    : constraints.maxWidth >= 520
                                    ? 5
                                    : 4;
                                return GridView.builder(
                                  itemCount: visibleOptions.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        final _KidAvatarOption option =
                                            visibleOptions[index];
                                        final bool selected =
                                            option.id == _selectedAvatar.id;
                                        return InkWell(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              _selectedAvatar = option;
                                              _activeAvatarCategory =
                                                  option.category;
                                            });
                                            await _persistAvatarSelection(
                                              option,
                                            );
                                            if (sheetContext.mounted) {
                                              Navigator.of(sheetContext).pop();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: selected
                                                    ? palette.brandPrimary
                                                    : palette.borderSoft,
                                                width: selected ? 2.4 : 1.2,
                                              ),
                                              color: palette.surfaceSoft,
                                            ),
                                            child: Center(
                                              child: _kidAvatarBubble(
                                                option,
                                                radius: 29,
                                                borderColor: selected
                                                    ? palette.brandPrimary
                                                    : Colors.white,
                                                borderWidth: selected
                                                    ? 2.4
                                                    : 1.6,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                );
                              },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openSubject(String subjectName) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _SubjectLearningPathScreen(
            subjectName: subjectName,
            kidId: widget.childId,
            kidLevel: widget.level,
          );
        },
      ),
    );
    if (!mounted) {
      return;
    }
    await _syncDailyStreak();
  }

  _KidAvatarOption _avatarForIndex(int index) {
    final int safeIndex = index % _avatarOptions.length;
    return _avatarOptions[safeIndex];
  }

  Widget _kidAvatarBubble(
    _KidAvatarOption option, {
    double radius = 22,
    Color borderColor = Colors.white,
    double borderWidth = 2,
  }) {
    return _CartoonAvatarGlyph(
      option: option,
      radius: radius,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required int value,
  }) {
    final bool isStar = icon == Icons.star_rounded;
    final List<Color> cardColors = isStar
        ? const <Color>[Color(0xFFE8F9C7), Color(0xFFC8EE84)]
        : const <Color>[Color(0xFFE5F9C2), Color(0xFFBDE67B)];
    final List<Color> iconBgColors = isStar
        ? const <Color>[Color(0xFFFFF6CF), Color(0xFFFFE79A)]
        : const <Color>[Color(0xFFFFE7D8), Color(0xFFFFC5A3)];
    final Color iconColor = isStar
        ? const Color(0xFFFFB300)
        : const Color(0xFFFF5A36);
    const Color valueTextColor = Color(0xFFD39A00);
    const Color labelTextColor = Color(0xFFC98D00);
    final Color shadowColor = const Color(0xFF8FCB4F);
    final Color borderLineColor = isStar
        ? const Color(0xFFF5D75C)
        : const Color(0xFFD4ED8C);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardColors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderLineColor, width: 1.8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: iconBgColors,
              ),
              border: Border.all(color: Colors.white, width: 1.6),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Text(
              '$value',
              style: GoogleFonts.fredoka(
                color: valueTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 0.95,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fredoka(
                color: labelTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.auto_awesome_rounded,
            size: 12,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAvatarButton(double radius) {
    return Tooltip(
      message: 'Tap to change avatar',
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => _openAvatarPicker(context),
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: _kidAvatarBubble(
              _selectedAvatar,
              radius: radius,
              borderColor: Colors.white,
              borderWidth: 2.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKidTopBar() {
    final LearnovaPalette palette = _palette(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.brandPrimary.withValues(alpha: 0.96),
            palette.brandPrimary.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.brandPrimary.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 620;
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildTopAvatarButton(24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.childName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.level,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Tap avatar to change',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.84),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildStatChip(
                        icon: Icons.local_fire_department_rounded,
                        label: 'Streak',
                        value: _currentStreak,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatChip(
                        icon: Icons.star_rounded,
                        label: 'Stars',
                        value: _currentStars,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: <Widget>[
              _buildTopAvatarButton(25),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.childName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.level,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tap avatar to change',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.84),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak',
                value: _currentStreak,
              ),
              const SizedBox(width: 10),
              _buildStatChip(
                icon: Icons.star_rounded,
                label: 'Stars',
                value: _currentStars,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubjectTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final LearnovaPalette palette = _palette(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openSubject(title),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.borderSoft),
          color: palette.surfaceSoft,
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 22,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsSection() {
    final LearnovaPalette palette = _palette(context);
    final List<Widget> tiles = <Widget>[
      _buildSubjectTile(
        title: 'English',
        subtitle: 'Letters, words, stories',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF3AA7FF),
      ),
      _buildSubjectTile(
        title: 'Math',
        subtitle: 'Numbers and fun logic',
        icon: Icons.calculate_rounded,
        color: const Color(0xFFFFA338),
      ),
      _buildSubjectTile(
        title: 'Gk',
        subtitle: 'General knowledge adventures',
        icon: Icons.public_rounded,
        color: const Color(0xFF7A6FFF),
      ),
    ];

    return Container(
      decoration: _cardDecoration(context),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Subjects',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 780) {
                return Column(
                  children: <Widget>[
                    for (int i = 0; i < tiles.length; i++) ...<Widget>[
                      tiles[i],
                      if (i != tiles.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(child: tiles[0]),
                  const SizedBox(width: 10),
                  Expanded(child: tiles[1]),
                  const SizedBox(width: 10),
                  Expanded(child: tiles[2]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    final LearnovaPalette palette = _palette(context);
    final List<_KidLeaderboardEntry> leaderboard = _activeLeaderboard;
    return Container(
      decoration: _cardDecoration(context),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Leaderboard',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your level leaderboard',
            style: TextStyle(color: palette.textSecondary),
          ),
          const SizedBox(height: 10),
          Text(
            'Top kids from your level',
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (leaderboard.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No demo kids yet for this level.',
                style: TextStyle(color: palette.textSecondary),
              ),
            ),
          ...List<Widget>.generate(leaderboard.length, (int index) {
            final _KidLeaderboardEntry entry = leaderboard[index];
            final _KidAvatarOption avatar = _avatarForIndex(entry.avatarIndex);
            final Color medalColor = switch (index) {
              0 => const Color(0xFFFFC934),
              1 => const Color(0xFFBFC8DA),
              _ => const Color(0xFFCD8A5B),
            };

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: palette.surfaceSoft,
                border: Border.all(color: palette.borderSoft),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: medalColor.withValues(alpha: 0.2),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: medalColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _kidAvatarBubble(
                    avatar,
                    radius: 20,
                    borderColor: Colors.white,
                    borderWidth: 1.8,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          entry.nickname,
                          style: GoogleFonts.fredoka(
                            fontSize: 22,
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xFFFFC934),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.stars} stars',
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildKidBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1060),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildSubjectsSection(),
              const SizedBox(height: 14),
              _buildLeaderboardSection(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wideLayout = constraints.maxWidth >= 980;

        if (!wideLayout) {
          return Scaffold(
            appBar: AppBar(title: const Text('Kid Dashboard')),
            drawer: Drawer(
              child: _KidMenuPanel(
                nickname: widget.childName,
                level: widget.level,
                selectedAvatar: _selectedAvatar,
                inDrawer: true,
                onChooseAvatar: () {
                  Navigator.of(context).pop();
                  _openAvatarPicker(this.context);
                },
                onExit: widget.onExit,
              ),
            ),
            body: Column(
              children: <Widget>[
                _buildKidTopBar(),
                Expanded(child: _buildKidBody()),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: <Widget>[
              SizedBox(
                width: 280,
                child: _KidMenuPanel(
                  nickname: widget.childName,
                  level: widget.level,
                  selectedAvatar: _selectedAvatar,
                  onChooseAvatar: () => _openAvatarPicker(context),
                  onExit: widget.onExit,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildKidTopBar(),
                    Expanded(child: _buildKidBody()),
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

enum _KidAvatarCategory { kids, animals, birds, cars, bikes, nature }

extension _KidAvatarCategoryX on _KidAvatarCategory {
  String get label => switch (this) {
    _KidAvatarCategory.kids => 'Kids',
    _KidAvatarCategory.animals => 'Animals',
    _KidAvatarCategory.birds => 'Birds',
    _KidAvatarCategory.cars => 'Cars',
    _KidAvatarCategory.bikes => 'Bikes',
    _KidAvatarCategory.nature => 'Nature',
  };

  String get subtitle => switch (this) {
    _KidAvatarCategory.kids => 'Cute cartoon kid faces',
    _KidAvatarCategory.animals => 'Cartoon animal buddies',
    _KidAvatarCategory.birds => 'Friendly bird cartoons',
    _KidAvatarCategory.cars => 'Fun cartoon cars',
    _KidAvatarCategory.bikes => 'Cool cartoon bikes',
    _KidAvatarCategory.nature => 'Trees, mountains and nature',
  };

  IconData get icon => switch (this) {
    _KidAvatarCategory.kids => Icons.face,
    _KidAvatarCategory.animals => Icons.pets,
    _KidAvatarCategory.birds => Icons.flutter_dash,
    _KidAvatarCategory.cars => Icons.directions_car,
    _KidAvatarCategory.bikes => Icons.two_wheeler,
    _KidAvatarCategory.nature => Icons.forest,
  };
}

class _KidAvatarOption {
  const _KidAvatarOption({
    required this.id,
    required this.category,
    required this.emoji,
    required this.frameColor,
    required this.skinColor,
    required this.hairColor,
    required this.outfitColor,
    required this.accentColor,
    required this.eyeStyle,
    required this.mouthStyle,
    required this.hairStyle,
    required this.accessoryStyle,
    required this.poseStyle,
    required this.simpleStyle,
  });

  final int id;
  final _KidAvatarCategory category;
  final String emoji;
  final Color frameColor;
  final Color skinColor;
  final Color hairColor;
  final Color outfitColor;
  final Color accentColor;
  final int eyeStyle;
  final int mouthStyle;
  final int hairStyle;
  final int accessoryStyle;
  final int poseStyle;
  final bool simpleStyle;
}

class _CartoonAvatarGlyph extends StatelessWidget {
  const _CartoonAvatarGlyph({
    required this.option,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
  });

  final _KidAvatarOption option;
  final double radius;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final double d = radius * 2;
    final double emojiSize = radius * 1.08;
    final Color start = option.frameColor.withValues(alpha: 0.94);
    final Color end = option.accentColor.withValues(alpha: 0.9);

    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
              colors: <Color>[start, end],
            ),
          ),
          child: Center(
            child: Text(option.emoji, style: TextStyle(fontSize: emojiSize)),
          ),
        ),
      ),
    );
  }
}

class _KidLeaderboardEntry {
  const _KidLeaderboardEntry({
    required this.nickname,
    required this.stars,
    required this.avatarIndex,
  });

  final String nickname;
  final int stars;
  final int avatarIndex;
}

class _KidMenuPanel extends StatelessWidget {
  const _KidMenuPanel({
    required this.nickname,
    required this.level,
    required this.selectedAvatar,
    required this.onChooseAvatar,
    required this.onExit,
    this.inDrawer = false,
  });

  final String nickname;
  final String level;
  final _KidAvatarOption selectedAvatar;
  final VoidCallback onChooseAvatar;
  final NavigationHandler onExit;
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Container(
      color: palette.menuBackground,
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
            Divider(color: palette.menuDivider, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: palette.menuTile,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: <Widget>[
                    _CartoonAvatarGlyph(
                      option: selectedAvatar,
                      radius: 20,
                      borderColor: Colors.white,
                      borderWidth: 1.8,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            nickname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            level,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: palette.menuSubtext),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _MenuTile(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              subtitle: 'Kid home',
              onTap: () {
                if (inDrawer) {
                  Navigator.of(context).pop();
                }
              },
            ),
            _MenuTile(
              icon: Icons.emoji_emotions_outlined,
              title: 'Choose Avatar',
              subtitle: '140+ category avatars',
              onTap: onChooseAvatar,
            ),
            _MenuTile(
              icon: Icons.leaderboard_outlined,
              title: 'Leaderboard',
              subtitle: 'Top demo kids',
              onTap: () {
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
                  backgroundColor: palette.error,
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

class _SubjectLearningPathScreen extends StatefulWidget {
  const _SubjectLearningPathScreen({
    required this.subjectName,
    required this.kidId,
    required this.kidLevel,
  });

  final String subjectName;
  final String kidId;
  final String kidLevel;

  @override
  State<_SubjectLearningPathScreen> createState() =>
      _SubjectLearningPathScreenState();
}

class _SubjectLearningPathScreenState
    extends State<_SubjectLearningPathScreen> {
  static const String _kidProgressPrefix = 'learnova.kid.progress';

  int _unlockedStage = 1;
  Set<int> _completedStages = <int>{};
  int _totalStars = 0;
  bool _loading = true;

  IconData _subjectIcon() {
    final String name = widget.subjectName.toLowerCase();
    if (name.contains('english')) {
      return Icons.menu_book_rounded;
    }
    if (name.contains('math')) {
      return Icons.calculate_rounded;
    }
    return Icons.lightbulb_rounded;
  }

  _SubjectKind _subjectKind() {
    final String name = widget.subjectName.toLowerCase();
    if (name.contains('english')) {
      return _SubjectKind.english;
    }
    if (name.contains('math')) {
      return _SubjectKind.math;
    }
    return _SubjectKind.gk;
  }

  bool get _isLevelOne {
    return widget.kidLevel.toLowerCase().contains('level 1');
  }

  String _subjectSlug(_SubjectKind kind) {
    return switch (kind) {
      _SubjectKind.english => 'english',
      _SubjectKind.math => 'math',
      _SubjectKind.gk => 'gk',
    };
  }

  String _subjectKey(_SubjectKind kind, String suffix) {
    return '$_kidProgressPrefix.${widget.kidId}.subject.${_subjectSlug(kind)}.$suffix';
  }

  String _starsKey() {
    return '$_kidProgressPrefix.${widget.kidId}.stars';
  }

  String _reportKey(String suffix) {
    return '$_kidProgressPrefix.${widget.kidId}.report.$suffix';
  }

  Future<void> _loadProgress() async {
    final _SubjectKind kind = _subjectKind();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int unlocked = max(
      1,
      prefs.getInt(_subjectKey(kind, 'unlocked')) ?? 1,
    );
    final List<String> completedRaw =
        prefs.getStringList(_subjectKey(kind, 'completed')) ?? <String>[];
    final Set<int> completed = completedRaw
        .map(int.tryParse)
        .whereType<int>()
        .where((int stage) => stage >= 1)
        .toSet();
    final int stars = prefs.getInt(_starsKey()) ?? 0;

    if (!mounted) {
      return;
    }
    setState(() {
      _unlockedStage = unlocked;
      _completedStages = completed;
      _totalStars = stars;
      _loading = false;
    });
  }

  Future<void> _saveProgress({
    required _SubjectKind kind,
    required int unlocked,
    required Set<int> completed,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_subjectKey(kind, 'unlocked'), unlocked);
    final List<int> sortedCompleted = completed.toList()..sort();
    await prefs.setStringList(
      _subjectKey(kind, 'completed'),
      sortedCompleted.map((int stage) => '$stage').toList(),
    );
  }

  List<_QuizQuestion> _quizBank(_SubjectKind kind) {
    switch (kind) {
      case _SubjectKind.english:
        return const <_QuizQuestion>[
          _QuizQuestion(
            prompt: 'Which letter starts "Apple"?',
            options: <String>['A', 'B', 'C', 'D'],
            correctIndex: 0,
            explanation: 'Apple begins with the letter A sound.',
          ),
          _QuizQuestion(
            prompt: 'Which one is a vowel?',
            options: <String>['B', 'E', 'R', 'T'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Pick the small letter of B.',
            options: <String>['d', 'p', 'b', 'h'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'Which word begins with C?',
            options: <String>['Sun', 'Cat', 'Ball', 'Egg'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'How many letters are in "DOG"?',
            options: <String>['2', '3', '4', '5'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Pick a rhyming word for "hat".',
            options: <String>['mat', 'sun', 'top', 'bed'],
            correctIndex: 0,
          ),
          _QuizQuestion(
            prompt: 'Which letter comes after M?',
            options: <String>['L', 'N', 'P', 'K'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Which is a greeting word?',
            options: <String>['Hello', 'Stone', 'Chair', 'Spoon'],
            correctIndex: 0,
          ),
          _QuizQuestion(
            prompt: 'Choose the correct spelling.',
            options: <String>['Bok', 'Book', 'Buk', 'Booc'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Which one is a sentence starter?',
            options: <String>['!', 'A capital letter', 'A number', 'A comma'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Pick the picture word for "pet".',
            options: <String>['Dog', 'Table', 'Road', 'Cloud'],
            correctIndex: 0,
          ),
          _QuizQuestion(
            prompt: 'Which one is not a letter?',
            options: <String>['G', 'H', '7', 'J'],
            correctIndex: 2,
          ),
        ];
      case _SubjectKind.math:
        return const <_QuizQuestion>[
          _QuizQuestion(
            prompt: 'What is 2 + 1?',
            options: <String>['1', '2', '3', '4'],
            correctIndex: 2,
            explanation: 'Adding one more to two gives three.',
          ),
          _QuizQuestion(
            prompt: 'What is 5 - 2?',
            options: <String>['2', '3', '4', '5'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Which number is bigger?',
            options: <String>['4', '9', '3', '2'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'What comes after 7?',
            options: <String>['6', '8', '9', '5'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'How many sides does a triangle have?',
            options: <String>['2', '3', '4', '5'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'What is 10 - 1?',
            options: <String>['7', '8', '9', '10'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'Count: 1, 2, 3, __',
            options: <String>['4', '5', '6', '2'],
            correctIndex: 0,
          ),
          _QuizQuestion(
            prompt: 'What is 3 + 3?',
            options: <String>['5', '6', '7', '8'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Which shape is round?',
            options: <String>['Square', 'Triangle', 'Circle', 'Rectangle'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'What is 4 + 2?',
            options: <String>['4', '5', '6', '7'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'What is 8 - 3?',
            options: <String>['4', '5', '6', '7'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'How many fingers on one hand?',
            options: <String>['4', '5', '6', '7'],
            correctIndex: 1,
          ),
        ];
      case _SubjectKind.gk:
        return const <_QuizQuestion>[
          _QuizQuestion(
            prompt: 'Which animal says "meow"?',
            options: <String>['Dog', 'Cat', 'Cow', 'Duck'],
            correctIndex: 1,
            explanation: 'Cats make the meow sound.',
          ),
          _QuizQuestion(
            prompt: 'What color is the sun often drawn as?',
            options: <String>['Blue', 'Green', 'Yellow', 'Black'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'Which one can fly?',
            options: <String>['Bird', 'Fish', 'Cow', 'Goat'],
            correctIndex: 0,
          ),
          _QuizQuestion(
            prompt: 'Where do fish live?',
            options: <String>['Sky', 'Water', 'Tree', 'Road'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'How many days are in a week?',
            options: <String>['5', '6', '7', '8'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'Which season is very cold?',
            options: <String>['Summer', 'Winter', 'Spring', 'Rainy'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'What do we use to see things?',
            options: <String>['Ears', 'Nose', 'Eyes', 'Hands'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'Which planet do we live on?',
            options: <String>['Mars', 'Venus', 'Earth', 'Jupiter'],
            correctIndex: 2,
          ),
          _QuizQuestion(
            prompt: 'Which one is a fruit?',
            options: <String>['Carrot', 'Apple', 'Potato', 'Onion'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Who helps us learn in school?',
            options: <String>['Pilot', 'Teacher', 'Chef', 'Driver'],
            correctIndex: 1,
          ),
          _QuizQuestion(
            prompt: 'Which is a transport?',
            options: <String>['Bus', 'Tree', 'Book', 'Pencil'],
            correctIndex: 0,
          ),
          _QuizQuestion(
            prompt: 'What do bees make?',
            options: <String>['Honey', 'Milk', 'Juice', 'Bread'],
            correctIndex: 0,
          ),
        ];
    }
  }

  List<_LectureSlide> _buildSlides({
    required List<String> titles,
    required List<String> bodies,
    required List<String> examples,
    required List<IconData> icons,
    required List<Color> colors,
  }) {
    const List<String> phases = <String>['Basics', 'Practice', 'Challenge'];
    final List<_LectureSlide> slides = <_LectureSlide>[];
    for (int round = 0; round < 3; round++) {
      for (int i = 0; i < titles.length; i++) {
        final String roundHint = switch (round) {
          0 => 'Learn and repeat slowly.',
          1 => 'Try this with confidence.',
          _ => 'You are getting stronger. Keep going.',
        };
        slides.add(
          _LectureSlide(
            title: '${titles[i]} - ${phases[round]}',
            body: '${bodies[i]} $roundHint',
            example: examples[i],
            icon: icons[(i + round) % icons.length],
            accentColor: colors[(i + round) % colors.length],
          ),
        );
      }
    }
    return slides;
  }

  List<_LectureSlide> _englishSlides() {
    return _buildSlides(
      titles: const <String>[
        'Letter Sounds',
        'Vowel Friends',
        'Blend Letters',
        'Read Small Words',
        'Capital Start',
        'Rhyming Words',
        'Word Families',
        'Sentence Sense',
        'Listening Skills',
        'Daily Reading',
      ],
      bodies: const <String>[
        'Say each letter sound clearly and match it with a word.',
        'A, E, I, O, U help words sound complete.',
        'Blend two and three sounds to read short words.',
        'Read simple CVC words from left to right.',
        'Use capital letters at the start of names and sentences.',
        'Rhyming words share ending sounds.',
        'Word families help us read many words quickly.',
        'A sentence should begin correctly and make full sense.',
        'Listen carefully before choosing a word.',
        'Practice reading every day to become faster.',
      ],
      examples: const <String>[
        'A says /a/ in apple',
        'bed, pin, hot, sun',
        'c + a + t = cat',
        'cat, dog, red, box',
        'Ali reads books.',
        'cat, hat, bat',
        '-at: cat, bat, mat',
        'I play with a ball.',
        'Listen and point to word',
        'Read 5 words before sleep',
      ],
      icons: const <IconData>[
        Icons.auto_stories_rounded,
        Icons.record_voice_over_rounded,
        Icons.merge_type_rounded,
        Icons.menu_book_rounded,
        Icons.text_fields_rounded,
        Icons.music_note_rounded,
        Icons.extension_rounded,
        Icons.notes_rounded,
        Icons.hearing_rounded,
        Icons.check_circle_rounded,
      ],
      colors: const <Color>[
        Color(0xFF4BB9FF),
        Color(0xFF58CC02),
        Color(0xFFFFB84B),
        Color(0xFF7B6BFF),
        Color(0xFFFF7F9D),
      ],
    );
  }

  List<_LectureSlide> _mathSlides() {
    return _buildSlides(
      titles: const <String>[
        'Counting Objects',
        'Compare Numbers',
        'Addition Intro',
        'Subtraction Intro',
        'Number Order',
        'Shape Time',
        'More Or Less',
        'Math In Life',
        'Check Answers',
        'Speed Practice',
      ],
      bodies: const <String>[
        'Count objects one by one and touch each object once.',
        'Find which number is bigger and which is smaller.',
        'Addition joins groups together.',
        'Subtraction takes objects away.',
        'Put numbers in correct ascending order.',
        'Identify circle, square, triangle and rectangle.',
        'Use groups to see more and less.',
        'Use math while shopping, sharing, and playing.',
        'Verify your answer with fingers or drawings.',
        'Practice short questions to improve speed.',
      ],
      examples: const <String>[
        '1, 2, 3, 4 toys',
        '9 is bigger than 4',
        '2 + 3 = 5',
        '7 - 2 = 5',
        '1, 2, 3, 4, 5',
        'Triangle has 3 sides',
        '8 marbles is more than 5',
        '2 apples + 1 apple = 3',
        'Draw dots to confirm answer',
        '5 quick sums in 1 minute',
      ],
      icons: const <IconData>[
        Icons.pin_rounded,
        Icons.compare_arrows_rounded,
        Icons.add_circle_rounded,
        Icons.remove_circle_rounded,
        Icons.format_list_numbered_rounded,
        Icons.change_history_rounded,
        Icons.bar_chart_rounded,
        Icons.shopping_basket_rounded,
        Icons.lightbulb_rounded,
        Icons.timer_rounded,
      ],
      colors: const <Color>[
        Color(0xFFFFA338),
        Color(0xFF58CC02),
        Color(0xFF1CB0F6),
        Color(0xFF8E7CFF),
        Color(0xFFFF7F9D),
      ],
    );
  }

  List<_LectureSlide> _gkSlides() {
    return _buildSlides(
      titles: const <String>[
        'Our Planet Earth',
        'Animals Around',
        'Birds And Sky',
        'Plants And Trees',
        'Water And Weather',
        'Safe Habits',
        'People Who Help',
        'Healthy Choices',
        'Transport World',
        'Curious Questions',
      ],
      bodies: const <String>[
        'Earth is our home where people, animals, and plants live.',
        'Animals live in different places and eat different foods.',
        'Birds use wings and live in nests.',
        'Plants need water, air, and sunlight.',
        'Weather changes between sunny, rainy, and cloudy days.',
        'Follow simple rules to stay safe at home and school.',
        'Many people help us in daily life.',
        'Healthy food and habits keep our body strong.',
        'Transport helps us move from one place to another.',
        'Ask questions to learn new things every day.',
      ],
      examples: const <String>[
        'Earth has land and water',
        'Fish in water, lion on land',
        'Bird flies in sky',
        'Water the plant daily',
        'Carry umbrella when raining',
        'Wash hands before eating',
        'Teacher, doctor, firefighter',
        'Eat fruits and drink water',
        'Bus, car, bike, train',
        'Why do stars shine at night?',
      ],
      icons: const <IconData>[
        Icons.public_rounded,
        Icons.pets_rounded,
        Icons.flutter_dash_rounded,
        Icons.eco_rounded,
        Icons.cloud_rounded,
        Icons.health_and_safety_rounded,
        Icons.groups_rounded,
        Icons.favorite_rounded,
        Icons.directions_bus_rounded,
        Icons.travel_explore_rounded,
      ],
      colors: const <Color>[
        Color(0xFF4BB9FF),
        Color(0xFF58CC02),
        Color(0xFFFFB84B),
        Color(0xFF7A6FFF),
        Color(0xFFFF7F9D),
      ],
    );
  }

  _LectureModule _lectureModule(_SubjectKind kind) {
    switch (kind) {
      case _SubjectKind.english:
        return _LectureModule(
          title: 'English Lecture 1',
          slides: _englishSlides(),
        );
      case _SubjectKind.math:
        return _LectureModule(title: 'Math Lecture 1', slides: _mathSlides());
      case _SubjectKind.gk:
        return _LectureModule(title: 'GK Lecture 1', slides: _gkSlides());
    }
  }

  Future<void> _openStageOneLecture() async {
    final _SubjectKind kind = _subjectKind();
    final _LectureQuizResult? result = await Navigator.of(context)
        .push<_LectureQuizResult>(
          MaterialPageRoute<_LectureQuizResult>(
            builder: (BuildContext context) {
              return _SubjectLectureScreen(
                subjectName: widget.subjectName,
                module: _lectureModule(kind),
                quizBank: _quizBank(kind),
              );
            },
          ),
        );

    if (result == null) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final _SubjectKind subjectKind = _subjectKind();
    await prefs.setInt(_subjectKey(subjectKind, 'stage_1_stars'), result.score);

    int recalculatedStars = 0;
    final String subjectPrefix = '$_kidProgressPrefix.${widget.kidId}.subject.';
    for (final String key in prefs.getKeys()) {
      if (!key.startsWith(subjectPrefix) || !key.endsWith('_stars')) {
        continue;
      }
      recalculatedStars += prefs.getInt(key) ?? 0;
    }
    await prefs.setInt(_starsKey(), recalculatedStars);

    final int testsTaken = (prefs.getInt(_reportKey('tests_taken')) ?? 0) + 1;
    await prefs.setInt(_reportKey('tests_taken'), testsTaken);
    final int highestMark = max(
      prefs.getInt(_reportKey('highest_mark')) ?? 0,
      result.score,
    );
    await prefs.setInt(_reportKey('highest_mark'), highestMark);
    final List<String> attempts = List<String>.from(
      prefs.getStringList(_reportKey('attempts')) ?? <String>[],
    );
    final DateTime attemptTime = DateTime.now().toUtc();
    attempts.add(
      '${attemptTime.toIso8601String()}|${_subjectSlug(subjectKind)}|${result.score}|${result.passed ? 1 : 0}',
    );
    if (attempts.length > 160) {
      attempts.removeRange(0, attempts.length - 160);
    }
    await prefs.setStringList(_reportKey('attempts'), attempts);

    final List<Map<String, dynamic>> mistakeMaps = result.mistakes.map((
      _QuizMistake mistake,
    ) {
      final String selectedAnswer =
          mistake.selectedIndex >= 0 &&
              mistake.selectedIndex < mistake.question.options.length
          ? mistake.question.options[mistake.selectedIndex]
          : '';
      final String correctAnswer =
          mistake.question.options[mistake.question.correctIndex];
      return <String, dynamic>{
        'prompt': mistake.question.prompt,
        'selected': selectedAnswer,
        'correct': correctAnswer,
        'explanation': mistake.question.explanation,
      };
    }).toList();
    final List<String> attemptJson = List<String>.from(
      prefs.getStringList(_reportKey('attempts_json')) ?? <String>[],
    );
    attemptJson.add(
      jsonEncode(<String, dynamic>{
        'timestamp': attemptTime.toIso8601String(),
        'subject': _subjectSlug(subjectKind),
        'stage': 1,
        'score': result.score,
        'total': result.totalQuestions,
        'passed': result.passed,
        'mistakes': mistakeMaps,
      }),
    );
    if (attemptJson.length > 160) {
      attemptJson.removeRange(0, attemptJson.length - 160);
    }
    await prefs.setStringList(_reportKey('attempts_json'), attemptJson);

    int updatedUnlocked = _unlockedStage;
    Set<int> updatedCompleted = _completedStages;
    if (result.passed) {
      updatedCompleted = <int>{..._completedStages, 1};
      updatedUnlocked = max(_unlockedStage, 2);
      await _saveProgress(
        kind: subjectKind,
        unlocked: updatedUnlocked,
        completed: updatedCompleted,
      );
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _completedStages = updatedCompleted;
      _unlockedStage = updatedUnlocked;
      _totalStars = recalculatedStars;
    });

    final String message = result.passed
        ? 'Passed with ${result.score}/10. Next lecture unlocked. Stars updated to $recalculatedStars.'
        : 'Score ${result.score}/10. Need 6/10 to unlock next lecture. Stars updated to $recalculatedStars.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onTapStage(int stage) {
    if (stage > _unlockedStage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stage $stage is locked. Complete previous stage first.',
          ),
        ),
      );
      return;
    }

    if (!_isLevelOne) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Level-based lectures are coming. Level 1 lecture flow is live now.',
          ),
        ),
      );
      return;
    }

    if (stage == 1) {
      _openStageOneLecture();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Stage $stage is unlocked. Lecture content for this stage will be added next.',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final _SubjectKind subjectKind = _subjectKind();

    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectName)),
      body: Stack(
        children: <Widget>[
          _PlayfulPathBackground(kind: subjectKind),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                palette.brandPrimary,
                                Color.alphaBlend(
                                  Colors.black.withValues(alpha: 0.08),
                                  palette.brandPrimary,
                                ),
                              ],
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: palette.brandPrimary.withValues(
                                  alpha: 0.22,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
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
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                    child: Icon(
                                      _subjectIcon(),
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.subjectName,
                                      style: GoogleFonts.fredoka(
                                        fontSize: 31,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Play Path 1 to 10',
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: <Widget>[
                                  _PathInfoChip(
                                    icon: Icons.lock_open_rounded,
                                    text: 'Unlocked: $_unlockedStage / 10',
                                  ),
                                  _PathInfoChip(
                                    icon: Icons.star_rounded,
                                    text: 'Stars: $_totalStars',
                                  ),
                                  _PathInfoChip(
                                    icon: Icons.workspace_premium_rounded,
                                    text: _isLevelOne
                                        ? 'Level 1 lecture + quiz ready'
                                        : 'Level 1 module currently active',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _LearningPathMap(
                          subjectKind: subjectKind,
                          totalStages: 10,
                          unlockedStage: _unlockedStage,
                          completedStages: _completedStages,
                          onTapStage: _onTapStage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LectureModule {
  const _LectureModule({required this.title, required this.slides});

  final String title;
  final List<_LectureSlide> slides;
}

class _LectureSlide {
  const _LectureSlide({
    required this.title,
    required this.body,
    required this.example,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String body;
  final String example;
  final IconData icon;
  final Color accentColor;
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class _QuizMistake {
  const _QuizMistake({required this.question, required this.selectedIndex});

  final _QuizQuestion question;
  final int selectedIndex;
}

class _LectureQuizResult {
  const _LectureQuizResult({
    required this.score,
    required this.passed,
    required this.totalQuestions,
    required this.mistakes,
  });

  final int score;
  final bool passed;
  final int totalQuestions;
  final List<_QuizMistake> mistakes;
}

class _SubjectLectureScreen extends StatefulWidget {
  const _SubjectLectureScreen({
    required this.subjectName,
    required this.module,
    required this.quizBank,
  });

  final String subjectName;
  final _LectureModule module;
  final List<_QuizQuestion> quizBank;

  @override
  State<_SubjectLectureScreen> createState() => _SubjectLectureScreenState();
}

class _SubjectLectureScreenState extends State<_SubjectLectureScreen> {
  final FlutterTts _tts = FlutterTts();
  final Random _random = Random();
  final PageController _pageController = PageController();

  int _slideIndex = 0;
  bool _speaking = false;
  bool _openingQuiz = false;
  String _lastQuizSignature = '';

  Future<void> _configureTts() async {
    _tts.setCompletionHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _speaking = false;
      });
    });
    _tts.setCancelHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _speaking = false;
      });
    });
    _tts.setErrorHandler((dynamic message) {
      if (!mounted) {
        return;
      }
      setState(() {
        _speaking = false;
      });
    });

    try {
      await _tts.setLanguage('en-US');
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.45);
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {}
  }

  String _slideNarration() {
    final _LectureSlide slide = widget.module.slides[_slideIndex];
    return '${slide.title}. ${slide.body}. Example: ${slide.example}.';
  }

  Future<void> _stopVoice() async {
    try {
      await _tts.stop();
    } catch (_) {}
    if (!mounted) {
      return;
    }
    if (_speaking) {
      setState(() {
        _speaking = false;
      });
    }
  }

  Future<void> _playVoice() async {
    try {
      await _stopVoice();
      if (!mounted) {
        return;
      }
      setState(() {
        _speaking = true;
      });
      await _tts.speak(_slideNarration());
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _speaking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice is not available on this device.')),
      );
    }
  }

  List<_QuizQuestion> _randomQuizSet() {
    if (widget.quizBank.length <= 10) {
      final List<_QuizQuestion> fallback = List<_QuizQuestion>.from(
        widget.quizBank,
      )..shuffle(_random);
      return fallback;
    }

    List<_QuizQuestion> selected = <_QuizQuestion>[];
    String signature = '';
    for (int attempt = 0; attempt < 6; attempt++) {
      final List<_QuizQuestion> shuffled = List<_QuizQuestion>.from(
        widget.quizBank,
      )..shuffle(_random);
      selected = shuffled.take(10).toList();
      signature = selected.map((q) => q.prompt).join('|');
      if (signature != _lastQuizSignature) {
        break;
      }
    }
    _lastQuizSignature = signature;
    return selected;
  }

  Future<void> _startQuiz() async {
    if (_openingQuiz) {
      return;
    }
    await _stopVoice();
    if (!mounted) {
      return;
    }
    setState(() {
      _openingQuiz = true;
    });

    final _LectureQuizResult? result = await Navigator.of(context)
        .push<_LectureQuizResult>(
          MaterialPageRoute<_LectureQuizResult>(
            builder: (BuildContext context) {
              return _SubjectQuizScreen(
                subjectName: widget.subjectName,
                questions: _randomQuizSet(),
              );
            },
          ),
        );

    if (!mounted) {
      return;
    }
    setState(() {
      _openingQuiz = false;
    });

    if (result == null) {
      return;
    }
    Navigator.of(context).pop(result);
  }

  void _goPreviousSlide() {
    if (_slideIndex == 0) {
      return;
    }
    _stopVoice();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _goNextOrQuiz() async {
    final bool isLast = _slideIndex == widget.module.slides.length - 1;
    if (!isLast) {
      await _stopVoice();
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    await _startQuiz();
  }

  Widget _buildSlideCard(
    _LectureSlide slide,
    LearnovaPalette palette, {
    required int slideNumber,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.white.withValues(alpha: 0.98),
            palette.surfaceSoft.withValues(alpha: 0.94),
          ],
        ),
        border: Border.all(color: palette.borderSoft.withValues(alpha: 0.9)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: slide.accentColor.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      slide.accentColor.withValues(alpha: 0.95),
                      slide.accentColor.withValues(alpha: 0.72),
                    ],
                  ),
                ),
                child: Icon(slide.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  slide.title,
                  style: GoogleFonts.fredoka(
                    fontSize: 30,
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _TeachingMascotCoach(
            subjectName: widget.subjectName,
            slideNumber: slideNumber,
            accentColor: slide.accentColor,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: slide.accentColor.withValues(alpha: 0.14),
            ),
            child: Text(
              slide.body,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              border: Border.all(
                color: slide.accentColor.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.tips_and_updates_rounded,
                  size: 18,
                  color: slide.accentColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    slide.example,
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final bool isLastSlide = _slideIndex == widget.module.slides.length - 1;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.subjectName} Lecture 1')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                    decoration: _cardDecoration(context),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.module.title,
                            style: GoogleFonts.fredoka(
                              fontSize: 26,
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: palette.brandPrimary.withValues(alpha: 0.16),
                          ),
                          child: Text(
                            'Slide ${_slideIndex + 1}/${widget.module.slides.length}',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.module.slides.length,
                      onPageChanged: (int value) {
                        _tts.stop();
                        setState(() {
                          _slideIndex = value;
                          _speaking = false;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _buildSlideCard(
                          widget.module.slides[index],
                          palette,
                          slideNumber: index,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Lecture progress',
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              (_slideIndex + 1) /
                              max(widget.module.slides.length, 1),
                          minHeight: 11,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _slideIndex == 0 ? null : _goPreviousSlide,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _speaking ? _stopVoice : _playVoice,
                          icon: Icon(
                            _speaking
                                ? Icons.stop_circle_rounded
                                : Icons.volume_up_rounded,
                          ),
                          label: Text(
                            _speaking ? 'Stop Voice' : 'Play This Slide',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openingQuiz ? null : _goNextOrQuiz,
                          icon: Icon(
                            isLastSlide
                                ? Icons.quiz_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                          label: Text(
                            _openingQuiz
                                ? 'Opening...'
                                : isLastSlide
                                ? 'Start Quiz (10)'
                                : 'Next Slide',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pass rule: score at least 6 out of 10 to unlock next lecture.',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
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

class _TeachingMascotCoach extends StatelessWidget {
  const _TeachingMascotCoach({
    required this.subjectName,
    required this.slideNumber,
    required this.accentColor,
  });

  final String subjectName;
  final int slideNumber;
  final Color accentColor;

  String _coachLine() {
    final String subject = subjectName.toLowerCase();
    if (subject.contains('english')) {
      const List<String> lines = <String>[
        'Let us sound it out together.',
        'Great! Read this line with me.',
        'Try saying this word clearly.',
        'Nice! Spot the letter pattern.',
      ];
      return lines[slideNumber % lines.length];
    }
    if (subject.contains('math')) {
      const List<String> lines = <String>[
        'Count with me step by step.',
        'Awesome! Let us solve it slowly.',
        'You can do this sum.',
        'Great job, now one more!',
      ];
      return lines[slideNumber % lines.length];
    }
    const List<String> lines = <String>[
      'Let us explore this fact together.',
      'Nice! Remember this fun idea.',
      'You are learning fast!',
      'Great thinking, keep going!',
    ];
    return lines[slideNumber % lines.length];
  }

  IconData _coachIcon() {
    final String subject = subjectName.toLowerCase();
    if (subject.contains('english')) {
      return Icons.menu_book_rounded;
    }
    if (subject.contains('math')) {
      return Icons.calculate_rounded;
    }
    return Icons.public_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final bool leftMascot = slideNumber.isEven;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      child: Container(
        key: ValueKey<int>(slideNumber),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: accentColor.withValues(alpha: 0.12),
          border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: <Widget>[
            if (leftMascot) ...<Widget>[
              _AnimatedCatTeacher(
                accentColor: accentColor,
                moodIndex: slideNumber,
                icon: _coachIcon(),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Teacher Cat',
                    style: GoogleFonts.fredoka(
                      color: palette.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _coachLine(),
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            if (!leftMascot) ...<Widget>[
              const SizedBox(width: 10),
              _AnimatedCatTeacher(
                accentColor: accentColor,
                moodIndex: slideNumber,
                icon: _coachIcon(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedCatTeacher extends StatelessWidget {
  const _AnimatedCatTeacher({
    required this.accentColor,
    required this.moodIndex,
    required this.icon,
  });

  final Color accentColor;
  final int moodIndex;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool wink = moodIndex % 3 == 1;
    final bool smile = moodIndex % 4 != 2;
    final bool tilted = moodIndex.isOdd;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (BuildContext context, double value, Widget? child) {
        final double bob = sin(value * pi) * 3;
        return Transform.translate(
          offset: Offset(0, -bob),
          child: Transform.rotate(angle: tilted ? -0.04 : 0.04, child: child),
        );
      },
      child: SizedBox(
        width: 78,
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              top: 6,
              left: 7,
              child: Transform.rotate(
                angle: -0.35,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC48A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 7,
              child: Transform.rotate(
                angle: 0.35,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC48A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              top: 14,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      const Color(0xFFFFDCB4),
                      const Color(0xFFFFB97F),
                    ],
                  ),
                  border: Border.all(color: Colors.white, width: 1.3),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 34,
              child: Container(
                width: wink ? 4 : 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2B2B2B),
                ),
              ),
            ),
            Positioned(
              right: 24,
              top: 34,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2B2B2B),
                ),
              ),
            ),
            Positioned(
              left: 32,
              right: 32,
              top: 43,
              child: Container(
                width: 8,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8876D),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              left: 26,
              right: 26,
              top: 51,
              child: Container(
                height: smile ? 5 : 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              right: -4,
              top: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.95),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectQuizScreen extends StatefulWidget {
  const _SubjectQuizScreen({
    required this.subjectName,
    required this.questions,
  });

  final String subjectName;
  final List<_QuizQuestion> questions;

  @override
  State<_SubjectQuizScreen> createState() => _SubjectQuizScreenState();
}

class _SubjectQuizScreenState extends State<_SubjectQuizScreen> {
  int _index = 0;
  int _score = 0;
  int? _selectedOption;
  bool _answered = false;
  final List<_QuizMistake> _mistakes = <_QuizMistake>[];

  bool get _finished {
    return _index >= widget.questions.length;
  }

  _QuizQuestion get _currentQuestion {
    return widget.questions[_index];
  }

  void _chooseOption(int optionIndex) {
    if (_answered || _finished) {
      return;
    }

    setState(() {
      _selectedOption = optionIndex;
    });
  }

  void _checkAnswer() {
    if (_answered || _finished || _selectedOption == null) {
      return;
    }

    final _QuizQuestion question = _currentQuestion;
    final bool correct = _selectedOption == question.correctIndex;
    setState(() {
      _answered = true;
      if (correct) {
        _score += 1;
      } else {
        _mistakes.add(
          _QuizMistake(question: question, selectedIndex: _selectedOption!),
        );
      }
    });
  }

  void _finishQuiz() {
    final bool passed = _score >= 6;
    Navigator.of(context).pop(
      _LectureQuizResult(
        score: _score,
        passed: passed,
        totalQuestions: widget.questions.length,
        mistakes: List<_QuizMistake>.from(_mistakes),
      ),
    );
  }

  String _explanationText(_QuizQuestion question) {
    if (question.explanation.trim().isNotEmpty) {
      return question.explanation;
    }
    final String correctText = question.options[question.correctIndex];
    return 'Because "$correctText" is the right answer for this question.';
  }

  void _nextQuestion() {
    if (!_answered || _finished) {
      return;
    }
    final bool isLast = _index == widget.questions.length - 1;
    if (isLast) {
      setState(() {
        _index += 1;
      });
      return;
    }

    setState(() {
      _index += 1;
      _selectedOption = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    if (_finished) {
      final bool passed = _score >= 6;
      return Scaffold(
        appBar: AppBar(title: Text('${widget.subjectName} Quiz')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: _cardDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        passed
                            ? Icons.emoji_events_rounded
                            : Icons.refresh_rounded,
                        size: 54,
                        color: passed ? palette.success : palette.brandAccent,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        passed ? 'Great Work!' : 'Try Again',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 30,
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Score: $_score / ${widget.questions.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stars earned this attempt: $_score',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        passed
                            ? 'You unlocked the next lecture.'
                            : 'You need at least 6/${widget.questions.length} to unlock next lecture.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Mistakes Review',
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_mistakes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFE9F8D7),
                          ),
                          child: const Text(
                            'Perfect run! No mistakes in this quiz.',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )
                      else
                        for (int i = 0; i < _mistakes.length; i++) ...<Widget>[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xFFFFF6E5),
                              border: Border.all(
                                color: const Color(0xFFFFE0B1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${i + 1}. ${_mistakes[i].question.prompt}',
                                  style: TextStyle(
                                    color: palette.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your answer: ${_mistakes[i].question.options[_mistakes[i].selectedIndex]}',
                                  style: const TextStyle(
                                    color: Color(0xFFC54A38),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Correct answer: ${_mistakes[i].question.options[_mistakes[i].question.correctIndex]}',
                                  style: const TextStyle(
                                    color: Color(0xFF2D8A42),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _explanationText(_mistakes[i].question),
                                  style: TextStyle(
                                    color: palette.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i != _mistakes.length - 1)
                            const SizedBox(height: 8),
                        ],
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _finishQuiz,
                          icon: Icon(
                            passed
                                ? Icons.arrow_forward_rounded
                                : Icons.menu_book_rounded,
                          ),
                          label: Text(passed ? 'Continue' : 'Back To Lecture'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final _QuizQuestion question = _currentQuestion;
    final bool reveal = _answered && _selectedOption != null;
    final bool selectedIsCorrect =
        _selectedOption != null && _selectedOption == question.correctIndex;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.subjectName} Quiz')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Question ${_index + 1} of ${widget.questions.length}',
                                style: TextStyle(
                                  color: palette.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.favorite_rounded,
                                  size: 19,
                                  color: const Color(0xFFFF5A5A),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Focus',
                                  style: TextStyle(
                                    color: palette.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: (_index + 1) / widget.questions.length,
                          minHeight: 11,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: palette.brandPrimary.withValues(alpha: 0.12),
                      border: Border.all(
                        color: palette.brandPrimary.withValues(alpha: 0.34),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        _AnimatedCatTeacher(
                          accentColor: palette.brandPrimary,
                          moodIndex: _index,
                          icon: Icons.school_rounded,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reveal
                                ? (selectedIsCorrect
                                      ? 'Nice one! Tap continue.'
                                      : 'Good try! Read why and continue.')
                                : 'Teacher Cat says: choose your answer, then tap CHECK.',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(context),
                    child: Text(
                      question.prompt,
                      style: GoogleFonts.fredoka(
                        fontSize: 30,
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int optionIndex) {
                        final bool picked = _selectedOption == optionIndex;
                        final bool correct =
                            optionIndex == question.correctIndex;

                        Color tileColor = palette.surfaceSoft;
                        Color borderColor = palette.borderStrong;
                        if (reveal && correct) {
                          tileColor = const Color(0xFFE6F9D8);
                          borderColor = const Color(0xFF67C63A);
                        } else if (reveal && picked && !correct) {
                          tileColor = const Color(0xFFFFE2E2);
                          borderColor = const Color(0xFFE26868);
                        } else if (picked) {
                          tileColor = palette.brandPrimary.withValues(
                            alpha: 0.14,
                          );
                          borderColor = palette.brandPrimary;
                        }

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _answered
                                ? null
                                : () => _chooseOption(optionIndex),
                            child: Ink(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: tileColor,
                                border: Border.all(
                                  color: borderColor,
                                  width: 1.8,
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: borderColor,
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + optionIndex),
                                        style: TextStyle(
                                          color: palette.textSecondary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: Text(
                                      question.options[optionIndex],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: palette.textPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  if (reveal && correct)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF55B629),
                                    ),
                                  if (reveal && picked && !correct)
                                    const Icon(
                                      Icons.cancel_rounded,
                                      color: Color(0xFFE04F4F),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_answered)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: selectedIsCorrect
                            ? const Color(0xFFE7F9D8)
                            : const Color(0xFFFFEFE4),
                        border: Border.all(
                          color: selectedIsCorrect
                              ? const Color(0xFF6BC64A)
                              : const Color(0xFFFFBA8B),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            selectedIsCorrect
                                ? 'Correct! ${question.options[question.correctIndex]}'
                                : 'Correct answer: ${question.options[question.correctIndex]}',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _explanationText(question),
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _answered
                          ? _nextQuestion
                          : (_selectedOption == null ? null : _checkAnswer),
                      icon: Icon(
                        _answered
                            ? (_index == widget.questions.length - 1
                                  ? Icons.done_rounded
                                  : Icons.navigate_next_rounded)
                            : Icons.check_rounded,
                      ),
                      label: Text(
                        _answered
                            ? (_index == widget.questions.length - 1
                                  ? 'Finish Quiz'
                                  : 'Continue')
                            : 'Check',
                      ),
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

class _PathInfoChip extends StatelessWidget {
  const _PathInfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 17, color: Colors.white),
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

enum _SubjectKind { english, math, gk }

class _PlayfulPathBackground extends StatelessWidget {
  const _PlayfulPathBackground({required this.kind});

  final _SubjectKind kind;

  List<Color> _skyColors() {
    switch (kind) {
      case _SubjectKind.english:
        return const <Color>[Color(0xFFD9F3FF), Color(0xFFBEE9FF)];
      case _SubjectKind.math:
        return const <Color>[Color(0xFFE4F8FF), Color(0xFFCFF0FF)];
      case _SubjectKind.gk:
        return const <Color>[Color(0xFFE7F9D8), Color(0xFFD7F3BE)];
    }
  }

  List<Color> _hillColors() {
    switch (kind) {
      case _SubjectKind.english:
        return const <Color>[
          Color(0xFFA6E677),
          Color(0xFF85D85A),
          Color(0xFF74C54E),
        ];
      case _SubjectKind.math:
        return const <Color>[
          Color(0xFF9EE98A),
          Color(0xFF80DB6B),
          Color(0xFF6DC759),
        ];
      case _SubjectKind.gk:
        return const <Color>[
          Color(0xFFB4EA84),
          Color(0xFF97DD69),
          Color(0xFF7CCC4A),
        ];
    }
  }

  Color _groundColor() {
    switch (kind) {
      case _SubjectKind.english:
        return const Color(0xFFF9F0BD);
      case _SubjectKind.math:
        return const Color(0xFFF8F3C7);
      case _SubjectKind.gk:
        return const Color(0xFFF5EDB4);
    }
  }

  List<Widget> _subjectTokens() {
    switch (kind) {
      case _SubjectKind.english:
        return <Widget>[
          const Positioned(
            top: 150,
            left: -2,
            child: _BgChartCard(
              glyph: 'A',
              icon: Icons.menu_book_rounded,
              colorA: Color(0xD34BC8FF),
              colorB: Color(0xD31CA9F8),
              angle: -0.09,
            ),
          ),
          const Positioned(
            top: 308,
            right: -2,
            child: _BgChartCard(
              glyph: 'B',
              icon: Icons.spellcheck_rounded,
              colorA: Color(0xD3FFB84B),
              colorB: Color(0xD3FF9E3D),
              angle: 0.08,
            ),
          ),
          const Positioned(
            top: 500,
            left: 14,
            child: _BgGiantGlyph(
              text: 'C',
              color: Color(0x3046B8FF),
              size: 112,
            ),
          ),
          const Positioned(
            top: 700,
            right: 18,
            child: _BgGiantGlyph(
              text: 'abc',
              color: Color(0x2E5FD145),
              size: 72,
            ),
          ),
          const Positioned(
            top: 430,
            right: 36,
            child: _BgStickerIcon(
              icon: Icons.edit_rounded,
              color: Color(0x334BC8FF),
              iconColor: Color(0xAA1F5F95),
            ),
          ),
          const Positioned(
            top: 694,
            left: 26,
            child: _BgStickerIcon(
              icon: Icons.menu_book_rounded,
              color: Color(0x33FFC64A),
              iconColor: Color(0xAA8B5D00),
            ),
          ),
        ];
      case _SubjectKind.math:
        return <Widget>[
          const Positioned(
            top: 160,
            right: -2,
            child: _BgChartCard(
              glyph: '+',
              icon: Icons.add_rounded,
              colorA: Color(0xD358CC02),
              colorB: Color(0xD37BCB3A),
              angle: 0.08,
            ),
          ),
          const Positioned(
            top: 312,
            left: -2,
            child: _BgChartCard(
              glyph: '10',
              icon: Icons.calculate_rounded,
              colorA: Color(0xD34CC9FF),
              colorB: Color(0xD31FB2FF),
              angle: -0.08,
            ),
          ),
          const Positioned(
            top: 500,
            right: 14,
            child: _BgGiantGlyph(
              text: '+',
              color: Color(0x2EFFB645),
              size: 118,
            ),
          ),
          const Positioned(
            top: 648,
            left: 16,
            child: _BgGiantGlyph(
              text: '=',
              color: Color(0x2F9A63FF),
              size: 104,
            ),
          ),
          const Positioned(
            top: 440,
            left: 30,
            child: _BgStickerIcon(
              icon: Icons.functions_rounded,
              color: Color(0x33FFC74C),
              iconColor: Color(0xAA8A5F00),
            ),
          ),
          const Positioned(
            top: 704,
            right: 30,
            child: _BgStickerIcon(
              icon: Icons.functions_rounded,
              color: Color(0x334BB9FF),
              iconColor: Color(0xAA1A5A92),
            ),
          ),
        ];
      case _SubjectKind.gk:
        return <Widget>[
          const Positioned(
            top: 160,
            right: -2,
            child: _BgChartCard(
              glyph: '?',
              icon: Icons.public_rounded,
              colorA: Color(0xD34BC8FF),
              colorB: Color(0xD31EA9F6),
              angle: 0.08,
            ),
          ),
          const Positioned(
            top: 316,
            left: -2,
            child: _BgChartCard(
              glyph: '!',
              icon: Icons.travel_explore_rounded,
              colorA: Color(0xD358CC02),
              colorB: Color(0xD37DC63E),
              angle: -0.09,
            ),
          ),
          const Positioned(
            top: 446,
            right: 20,
            child: _BgStickerIcon(
              icon: Icons.public_rounded,
              color: Color(0x334BB9FF),
              iconColor: Color(0xAA1E5F95),
            ),
          ),
          const Positioned(
            top: 632,
            left: 20,
            child: _BgGiantGlyph(
              text: '?',
              color: Color(0x30FFC84A),
              size: 104,
            ),
          ),
          const Positioned(
            top: 686,
            right: 28,
            child: _BgStickerIcon(
              icon: Icons.travel_explore_rounded,
              color: Color(0x3358CC02),
              iconColor: Color(0xAA2E6B08),
            ),
          ),
          const Positioned(
            top: 368,
            left: 28,
            child: _BgStickerIcon(
              icon: Icons.emoji_objects_rounded,
              color: Color(0x33FFC64A),
              iconColor: Color(0xAA8A6000),
            ),
          ),
        ];
    }
  }

  List<Widget> _subjectMascots() {
    switch (kind) {
      case _SubjectKind.english:
        return const <Widget>[
          Positioned(
            top: 418,
            left: 10,
            child: _BgAnimalBuddy(
              size: 72,
              bodyColor: Color(0x55FFB76B),
              earColor: Color(0x77FFCC8A),
              cheekColor: Color(0x99FF8A80),
              icon: Icons.menu_book_rounded,
              iconColor: Color(0xFF8B5D00),
            ),
          ),
          Positioned(
            top: 612,
            right: 10,
            child: _BgAnimalBuddy(
              size: 70,
              bodyColor: Color(0x554BC8FF),
              earColor: Color(0x776BD6FF),
              cheekColor: Color(0x99FFAFCC),
              icon: Icons.edit_rounded,
              iconColor: Color(0xFF1E5F95),
            ),
          ),
        ];
      case _SubjectKind.math:
        return const <Widget>[
          Positioned(
            top: 432,
            left: 10,
            child: _BgAnimalBuddy(
              size: 72,
              bodyColor: Color(0x55A9E072),
              earColor: Color(0x779EEA8A),
              cheekColor: Color(0x99FFC784),
              icon: Icons.calculate_rounded,
              iconColor: Color(0xFF2D6808),
            ),
          ),
          Positioned(
            top: 620,
            right: 12,
            child: _BgAnimalBuddy(
              size: 70,
              bodyColor: Color(0x559A63FF),
              earColor: Color(0x77B48AFF),
              cheekColor: Color(0x99FFD166),
              icon: Icons.functions_rounded,
              iconColor: Color(0xFF553D82),
            ),
          ),
        ];
      case _SubjectKind.gk:
        return const <Widget>[
          Positioned(
            top: 430,
            left: 12,
            child: _BgAnimalBuddy(
              size: 72,
              bodyColor: Color(0x554BC8FF),
              earColor: Color(0x7779DAFF),
              cheekColor: Color(0x99FFE08A),
              icon: Icons.public_rounded,
              iconColor: Color(0xFF1D5B8F),
            ),
          ),
          Positioned(
            top: 622,
            right: 12,
            child: _BgAnimalBuddy(
              size: 70,
              bodyColor: Color(0x5565D45A),
              earColor: Color(0x7798E68A),
              cheekColor: Color(0x99FFC784),
              icon: Icons.travel_explore_rounded,
              iconColor: Color(0xFF2F6B08),
            ),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> hills = _hillColors();
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _skyColors(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 12,
            child: _BgCloud(
              width: 102,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
          Positioned(
            top: 122,
            right: 20,
            child: _BgCloud(
              width: 78,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 132,
              decoration: BoxDecoration(
                color: _groundColor(),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.42),
                    width: 2.2,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -86,
            child: _BgHill(width: 260, height: 172, color: hills[0]),
          ),
          Positioned(
            bottom: 54,
            right: -66,
            child: _BgHill(width: 232, height: 156, color: hills[1]),
          ),
          Positioned(
            bottom: 68,
            left: 92,
            right: 94,
            child: _BgHill(width: 220, height: 132, color: hills[2]),
          ),
          Positioned(
            bottom: 108,
            left: 32,
            child: Icon(
              Icons.local_florist_rounded,
              size: 26,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          Positioned(
            bottom: 96,
            right: 42,
            child: Icon(
              Icons.star_rounded,
              size: 24,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
          ..._subjectMascots(),
          ..._subjectTokens(),
        ],
      ),
    );
  }
}

class _BgChartCard extends StatelessWidget {
  const _BgChartCard({
    required this.glyph,
    required this.icon,
    required this.colorA,
    required this.colorB,
    this.angle = -0.05,
  });

  final String glyph;
  final IconData icon;
  final Color colorA;
  final Color colorB;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 102,
        height: 102,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colorA, colorB],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorA.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.22),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    glyph,
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BgGiantGlyph extends StatelessWidget {
  const _BgGiantGlyph({
    required this.text,
    required this.color,
    this.size = 88,
  });

  final String text;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.fredoka(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BgStickerIcon extends StatelessWidget {
  const _BgStickerIcon({
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.72),
          width: 2,
        ),
      ),
      child: Icon(icon, size: 33, color: iconColor),
    );
  }
}

class _BgAnimalBuddy extends StatelessWidget {
  const _BgAnimalBuddy({
    required this.size,
    required this.bodyColor,
    required this.earColor,
    required this.cheekColor,
    required this.icon,
    required this.iconColor,
  });

  final double size;
  final Color bodyColor;
  final Color earColor;
  final Color cheekColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: 2,
            left: 12,
            child: Container(
              width: size * 0.24,
              height: size * 0.24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: earColor,
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 12,
            child: Container(
              width: size * 0.24,
              height: size * 0.24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: earColor,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: size,
              height: size * 0.86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bodyColor,
                border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
              ),
            ),
          ),
          Positioned(
            top: size * 0.38,
            left: size * 0.28,
            child: Container(
              width: size * 0.08,
              height: size * 0.08,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2E3A29),
              ),
            ),
          ),
          Positioned(
            top: size * 0.38,
            right: size * 0.28,
            child: Container(
              width: size * 0.08,
              height: size * 0.08,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2E3A29),
              ),
            ),
          ),
          Positioned(
            top: size * 0.52,
            left: size * 0.24,
            child: Container(
              width: size * 0.16,
              height: size * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cheekColor,
              ),
            ),
          ),
          Positioned(
            top: size * 0.52,
            right: size * 0.24,
            child: Container(
              width: size * 0.16,
              height: size * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cheekColor,
              ),
            ),
          ),
          Positioned(
            bottom: size * 0.14,
            left: 0,
            right: 0,
            child: Icon(icon, size: size * 0.23, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class _BgHill extends StatelessWidget {
  const _BgHill({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}

class _BgCloud extends StatelessWidget {
  const _BgCloud({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double h = width * 0.54;
    return SizedBox(
      width: width,
      height: h,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: width * 0.08,
            child: Container(
              width: width * 0.72,
              height: h * 0.56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Positioned(
            left: width * 0.04,
            bottom: h * 0.2,
            child: Container(
              width: width * 0.28,
              height: h * 0.46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Positioned(
            left: width * 0.28,
            top: 0,
            child: Container(
              width: width * 0.36,
              height: h * 0.62,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Positioned(
            right: width * 0.04,
            bottom: h * 0.14,
            child: Container(
              width: width * 0.32,
              height: h * 0.5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningPathMap extends StatelessWidget {
  const _LearningPathMap({
    required this.subjectKind,
    required this.totalStages,
    required this.unlockedStage,
    required this.completedStages,
    required this.onTapStage,
  });

  final _SubjectKind subjectKind;
  final int totalStages;
  final int unlockedStage;
  final Set<int> completedStages;
  final ValueChanged<int> onTapStage;

  List<Widget> _mapDecorations(
    LearnovaPalette palette,
    double width,
    double mapHeight,
  ) {
    switch (subjectKind) {
      case _SubjectKind.english:
        return <Widget>[
          Positioned(
            left: width * 0.05,
            top: 124,
            child: _MapDecorationBadge(
              text: 'A',
              color: const Color(0xFF4BB9FF).withValues(alpha: 0.18),
              textColor: const Color(0xFF1E629A),
            ),
          ),
          Positioned(
            right: width * 0.05,
            top: mapHeight * 0.52,
            child: _MapDecorationBadge(
              text: 'B',
              color: const Color(0xFF58CC02).withValues(alpha: 0.18),
              textColor: const Color(0xFF2E6B08),
            ),
          ),
          Positioned(
            left: width * 0.08,
            top: mapHeight * 0.83,
            child: _MapDecorationBadge(
              text: 'C',
              color: const Color(0xFFFFC74C).withValues(alpha: 0.2),
              textColor: const Color(0xFF875800),
            ),
          ),
        ];
      case _SubjectKind.math:
        return <Widget>[
          Positioned(
            left: width * 0.05,
            top: 126,
            child: _MapDecorationBadge(
              text: '+',
              color: const Color(0xFF58CC02).withValues(alpha: 0.18),
              textColor: const Color(0xFF2D6808),
            ),
          ),
          Positioned(
            right: width * 0.05,
            top: mapHeight * 0.54,
            child: _MapDecorationBadge(
              text: 'x',
              color: const Color(0xFF4BB9FF).withValues(alpha: 0.18),
              textColor: const Color(0xFF1E6097),
            ),
          ),
          Positioned(
            left: width * 0.08,
            top: mapHeight * 0.84,
            child: _MapDecorationBadge(
              text: '=',
              color: const Color(0xFF9A63FF).withValues(alpha: 0.2),
              textColor: const Color(0xFF563E84),
            ),
          ),
        ];
      case _SubjectKind.gk:
        return <Widget>[
          Positioned(
            left: width * 0.05,
            top: 126,
            child: _MapDecorationIcon(
              icon: Icons.public_rounded,
              color: const Color(0xFF4BB9FF).withValues(alpha: 0.18),
              iconColor: const Color(0xFF1E5E95),
            ),
          ),
          Positioned(
            right: width * 0.05,
            top: mapHeight * 0.53,
            child: _MapDecorationIcon(
              icon: Icons.travel_explore_rounded,
              color: const Color(0xFF58CC02).withValues(alpha: 0.18),
              iconColor: const Color(0xFF2F6B08),
            ),
          ),
          Positioned(
            left: width * 0.08,
            top: mapHeight * 0.84,
            child: _MapDecorationIcon(
              icon: Icons.emoji_objects_rounded,
              color: const Color(0xFFFFC74C).withValues(alpha: 0.2),
              iconColor: const Color(0xFF8A6100),
            ),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final Color activePathColor = switch (subjectKind) {
      _SubjectKind.english => const Color(0xFF2B7CFF),
      _SubjectKind.math => const Color(0xFFFF8A3D),
      _SubjectKind.gk => const Color(0xFF7C5CFF),
    };
    const Color completedPathColor = Color(0xFF2EBB5A);
    const Color lockedPathColor = Color(0xFF8AA0B3);
    const List<Color> stageColors = <Color>[
      Color(0xFF58CC02),
      Color(0xFF1CB0F6),
      Color(0xFFFFC74C),
      Color(0xFFFF6B6B),
      Color(0xFF9A63FF),
      Color(0xFF00BFA5),
      Color(0xFFFF8C42),
      Color(0xFF6AA9FF),
      Color(0xFFFF78A8),
      Color(0xFF7ABF35),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withValues(alpha: 0.62),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.alt_route_rounded, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Tap the open stage to play',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final double nodeRadius = width >= 720 ? 46 : 40;
            final double nodeSize = nodeRadius * 2;
            final double verticalGap = width >= 720 ? 134 : 122;
            final double topPadding = width >= 720 ? 72 : 68;
            final double leftX = width * (width >= 720 ? 0.22 : 0.2);
            final double rightX = width * (width >= 720 ? 0.78 : 0.8);

            final List<Offset> centers = List<Offset>.generate(totalStages, (
              int index,
            ) {
              final bool left = index.isEven;
              final double x = left ? leftX : rightX;
              final double y = topPadding + index * verticalGap;
              return Offset(x, y);
            });

            final double mapHeight =
                topPadding + (totalStages - 1) * verticalGap + nodeSize + 64;

            return SizedBox(
              height: mapHeight,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Stack(
                        children: _mapDecorations(palette, width, mapHeight),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _LearningPathPainter(
                          centers: centers,
                          unlockedStage: unlockedStage,
                          completedStages: completedStages,
                          activeColor: activePathColor,
                          completedColor: completedPathColor,
                          lockedColor: lockedPathColor,
                        ),
                      ),
                    ),
                  ),
                  for (int i = 0; i < centers.length; i++)
                    Positioned(
                      left: centers[i].dx - nodeRadius,
                      top: centers[i].dy - nodeRadius,
                      width: nodeSize,
                      child: _StageNode(
                        stageNumber: i + 1,
                        unlocked: i + 1 <= unlockedStage,
                        completed: completedStages.contains(i + 1),
                        isCurrent: i + 1 == unlockedStage,
                        nodeColor: stageColors[i % stageColors.length],
                        radius: nodeRadius,
                        onTap: () => onTapStage(i + 1),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({
    required this.stageNumber,
    required this.unlocked,
    required this.completed,
    required this.isCurrent,
    required this.nodeColor,
    required this.radius,
    required this.onTap,
  });

  final int stageNumber;
  final bool unlocked;
  final bool completed;
  final bool isCurrent;
  final Color nodeColor;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final Color fillColor = completed
        ? palette.success
        : unlocked
        ? nodeColor
        : palette.borderSoft;
    final Color foregroundColor = unlocked || completed
        ? Colors.white
        : palette.textSecondary;
    final double scale = isCurrent ? 1.04 : 1.0;
    final IconData stageIcon = switch (stageNumber % 5) {
      1 => Icons.auto_stories_rounded,
      2 => Icons.extension_rounded,
      3 => Icons.lightbulb_rounded,
      4 => Icons.star_rounded,
      _ => Icons.emoji_events_rounded,
    };

    return Column(
      children: <Widget>[
        AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              if (isCurrent)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: fillColor.withValues(alpha: 0.45),
                        width: 5,
                      ),
                    ),
                  ),
                ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(radius),
                  onTap: onTap,
                  child: Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: unlocked || completed
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                fillColor.withValues(alpha: 0.98),
                                fillColor.withValues(alpha: 0.78),
                              ],
                            )
                          : null,
                      color: unlocked || completed ? null : fillColor,
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: unlocked || completed ? 0.98 : 0.75,
                        ),
                        width: 3,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: fillColor.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: completed
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 26,
                            )
                          : unlocked
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  stageIcon,
                                  color: foregroundColor,
                                  size: radius * 0.48,
                                ),
                                Text(
                                  '$stageNumber',
                                  style: GoogleFonts.fredoka(
                                    color: foregroundColor,
                                    fontSize: radius * 0.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.lock_rounded,
                              color: foregroundColor,
                              size: radius * 0.62,
                            ),
                    ),
                  ),
                ),
              ),
              if (isCurrent)
                Positioned(
                  right: -4,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFFFC74C),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFFFC74C).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'GO',
                      style: GoogleFonts.fredoka(
                        fontSize: 11,
                        color: const Color(0xFF3E2F00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Stage $stageNumber',
          style: TextStyle(
            color: palette.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MapDecorationBadge extends StatelessWidget {
  const _MapDecorationBadge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Text(
        text,
        style: GoogleFonts.fredoka(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapDecorationIcon extends StatelessWidget {
  const _MapDecorationIcon({
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}

class _LearningPathPainter extends CustomPainter {
  _LearningPathPainter({
    required this.centers,
    required this.unlockedStage,
    required this.completedStages,
    required this.activeColor,
    required this.completedColor,
    required this.lockedColor,
  });

  final List<Offset> centers;
  final int unlockedStage;
  final Set<int> completedStages;
  final Color activeColor;
  final Color completedColor;
  final Color lockedColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint underGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint centerTrack = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint sparkleDot = Paint()
      ..color = Colors.white.withValues(alpha: 0.8);

    for (int i = 0; i < centers.length - 1; i++) {
      final Offset from = centers[i];
      final Offset to = centers[i + 1];
      final bool completedSegment = completedStages.contains(i + 1);
      final bool activeSegment = i + 1 == unlockedStage;

      final Color segmentColor = completedSegment
          ? completedColor
          : activeSegment
          ? activeColor
          : lockedColor;
      underGlow.color = Color.alphaBlend(
        Colors.white.withValues(alpha: 0.42),
        segmentColor,
      ).withValues(alpha: activeSegment ? 0.55 : 0.4);
      line.color = segmentColor;
      centerTrack.color = Colors.white.withValues(
        alpha: activeSegment ? 0.62 : 0.46,
      );

      final Offset delta = to - from;
      final double length = max(delta.distance, 1);
      final Offset tangent = Offset(delta.dx / length, delta.dy / length);
      final Offset normal = Offset(-tangent.dy, tangent.dx);
      final double swing = i.isEven ? 1.0 : -1.0;
      final double curveAmp = min(72, max(42, length * 0.24));

      final Offset mid = from + tangent * (length * 0.53);
      final Offset c1 =
          from + tangent * (length * 0.24) + normal * (curveAmp * swing);
      final Offset c2 =
          from + tangent * (length * 0.42) - normal * (curveAmp * swing * 0.92);
      final Offset c3 =
          from + tangent * (length * 0.7) + normal * (curveAmp * swing * 0.78);
      final Offset c4 =
          to - tangent * (length * 0.2) - normal * (curveAmp * swing * 0.38);

      final Path segment = Path()..moveTo(from.dx, from.dy);
      segment.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, mid.dx, mid.dy);
      segment.cubicTo(c3.dx, c3.dy, c4.dx, c4.dy, to.dx, to.dy);
      canvas.drawPath(segment, underGlow);
      canvas.drawPath(segment, line);
      canvas.drawPath(segment, centerTrack);

      final dynamic metric = segment.computeMetrics().first;
      const List<double> stops = <double>[0.22, 0.5, 0.78];
      for (final double t in stops) {
        final dynamic tangent = metric.getTangentForOffset(metric.length * t);
        if (tangent != null) {
          canvas.drawCircle(
            tangent.position,
            activeSegment ? 2.6 : 2.2,
            sparkleDot,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LearningPathPainter oldDelegate) {
    final bool sameCompletedStages =
        oldDelegate.completedStages.length == completedStages.length &&
        oldDelegate.completedStages.containsAll(completedStages) &&
        completedStages.containsAll(oldDelegate.completedStages);
    return oldDelegate.unlockedStage != unlockedStage ||
        oldDelegate.centers.length != centers.length ||
        !sameCompletedStages ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.completedColor != completedColor ||
        oldDelegate.lockedColor != lockedColor;
  }
}

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    required this.roleTitle,
    required this.roleSubtitle,
    required this.onOpenThemePicker,
    required this.onExit,
    required this.body,
    this.menuAccountEmail,
    this.menuLinkedKids,
    this.onOpenKidManagement,
    super.key,
  });

  final String roleTitle;
  final String roleSubtitle;
  final ThemePickerHandler onOpenThemePicker;
  final NavigationHandler onExit;
  final Widget body;
  final String? menuAccountEmail;
  final int? menuLinkedKids;
  final Future<void> Function()? onOpenKidManagement;

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
                accountEmail: menuAccountEmail,
                linkedKids: menuLinkedKids,
                onOpenKidManagement: onOpenKidManagement,
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
                child: _DashboardMenu(
                  roleTitle: roleTitle,
                  onExit: onExit,
                  accountEmail: menuAccountEmail,
                  linkedKids: menuLinkedKids,
                  onOpenKidManagement: onOpenKidManagement,
                ),
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
    final LearnovaPalette palette = _palette(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasSubtitle = subtitle.trim().isNotEmpty;

    if (!showTitle && !hasSubtitle) {
      return const SizedBox.shrink();
    }

    if (!showTitle && hasSubtitle) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              palette.headerGradientStart,
              palette.headerGradientEnd,
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: palette.borderSoft.withValues(alpha: 0.75),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.borderSoft),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.cardShadow.withValues(alpha: isDark ? 0.3 : 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.brandPrimary.withValues(alpha: 0.16),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  size: 19,
                  color: palette.brandPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: palette.textSecondary,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.headerGradientStart,
            palette.headerGradientEnd,
          ],
        ),
        border: Border(
          bottom: BorderSide(color: palette.borderSoft.withValues(alpha: 0.75)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (showTitle)
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 26,
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (showTitle) const SizedBox(height: 2),
                if (hasSubtitle)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: palette.textSecondary,
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

class ThemeShirtButton extends StatelessWidget {
  const ThemeShirtButton({
    required this.onPressed,
    this.compact = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double boxSize = compact ? 38 : 44;
    return Tooltip(
      message: 'Themes',
      child: Container(
        margin: compact ? const EdgeInsets.only(right: 8) : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: onPressed,
            child: Ink(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFFF5C8A),
                    Color(0xFFFFC74C),
                    Color(0xFF78D64B),
                    Color(0xFF4BB9FF),
                    Color(0xFF9A63FF),
                  ],
                ),
              ),
              child: Icon(
                Icons.format_paint_rounded,
                size: compact ? 19 : 21,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final LearnovaPalette palette = _palette(context);
    final Color tileColor = isDark ? const Color(0xFF172036) : Colors.white;
    final Color titleColor = isDark
        ? const Color(0xFFE7F4D7)
        : palette.textPrimary;
    final Color subtitleColor = isDark
        ? const Color(0xFFB7C8A8)
        : palette.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? color : palette.borderSoft,
          width: selected ? 2 : 1.2,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(Icons.palette_outlined, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, color: titleColor),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
        trailing: selected
            ? Icon(Icons.check_circle, color: color)
            : Icon(Icons.radio_button_unchecked, color: palette.borderStrong),
      ),
    );
  }
}

class _DashboardMenu extends StatelessWidget {
  const _DashboardMenu({
    required this.roleTitle,
    required this.onExit,
    this.accountEmail,
    this.linkedKids,
    this.onOpenKidManagement,
    this.inDrawer = false,
  });

  final String roleTitle;
  final NavigationHandler onExit;
  final String? accountEmail;
  final int? linkedKids;
  final Future<void> Function()? onOpenKidManagement;
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final bool isParent = roleTitle.toLowerCase().contains('parent');

    void closeDrawerIfNeeded() {
      if (inDrawer) {
        Navigator.of(context).pop();
      }
    }

    Future<void> showMenuInfo(String text) async {
      _showMessage(context, text, color: Theme.of(context).colorScheme.primary);
      closeDrawerIfNeeded();
    }

    return Container(
      color: palette.menuBackground,
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
            if (isParent)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: palette.menuTile,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: palette.menuDivider),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.family_restroom_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Parent Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              accountEmail ?? 'parent@learnova.com',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: palette.menuSubtext,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              linkedKids == null
                                  ? 'Kids linked'
                                  : '$linkedKids kids linked',
                              style: TextStyle(
                                color: palette.menuSubtext,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Divider(color: palette.menuDivider, height: 1),
            _MenuTile(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              subtitle: roleTitle,
              onTap: () {
                closeDrawerIfNeeded();
              },
            ),
            if (isParent)
              _MenuTile(
                icon: Icons.groups_2_outlined,
                title: 'Kid Management',
                subtitle: 'Create and update child accounts',
                onTap: () async {
                  closeDrawerIfNeeded();
                  if (onOpenKidManagement != null) {
                    await onOpenKidManagement!.call();
                    return;
                  }
                  _showMessage(
                    context,
                    'Open Kid Management from the dashboard card.',
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            if (isParent)
              _MenuTile(
                icon: Icons.analytics_outlined,
                title: 'Kid Reports',
                subtitle: 'Streaks, stars, tests, and progress',
                onTap: () {
                  showMenuInfo(
                    'Kid reports are available below in the parent dashboard.',
                  );
                },
              ),
            if (isParent)
              _MenuTile(
                icon: Icons.tune_rounded,
                title: 'Learning Settings',
                subtitle: 'Levels, flow, and controls',
                onTap: () {
                  showMenuInfo('Learning settings panel will be added next.');
                },
              ),
            if (isParent)
              _MenuTile(
                icon: Icons.support_agent_rounded,
                title: 'Help & Support',
                subtitle: 'Guides for parents',
                onTap: () {
                  showMenuInfo(
                    'Support center will be connected in backend phase.',
                  );
                },
              ),
            if (!isParent)
              _MenuTile(
                icon: Icons.menu_book_outlined,
                title: 'Menu',
                subtitle: 'More options soon',
                onTap: () {
                  showMenuInfo('Menu placeholder: more options will be added.');
                },
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _palette(context).error,
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
    final LearnovaPalette palette = _palette(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: palette.menuTile,
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
            style: TextStyle(color: palette.menuSubtext),
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
    final LearnovaPalette palette = _palette(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: palette.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: palette.textPrimary, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: palette.textSecondary,
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
