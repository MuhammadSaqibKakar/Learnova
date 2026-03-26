part of 'package:learnova/main.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.pageTitle,
    required this.pageSubtitle,
    required this.onOpenThemePicker,
    required this.formChild,
    this.showThemeButton = false,
    super.key,
  });

  final String pageTitle;
  final String pageSubtitle;
  final ThemePickerHandler onOpenThemePicker;
  final Widget formChild;
  final bool showThemeButton;

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
          if (showThemeButton)
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: ThemeShirtButton(
                  onPressed: () => onOpenThemePicker(context),
                ),
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
    final LearnovaPalette palette = _palette(context);
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
                color: palette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Discover '),
                TextSpan(
                  text: 'Learnova',
                  style: TextStyle(color: palette.heroAccent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A joyful learning world for ages 4 to 10. Safe, guided, and level-based learning for every child.',
            style: TextStyle(
              fontSize: 19,
              color: palette.textSecondary,
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
    final LearnovaPalette palette = _palette(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            pageTitle,
            style: GoogleFonts.fredoka(
              fontSize: 29,
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasSubtitle) const SizedBox(height: 6),
          if (hasSubtitle)
            Text(
              pageSubtitle,
              style: TextStyle(
                fontSize: 15,
                color: palette.textSecondary,
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
