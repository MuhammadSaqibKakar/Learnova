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
  late List<ChildAccount> _children;

  @override
  void initState() {
    super.initState();
    _children = List<ChildAccount>.from(widget.initialChildren);
  }

  void _handleChildAdded(ChildAccount child) {
    setState(() {
      _children.insert(0, child);
    });
    widget.onChildAdded(child);
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
  }

  void _handleChildDeleted(String childId) {
    setState(() {
      _children.removeWhere((ChildAccount child) => child.id == childId);
    });
    widget.onChildDeleted(childId);
  }

  void _openKidManagement() {
    Navigator.of(context).push(
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
  }

  @override
  Widget build(BuildContext context) {
    final int kidCount = _children.length;
    return DashboardShell(
      roleTitle: 'Parent Dashboard',
      roleSubtitle: 'Manage student accounts and learning levels.',
      onOpenThemePicker: widget.onOpenThemePicker,
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
                            'Logged in as ${widget.parentEmail}. Your kid accounts and learning levels are managed from Kid Management.',
                      ),
                    ),
                    const SizedBox(height: 14),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 220),
                      child: _KidManagementEntryCard(
                        totalKids: kidCount,
                        onTap: _openKidManagement,
                      ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(context),
          child: Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: palette.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.groups_2_outlined,
                  color: palette.textPrimary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Kid Management',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalKids == 1
                          ? '1 kid account. Tap to open full management page.'
                          : '$totalKids kid accounts. Tap to open full management page.',
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: palette.textPrimary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
