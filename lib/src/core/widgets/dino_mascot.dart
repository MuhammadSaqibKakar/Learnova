part of 'package:learnova/main.dart';

enum DinoAnimationAction {
  welcomeWave,
  waveHi,
  waveBye,
  jump,
  spinAxis,
  bounce,
  nod,
  shake,
  dance,
  twirl,
  tailWag,
  clap,
  sway,
  spinHop,
  proudPose,
  rocket,
}

class DinoPageOverlay extends StatefulWidget {
  const DinoPageOverlay({
    required this.child,
    this.message = '',
    this.size = 94,
    this.speaking = false,
    this.playWelcome = false,
    this.triggerToken = 0,
    this.bottom = 10,
    this.right = 10,
    this.draggable = true,
    this.introFromBig = false,
    this.actionPlaylist = const <DinoAnimationAction>[
      DinoAnimationAction.waveHi,
      DinoAnimationAction.jump,
      DinoAnimationAction.spinAxis,
      DinoAnimationAction.bounce,
      DinoAnimationAction.nod,
      DinoAnimationAction.shake,
      DinoAnimationAction.dance,
      DinoAnimationAction.clap,
      DinoAnimationAction.sway,
      DinoAnimationAction.twirl,
      DinoAnimationAction.spinHop,
      DinoAnimationAction.proudPose,
      DinoAnimationAction.tailWag,
      DinoAnimationAction.rocket,
      DinoAnimationAction.waveBye,
    ],
    super.key,
  });

  final Widget child;
  final String message;
  final double size;
  final bool speaking;
  final bool playWelcome;
  final int triggerToken;
  final double bottom;
  final double right;
  final bool draggable;
  final bool introFromBig;
  final List<DinoAnimationAction> actionPlaylist;

  @override
  State<DinoPageOverlay> createState() => _DinoPageOverlayState();
}

class _DinoPageOverlayState extends State<DinoPageOverlay> {
  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets safe = MediaQuery.paddingOf(context);
        final double bubbleWidth = min(220, widget.size * 2.45);
        final double dinoWidth = widget.size * 1.16;
        final double dinoHeight = widget.size * 1.24;
        final double dragWidth = max(bubbleWidth, dinoWidth) + 12;
        final double dragHeight =
            dinoHeight + (widget.message.trim().isNotEmpty ? 96 : 0) + 12;
        final double leftOverflowAllowance = max(0, dragWidth - dinoWidth);
        final double topOverflowAllowance = max(0, dragHeight - dinoHeight);
        final double minLeft = max(6.0, safe.left + 6) - leftOverflowAllowance;
        final double minTop = max(6.0, safe.top + 6) - topOverflowAllowance;
        final double originLeft = max(
          minLeft,
          constraints.maxWidth - dragWidth - max(widget.right, safe.right + 8),
        );
        final double originTop = max(
          minTop,
          constraints.maxHeight -
              dragHeight -
              max(widget.bottom, safe.bottom + 8),
        );
        final double maxLeftTravel = max(0, originLeft - minLeft);
        final double maxUpTravel = max(0, originTop - minTop);
        final double currentLeft = originLeft + _dragOffset.dx;
        final double currentTop = originTop + _dragOffset.dy;
        final Widget mascot = DinoMascotAssistant(
          size: widget.size,
          message: widget.message,
          speaking: widget.speaking,
          playWelcome: widget.playWelcome,
          triggerToken: widget.triggerToken,
          introFromBig: widget.introFromBig,
          actionPlaylist: widget.actionPlaylist,
        );

