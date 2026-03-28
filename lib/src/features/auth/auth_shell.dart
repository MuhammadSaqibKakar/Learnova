part of 'package:learnova/main.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.pageTitle,
    required this.pageSubtitle,
    required this.onOpenThemePicker,
    required this.formChild,
    this.showThemeButton = false,
    this.showDino = false,
    this.dinoMessage = 'Hi, I am Dino. Let us learn together!',
    this.dinoTrigger = 0,
    super.key,
  });

  final String pageTitle;
  final String pageSubtitle;
  final ThemePickerHandler onOpenThemePicker;
  final Widget formChild;
  final bool showThemeButton;
  final bool showDino;
  final String dinoMessage;
  final int dinoTrigger;

  @override
  Widget build(BuildContext context) {
    final Widget authContent = Stack(
      children: <Widget>[
        const LearnovaAnimatedBackground(),
        SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wideLayout = constraints.maxWidth >= 1000;
              final double dinoExtraBottom = showDino
                  ? (wideLayout ? 96 : 134)
                  : 0;
              final EdgeInsets pagePadding = EdgeInsets.symmetric(
                horizontal: wideLayout ? 30 : 14,
                vertical: 14,
              );

              if (wideLayout) {
                return Padding(
                  padding: pagePadding.copyWith(
                    bottom: pagePadding.bottom + dinoExtraBottom,
                  ),
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
                padding: pagePadding.copyWith(
                  bottom: pagePadding.bottom + dinoExtraBottom,
                ),
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
    );

    if (!showDino) {
      return Scaffold(body: authContent);
    }

    return Scaffold(
      body: _LoginDinoOverlay(
        size: 102,
        message: dinoMessage,
        triggerToken: dinoTrigger,
        child: authContent,
      ),
    );
  }
}

class _LoginDinoOverlay extends StatefulWidget {
  const _LoginDinoOverlay({
    required this.child,
    required this.message,
    required this.triggerToken,
    this.size = 102,
  });

  final Widget child;
  final String message;
  final int triggerToken;
  final double size;

  @override
  State<_LoginDinoOverlay> createState() => _LoginDinoOverlayState();
}

class _LoginDinoOverlayState extends State<_LoginDinoOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2900),
  )..forward();

  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets safe = MediaQuery.paddingOf(context);
        return AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double raw = _controller.value.clamp(0, 1);
            const double holdPortion = 0.28;
            final double travelT = ((raw - holdPortion) / (1 - holdPortion))
                .clamp(0, 1);
            final double t = Curves.easeInOutCubic.transform(travelT);
            final double startSize = min(constraints.maxWidth * 0.68, 300);
            final double animatedSize = lerpDouble(startSize, widget.size, t)!;
            const double expectedBubbleHeight = 72;
            const double bubbleGap = 8;
            final double bubbleWidth = min(220, animatedSize * 2.45);
            final double dinoWidth = animatedSize * 1.22;
            final double dinoHeight = animatedSize * 1.28;
            final double contentWidth = max(dinoWidth, bubbleWidth);
            final double contentHeight =
                dinoHeight + expectedBubbleHeight + bubbleGap;

            final double startLeft = (constraints.maxWidth - contentWidth) / 2;
            final double startTop =
                (constraints.maxHeight - contentHeight) * 0.22;
            final double endLeft =
                constraints.maxWidth - contentWidth - max(10, safe.right + 8);
            final double endTop =
                constraints.maxHeight -
                contentHeight -
                max(14, safe.bottom + 10);

            final double left =
                (lerpDouble(startLeft, endLeft, t)! + _dragOffset.dx).clamp(
                  6.0,
                  max(6.0, constraints.maxWidth - contentWidth - 6),
                );
            final double top =
                (lerpDouble(startTop, endTop, t)! + _dragOffset.dy).clamp(
                  6.0,
                  max(6.0, constraints.maxHeight - contentHeight - 6),
                );

            return Stack(
              children: <Widget>[
                Positioned.fill(child: widget.child),
                Positioned(
                  left: left,
                  top: top,
                  child: SafeArea(
                    top: false,
                    left: false,
                    child: GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        setState(() {
                          _dragOffset += details.delta;
                        });
                      },
                      child: DinoMascotAssistant(
                        size: animatedSize,
                        message: raw > 0.72 ? widget.message : '',
                        playWelcome: true,
                        triggerToken: widget.triggerToken,
                        actionPlaylist: const <DinoAnimationAction>[
                          DinoAnimationAction.welcomeWave,
                          DinoAnimationAction.waveHi,
                          DinoAnimationAction.clap,
                          DinoAnimationAction.nod,
                          DinoAnimationAction.sway,
                          DinoAnimationAction.tailWag,
                          DinoAnimationAction.proudPose,
                          DinoAnimationAction.rocket,
                          DinoAnimationAction.waveBye,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
