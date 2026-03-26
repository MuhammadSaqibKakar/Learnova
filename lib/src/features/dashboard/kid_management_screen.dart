part of 'package:learnova/main.dart';

class KidManagementScreen extends StatefulWidget {
  const KidManagementScreen({
    required this.parentEmail,
    required this.initialChildren,
    required this.onChildAdded,
    required this.onChildUpdated,
    required this.onChildDeleted,
    super.key,
  });

  final String parentEmail;
  final List<ChildAccount> initialChildren;
  final void Function(ChildAccount child) onChildAdded;
  final void Function(ChildAccount child) onChildUpdated;
  final void Function(String childId) onChildDeleted;

  @override
  State<KidManagementScreen> createState() => _KidManagementScreenState();
}

class _KidManagementScreenState extends State<KidManagementScreen> {
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
  bool _showCreateForm = false;

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
        color: _palette(context).success,
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
        color: _palette(context).success,
      );
    }

    _resetForm(collapse: true);
  }

  void _editChild(ChildAccount child) {
    setState(() {
      _showCreateForm = true;
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
        _showCreateForm = false;
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
    _showMessage(context, 'Child removed.', color: _palette(context).error);
  }

  void _toggleCreateForm() {
    final bool isOpen = _showCreateForm || _editingChildId != null;
    if (isOpen) {
      _resetForm(collapse: true);
      return;
    }
    setState(() {
      _showCreateForm = true;
    });
  }

  void _resetForm({bool collapse = false}) {
    setState(() {
      if (collapse) {
        _showCreateForm = false;
      }
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
    return Scaffold(
      appBar: AppBar(title: const Text('Kid Management')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(context),
                  child: Text(
                    'Parent: ${widget.parentEmail}\nCreate, edit, and remove kid accounts from this page.',
                    style: TextStyle(
                      color: _palette(context).textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _buildKidSummaryCard(),
                const SizedBox(height: 14),
                _buildChildrenListCard(),
                const SizedBox(height: 14),
                _buildAddKidToggleCard(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  child: (_showCreateForm || _editingChildId != null)
                      ? Column(
                          children: <Widget>[
                            const SizedBox(height: 14),
                            _buildCreateChildCard(),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _kidInitial(ChildAccount child) {
    final String source = child.nickname.trim().isNotEmpty
        ? child.nickname.trim()
        : child.username.trim();
    if (source.isEmpty) {
      return '?';
    }
    return source.substring(0, 1).toUpperCase();
  }

  Widget _buildAddKidToggleCard() {
    final LearnovaPalette palette = _palette(context);
    final bool isOpen = _showCreateForm || _editingChildId != null;
    final bool isEditing = _editingChildId != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isEditing ? 'Update Kid' : 'Add New Kid',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOpen ? 'Form is open below.' : 'Tap open to add a new kid.',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: _toggleCreateForm,
            icon: Icon(
              isOpen ? Icons.keyboard_arrow_up_rounded : Icons.add_rounded,
            ),
            label: Text(isOpen ? 'Close' : 'Open'),
          ),
        ],
      ),
    );
  }

  Widget _buildKidSummaryCard() {
    final LearnovaPalette palette = _palette(context);
    final int totalKids = _children.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.people_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Total Kids',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalKids',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  totalKids == 1
                      ? '1 kid account linked'
                      : '$totalKids kid accounts linked',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateChildCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _editingChildId == null ? 'Add New Kid' : 'Update Kid',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 19,
                color: _palette(context).textPrimary,
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
                        _editingChildId == null ? 'Add Kid' : 'Save Changes',
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
                      onPressed: () => _resetForm(collapse: true),
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
    final LearnovaPalette palette = _palette(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kid Names',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (_children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text('No kid accounts yet. Add your first kid below.'),
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
                    color: palette.surfaceSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.borderSoft),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        child: Text(_kidInitial(child)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              child.nickname,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
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
                        color: palette.error,
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