        final Widget movable = widget.draggable
            ? _ImmediateDeltaDragSurface(
                onDelta: (Offset delta) {
                  setState(() {
                    final double nextX = (_dragOffset.dx + delta.dx).clamp(
                      -maxLeftTravel,
                      0,
                    );
                    final double nextY = (_dragOffset.dy + delta.dy).clamp(
                      -maxUpTravel,
                      0,
                    );
                    _dragOffset = Offset(nextX, nextY);
                  });
                },
                child: SizedBox(
                  width: dragWidth,
                  height: dragHeight,
                  child: Align(alignment: Alignment.bottomRight, child: mascot),
                ),
              )
            : mascot;

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(child: widget.child),
            Positioned(
              left: currentLeft,
              top: currentTop,
              child: RepaintBoundary(
                child: Material(
                  type: MaterialType.transparency,
                  child: movable,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ImmediateDeltaDragSurface extends StatelessWidget {
  const _ImmediateDeltaDragSurface({
    required this.child,
    required this.onDelta,
  });

  final Widget child;
  final ValueChanged<Offset> onDelta;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.deferToChild,
      gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
        ImmediateMultiDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
              ImmediateMultiDragGestureRecognizer
            >(ImmediateMultiDragGestureRecognizer.new, (
              ImmediateMultiDragGestureRecognizer instance,
            ) {
              instance.onStart = (Offset position) {
                return _ImmediateDeltaDrag(onDelta: onDelta);
              };
            }),
      },
      child: child,
    );
  }
}

class _ImmediateDeltaDrag extends Drag {
  _ImmediateDeltaDrag({required this.onDelta});

  final ValueChanged<Offset> onDelta;

  @override
  void update(DragUpdateDetails details) {
    onDelta(details.delta);
  }

  @override
  void end(DragEndDetails details) {}

  @override
  void cancel() {}
}

class DinoMascotAssistant extends StatefulWidget {
  const DinoMascotAssistant({
    required this.size,
    this.message = '',
    this.speaking = false,
    this.playWelcome = false,
    this.triggerToken = 0,
    this.introFromBig = false,
    this.badgeIcon,
    this.baseColor = const Color(0xFF3FCB2A),
    this.bellyColor = const Color(0xFFF8E8AF),
    this.actionPlaylist = const <DinoAnimationAction>[
      DinoAnimationAction.waveHi,
      DinoAnimationAction.jump,
      DinoAnimationAction.spinAxis,
      DinoAnimationAction.bounce,
      DinoAnimationAction.nod,
      DinoAnimationAction.shake,
      DinoAnimationAction.dance,
      DinoAnimationAction.clap,
      DinoAnimationAction.sway,
      DinoAnimationAction.twirl,
      DinoAnimationAction.spinHop,
      DinoAnimationAction.proudPose,
      DinoAnimationAction.tailWag,
      DinoAnimationAction.rocket,
      DinoAnimationAction.waveBye,
    ],
    super.key,
  });

  final double size;
  final String message;
  final bool speaking;
  final bool playWelcome;
  final int triggerToken;
  final bool introFromBig;
  final IconData? badgeIcon;
  final Color baseColor;
  final Color bellyColor;
  final List<DinoAnimationAction> actionPlaylist;

  @override
  State<DinoMascotAssistant> createState() => _DinoMascotAssistantState();
}

class _DinoMascotAssistantState extends State<DinoMascotAssistant>
    with TickerProviderStateMixin {
  late final AnimationController _actionController;
  late final AnimationController _idleController;
  late final AnimationController _introController;

  DinoAnimationAction _currentAction = DinoAnimationAction.waveHi;
  DinoAnimationAction? _queuedAction;
  int _actionIndex = 0;
  late int _lastTriggerToken;

  List<DinoAnimationAction> get _playlist {
    if (widget.actionPlaylist.isEmpty) {
      return const <DinoAnimationAction>[
        DinoAnimationAction.waveHi,
        DinoAnimationAction.jump,
        DinoAnimationAction.spinAxis,
        DinoAnimationAction.bounce,
        DinoAnimationAction.nod,
        DinoAnimationAction.shake,
        DinoAnimationAction.dance,
        DinoAnimationAction.clap,
        DinoAnimationAction.sway,
        DinoAnimationAction.twirl,
        DinoAnimationAction.spinHop,
        DinoAnimationAction.proudPose,
        DinoAnimationAction.tailWag,
        DinoAnimationAction.rocket,
        DinoAnimationAction.waveBye,
      ];
    }
    return widget.actionPlaylist;
  }

  @override
  void initState() {
    super.initState();
    _lastTriggerToken = widget.triggerToken;
    _actionController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1650),
        )..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            _playNext();
          }
        });
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    )..repeat();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      value: widget.introFromBig ? 0 : 1,
    );
    if (widget.introFromBig) {
      _introController.forward();
    }

    if (widget.playWelcome) {
      _currentAction = DinoAnimationAction.welcomeWave;
      _actionController.forward(from: 0);
      return;
    }
    _playNext();
  }

  @override
  void didUpdateWidget(covariant DinoMascotAssistant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.introFromBig && widget.introFromBig) {
      _introController
        ..value = 0
        ..forward();
    }
    if (widget.triggerToken != _lastTriggerToken) {
      _lastTriggerToken = widget.triggerToken;
      _queuedAction = DinoAnimationAction.welcomeWave;
      if (!_actionController.isAnimating) {
        _playNext();
      }
    }
  }

  void _playNext() {
    if (!mounted) {
      return;
    }
    if (_queuedAction != null) {
      setState(() {
        _currentAction = _queuedAction!;
        _queuedAction = null;
      });
      _actionController.forward(from: 0);
      return;
    }
    setState(() {
      _currentAction = _playlist[_actionIndex % _playlist.length];
      _actionIndex += 1;
    });
    _actionController.forward(from: 0);
  }

  @override
  void dispose() {
    _actionController.dispose();
    _idleController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    final double bubbleWidth = min(220, widget.size * 2.45);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        _actionController,
        _idleController,
        _introController,
      ]),
      builder: (BuildContext context, Widget? child) {
        final _DinoMotion motion = _computeDinoMotion(
          action: _currentAction,
          actionT: _actionController.value,
          idleT: _idleController.value,
          speaking: widget.speaking,
        );
        final double introT = widget.introFromBig
            ? Curves.easeOutBack.transform(_introController.value)
            : 1;
        final double entranceScale = 1 + ((1 - introT) * 3.4);
        final double entranceShift = (1 - introT) * 160;
        final bool showBubble = !widget.introFromBig || introT > 0.58;

        return Transform.translate(
          offset: Offset(0, entranceShift),
          child: Transform.scale(
            alignment: Alignment.bottomRight,
            scale: entranceScale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (showBubble && widget.message.trim().isNotEmpty)
                  Container(
                    width: bubbleWidth,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withValues(alpha: 0.95),
                      border: Border.all(color: palette.borderSoft),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                _DinoCharacter(
                  size: widget.size,
                  motion: motion,
                  bellyColor: widget.bellyColor,
                  badgeIcon: widget.badgeIcon,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DinoInstructorAvatar extends StatefulWidget {
  const DinoInstructorAvatar({
    required this.accentColor,
    required this.moodIndex,
    this.speaking = false,
    this.size = 72,
    this.badgeIcon,
    super.key,
  });

  final Color accentColor;
  final int moodIndex;
  final bool speaking;
  final double size;
  final IconData? badgeIcon;

  @override
  State<DinoInstructorAvatar> createState() => _DinoInstructorAvatarState();
}

class _DinoInstructorAvatarState extends State<DinoInstructorAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..repeat();

  static const List<DinoAnimationAction> _actions = <DinoAnimationAction>[
    DinoAnimationAction.nod,
    DinoAnimationAction.waveHi,
    DinoAnimationAction.tailWag,
    DinoAnimationAction.dance,
    DinoAnimationAction.clap,
    DinoAnimationAction.jump,
    DinoAnimationAction.shake,
    DinoAnimationAction.bounce,
    DinoAnimationAction.sway,
    DinoAnimationAction.twirl,
    DinoAnimationAction.spinHop,
    DinoAnimationAction.waveBye,
    DinoAnimationAction.proudPose,
    DinoAnimationAction.rocket,
    DinoAnimationAction.spinAxis,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DinoAnimationAction action =
        _actions[widget.moodIndex % _actions.length];

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final _DinoMotion motion = _computeDinoMotion(
          action: action,
          actionT: _controller.value,
          idleT: _controller.value,
          speaking: widget.speaking,
        );
        return _DinoCharacter(
          size: widget.size,
          motion: motion,
          bellyColor: const Color(0xFFF9EAB6),
          badgeIcon: widget.badgeIcon,
          badgeColor: widget.accentColor,
        );
      },
    );
  }
}

class _DinoCharacter extends StatelessWidget {
  const _DinoCharacter({
    required this.size,
    required this.motion,
    required this.bellyColor,
    this.badgeIcon,
    this.badgeColor = const Color(0xFF58CC02),
  });

  final double size;
  final _DinoMotion motion;
  final Color bellyColor;
  final IconData? badgeIcon;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final double width = size * 1.16;
    final double height = size * 1.24;
    final double nodScale = 1 + (motion.headRotate.abs() * 0.06);

    return Transform.translate(
      offset: Offset(motion.xShift, motion.yShift),
      child: Transform.rotate(
        angle: motion.bodyRotate,
        child: Transform.scale(
          scale: motion.bodyScale,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  left: size * 0.18,
                  right: size * 0.18,
                  bottom: size * 0.03,
                  child: Container(
                    height: size * 0.19,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size * 0.2),
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: size * 0.02,
                      right: size * 0.02,
                      top: size * 0.02,
                      bottom: size * 0.07,
                    ),
                    child: Transform.scale(
                      alignment: Alignment.center,
                      scale: nodScale,
                      child: Image.asset(
                        'assets/mascot/dino_mascot.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                if (badgeIcon != null)
                  Positioned(
                    right: 0,
                    top: size * 0.06,
                    child: Container(
                      width: size * 0.22,
                      height: size * 0.22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: badgeColor,
                        border: Border.all(color: Colors.white, width: 1.6),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        badgeIcon,
                        color: Colors.white,
                        size: size * 0.11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DinoMotion {
  const _DinoMotion({
    this.bodyRotate = 0,
    this.bodyScale = 1,
    this.xShift = 0,
    this.yShift = 0,
    this.headRotate = 0,
    this.leftArmRotate = 0.04,
    this.rightArmRotate = -0.04,
    this.tailRotate = 0,
    this.mouthOpen = 0.14,
    this.blink = false,
  });

  final double bodyRotate;
  final double bodyScale;
  final double xShift;
  final double yShift;
  final double headRotate;
  final double leftArmRotate;
  final double rightArmRotate;
  final double tailRotate;
  final double mouthOpen;
  final bool blink;
}

_DinoMotion _computeDinoMotion({
  required DinoAnimationAction action,
  required double actionT,
  required double idleT,
  required bool speaking,
}) {
  final double p = Curves.easeInOutSine.transform(actionT.clamp(0, 1));
  final double loop = sin(idleT * pi * 2);

  double bodyRotate = loop * 0.018;
  double bodyScale = 1 + loop * 0.009;
  double xShift = 0;
  double yShift = 0;
  double headRotate = loop * 0.028;
  double leftArmRotate = 0.04 + loop * 0.015;
  double rightArmRotate = -0.04 - loop * 0.015;
  double tailRotate = loop * 0.14;
  double mouthBoost = 0;

  switch (action) {
    case DinoAnimationAction.welcomeWave:
      bodyScale += sin(p * pi) * 0.25;
      rightArmRotate = -0.18 + sin(p * pi * 4) * 0.16;
      yShift -= sin(p * pi) * 8;
      headRotate += sin(p * pi * 2) * 0.06;
    case DinoAnimationAction.waveHi:
      rightArmRotate = -0.16 + sin(p * pi * 4) * 0.14;
      headRotate += sin(p * pi * 2) * 0.07;
    case DinoAnimationAction.waveBye:
      leftArmRotate = 0.16 + sin(p * pi * 4) * 0.14;
      headRotate += sin(p * pi * 2) * 0.07;
    case DinoAnimationAction.jump:
      yShift -= sin(p * pi).abs() * 20;
      rightArmRotate = -0.08;
      leftArmRotate = 0.08;
      tailRotate += sin(p * pi * 2) * 0.16;
    case DinoAnimationAction.spinAxis:
      bodyRotate += p * pi * 2;
      rightArmRotate = -0.08;
      leftArmRotate = 0.08;
    case DinoAnimationAction.bounce:
      yShift -= sin(p * pi).abs() * 12;
      bodyScale += sin(p * pi).abs() * 0.06;
      tailRotate += sin(p * pi * 4) * 0.12;
    case DinoAnimationAction.nod:
      headRotate += sin(p * pi * 2) * 0.18;
    case DinoAnimationAction.shake:
      xShift += sin(p * pi * 6) * 5.2;
      headRotate += sin(p * pi * 6) * 0.06;
    case DinoAnimationAction.dance:
      bodyRotate += sin(p * pi * 4) * 0.16;
      yShift -= sin(p * pi * 2).abs() * 8;
      leftArmRotate = 0.1 + sin(p * pi * 4) * 0.1;
      rightArmRotate = -0.1 - sin(p * pi * 4) * 0.1;
      tailRotate += sin(p * pi * 4) * 0.22;
    case DinoAnimationAction.twirl:
      bodyRotate += sin(p * pi * 2) * 0.3;
      xShift += sin(p * pi * 2) * 3.8;
      tailRotate += sin(p * pi * 6) * 0.32;
    case DinoAnimationAction.tailWag:
      tailRotate += sin(p * pi * 8) * 0.7;
      bodyRotate += sin(p * pi * 4) * 0.04;
    case DinoAnimationAction.clap:
      leftArmRotate = 0.05 + sin(p * pi * 4) * 0.12;
      rightArmRotate = -0.05 - sin(p * pi * 4) * 0.12;
      bodyScale += sin(p * pi).abs() * 0.03;
    case DinoAnimationAction.sway:
      bodyRotate += sin(p * pi * 2) * 0.11;
      xShift += sin(p * pi * 2) * 4.4;
      tailRotate += sin(p * pi * 6) * 0.16;
    case DinoAnimationAction.spinHop:
      bodyRotate += sin(p * pi * 2) * 0.24;
      yShift -= sin(p * pi).abs() * 13;
      xShift += sin(p * pi * 2) * 3.5;
    case DinoAnimationAction.proudPose:
      bodyScale += sin(p * pi).abs() * 0.05;
      headRotate -= sin(p * pi).abs() * 0.06;
      leftArmRotate = 0.02;
      rightArmRotate = -0.02;
    case DinoAnimationAction.rocket:
      yShift -= sin(p * pi).abs() * 16;
      bodyScale += sin(p * pi).abs() * 0.04;
      tailRotate += sin(p * pi * 8) * 0.18;
      mouthBoost += sin(p * pi * 3).abs() * 0.08;
  }

  final double talk = speaking ? (0.24 + sin(idleT * pi * 9).abs() * 0.42) : 0;
  final double mouthOpen =
      (speaking ? talk : max(0.08, 0.11 + sin(p * pi * 2).abs() * 0.04)) +
      mouthBoost;
  final bool blink = sin(idleT * pi * 2 * 0.8) > 0.995;

  return _DinoMotion(
    bodyRotate: bodyRotate,
    bodyScale: bodyScale,
    xShift: xShift,
    yShift: yShift,
    headRotate: headRotate,
    leftArmRotate: leftArmRotate,
    rightArmRotate: rightArmRotate,
    tailRotate: tailRotate,
    mouthOpen: mouthOpen,
    blink: blink,
  );
}
