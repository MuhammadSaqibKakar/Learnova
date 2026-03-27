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
      DinoAnimationAction.twirl,
      DinoAnimationAction.tailWag,
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
        final double maxLeft = max(
          0,
          constraints.maxWidth - (widget.size * 1.5) - widget.right - 8,
        );
        final double maxUp = max(
          0,
          constraints.maxHeight - (widget.size * 1.9) - widget.bottom - 8,
        );
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
            ? GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    final double nextX = (_dragOffset.dx + details.delta.dx)
                        .clamp(-maxLeft, 0);
                    final double nextY = (_dragOffset.dy + details.delta.dy)
                        .clamp(-maxUp, 0);
                    _dragOffset = Offset(nextX, nextY);
                  });
                },
                child: mascot,
              )
            : mascot;

        return Stack(
          children: <Widget>[
            Positioned.fill(child: widget.child),
            Positioned(
              right: widget.right,
              bottom: widget.bottom,
              child: SafeArea(
                top: false,
                left: false,
                child: Transform.translate(offset: _dragOffset, child: movable),
              ),
            ),
          ],
        );
      },
    );
  }
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
      DinoAnimationAction.twirl,
      DinoAnimationAction.tailWag,
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
        DinoAnimationAction.twirl,
        DinoAnimationAction.tailWag,
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
                  baseColor: widget.baseColor,
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
    DinoAnimationAction.jump,
    DinoAnimationAction.shake,
    DinoAnimationAction.bounce,
    DinoAnimationAction.twirl,
    DinoAnimationAction.waveBye,
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
          baseColor: const Color(0xFF3FCB2A),
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
    required this.baseColor,
    required this.bellyColor,
    this.badgeIcon,
    this.badgeColor = const Color(0xFF58CC02),
  });

  final double size;
  final _DinoMotion motion;
  final Color baseColor;
  final Color bellyColor;
  final IconData? badgeIcon;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final double width = size * 1.24;
    final double height = size * 1.33;
    final Color bodyDark = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.28),
      baseColor,
    );
    final Color bodyMid = Color.alphaBlend(
      Colors.white.withValues(alpha: 0.02),
      baseColor,
    );
    final Color bodyLight = Color.alphaBlend(
      Colors.white.withValues(alpha: 0.38),
      baseColor,
    );

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
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: size * 0.9,
                      height: size * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size * 0.2),
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.02,
                  bottom: size * 0.26,
                  child: Transform.rotate(
                    angle: -0.82 + motion.tailRotate,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        Container(
                          width: size * 0.34,
                          height: size * 0.16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size * 0.1),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[bodyLight, bodyMid, bodyDark],
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -size * 0.12,
                          child: Container(
                            width: size * 0.2,
                            height: size * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size * 0.08),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[bodyLight, baseColor, bodyDark],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.22,
                  bottom: size * 0.08,
                  child: Container(
                    width: size * 0.64,
                    height: size * 0.68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size * 0.34),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          bodyLight,
                          bodyMid,
                          baseColor,
                          bodyDark,
                        ],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.35,
                  bottom: size * 0.17,
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size * 0.24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          bellyColor.withValues(alpha: 0.95),
                          Color.alphaBlend(
                            Colors.black.withValues(alpha: 0.12),
                            bellyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.42,
                  bottom: size * 0.61,
                  child: Container(
                    width: size * 0.22,
                    height: size * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size * 0.12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[bodyLight, baseColor, bodyDark],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.16,
                  top: size * 0.01,
                  child: Transform.rotate(
                    angle: motion.headRotate,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: size * 0.72,
                      height: size * 0.61,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                            width: size * 0.72,
                            height: size * 0.56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size * 0.28),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  bodyLight,
                                  bodyMid,
                                  baseColor,
                                  bodyDark,
                                ],
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 9,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: size * 0.18,
                            top: size * 0.19,
                            child: _buildEye(
                              size: size * 0.135,
                              blink: motion.blink,
                            ),
                          ),
                          Positioned(
                            right: size * 0.18,
                            top: size * 0.185,
                            child: _buildEye(
                              size: size * 0.135,
                              blink: motion.blink,
                            ),
                          ),
                          Positioned(
                            left: size * 0.17,
                            right: size * 0.17,
                            top: size * 0.305,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(size * 0.08),
                              child: Container(
                                height:
                                    size * (0.095 + 0.08 * motion.mouthOpen),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    size * 0.08,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color(0xFFEE6E57),
                                      Color(0xFFB83A2A),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 1.1,
                                  ),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1.2,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List<Widget>.generate(3, (
                                            int i,
                                          ) {
                                            return Container(
                                              width: size * 0.032,
                                              height: size * 0.022,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1.3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      size * 0.012,
                                                    ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: size * 0.15,
                                        height: size * 0.026,
                                        margin: const EdgeInsets.only(
                                          bottom: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFA3A3),
                                          borderRadius: BorderRadius.circular(
                                            size * 0.02,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -size * 0.02,
                            top: size * 0.24,
                            child: Container(
                              width: size * 0.24,
                              height: size * 0.16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  size * 0.09,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    bodyLight,
                                    baseColor,
                                    bodyDark,
                                  ],
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: size * 0.15,
                            top: size * 0.16,
                            child: Container(
                              width: size * 0.13,
                              height: size * 0.03,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: const Color(
                                  0xFF1F311B,
                                ).withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                          Positioned(
                            right: size * 0.15,
                            top: size * 0.155,
                            child: Container(
                              width: size * 0.13,
                              height: size * 0.03,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: const Color(
                                  0xFF1F311B,
                                ).withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                          Positioned(
                            right: size * 0.02,
                            top: size * 0.29,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: size * 0.028,
                                  height: size * 0.02,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: const Color(
                                      0xFF2C1E15,
                                    ).withValues(alpha: 0.55),
                                  ),
                                ),
                                SizedBox(width: size * 0.02),
                                Container(
                                  width: size * 0.028,
                                  height: size * 0.02,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: const Color(
                                      0xFF2C1E15,
                                    ).withValues(alpha: 0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: size * 0.24,
                            right: size * 0.24,
                            top: size * 0.39,
                            child: Container(
                              height: size * 0.085,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  size * 0.05,
                                ),
                                color: bellyColor.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.09,
                  top: size * 0.5,
                  child: _buildArm(
                    size: size * 0.2,
                    angle: motion.leftArmRotate,
                    start: baseColor,
                    end: bodyDark,
                  ),
                ),
                Positioned(
                  right: size * 0.1,
                  top: size * 0.49,
                  child: _buildArm(
                    size: size * 0.22,
                    angle: motion.rightArmRotate,
                    start: bodyLight,
                    end: baseColor,
                  ),
                ),
                Positioned(
                  left: size * 0.31,
                  bottom: size * 0.02,
                  child: _buildFoot(size: size * 0.15, color: bodyDark),
                ),
                Positioned(
                  right: size * 0.23,
                  bottom: size * 0.02,
                  child: _buildFoot(size: size * 0.15, color: bodyDark),
                ),
                Positioned(
                  left: size * 0.48,
                  top: size * 0.12,
                  child: Container(
                    width: size * 0.11,
                    height: size * 0.11,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.24),
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.24,
                  top: size * 0.36,
                  child: Container(
                    width: size * 0.05,
                    height: size * 0.05,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF9EA1),
                    ),
                  ),
                ),
                Positioned(
                  right: size * 0.24,
                  top: size * 0.36,
                  child: Container(
                    width: size * 0.05,
                    height: size * 0.05,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF9EA1),
                    ),
                  ),
                ),
                Positioned(
                  left: size * 0.29,
                  top: -size * 0.03,
                  child: SizedBox(
                    width: size * 0.4,
                    height: size * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List<Widget>.generate(3, (int index) {
                        final double spikeHeight =
                            size * (0.1 + (index * 0.015));
                        return Container(
                          width: size * 0.075,
                          height: spikeHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size * 0.05),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[bodyLight, bodyDark],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                if (badgeIcon != null)
                  Positioned(
                    right: -2,
                    top: size * 0.01,
                    child: Container(
                      width: size * 0.24,
                      height: size * 0.24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: badgeColor,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        badgeIcon,
                        color: Colors.white,
                        size: size * 0.12,
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

  Widget _buildEye({required double size, required bool blink}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: size,
      height: blink ? size * 0.2 : size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.white, Color(0xFFECECEC)],
        ),
        border: Border.all(color: const Color(0xFF2A1F16), width: 1.0),
      ),
      child: blink
          ? const SizedBox.shrink()
          : Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    width: size * 0.52,
                    height: size * 0.52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2A1F16),
                    ),
                  ),
                  Positioned(
                    left: size * 0.1,
                    top: size * 0.08,
                    child: Container(
                      width: size * 0.16,
                      height: size * 0.16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildArm({
    required double size,
    required double angle,
    required Color start,
    required Color end,
  }) {
    return Transform.rotate(
      angle: angle,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: size * 1.05,
        height: size * 1.2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              width: size,
              height: size * 1.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.68),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[start, end],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: List<Widget>.generate(3, (int index) {
                  return Container(
                    width: size * 0.12,
                    height: size * 0.1,
                    margin: EdgeInsets.only(left: index == 0 ? 0 : size * 0.03),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2DE),
                      borderRadius: BorderRadius.circular(size * 0.05),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoot({required double size, required Color color}) {
    return SizedBox(
      width: size * 1.2,
      height: size * 0.9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: size,
              height: size * 0.68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.5),
                color: color,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Row(
              children: List<Widget>.generate(3, (int index) {
                return Container(
                  width: size * 0.22,
                  height: size * 0.2,
                  margin: EdgeInsets.only(left: index == 0 ? 0 : size * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2DE),
                    borderRadius: BorderRadius.circular(size * 0.1),
                  ),
                );
              }),
            ),
          ),
        ],
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
    this.leftArmRotate = 0.18,
    this.rightArmRotate = -0.2,
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
  double leftArmRotate = 0.15 + loop * 0.045;
  double rightArmRotate = -0.17 - loop * 0.045;
  double tailRotate = loop * 0.14;

  switch (action) {
    case DinoAnimationAction.welcomeWave:
      bodyScale += sin(p * pi) * 0.25;
      rightArmRotate = -0.64 + sin(p * pi * 4) * 0.68;
      yShift -= sin(p * pi) * 8;
      headRotate += sin(p * pi * 2) * 0.06;
    case DinoAnimationAction.waveHi:
      rightArmRotate = -0.58 + sin(p * pi * 4) * 0.62;
      headRotate += sin(p * pi * 2) * 0.07;
    case DinoAnimationAction.waveBye:
      leftArmRotate = 0.58 + sin(p * pi * 4) * 0.62;
      headRotate += sin(p * pi * 2) * 0.07;
    case DinoAnimationAction.jump:
      yShift -= sin(p * pi).abs() * 20;
      rightArmRotate = -0.26;
      leftArmRotate = 0.26;
      tailRotate += sin(p * pi * 2) * 0.16;
    case DinoAnimationAction.spinAxis:
      bodyRotate += p * pi * 2;
      rightArmRotate = -0.22;
      leftArmRotate = 0.22;
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
      leftArmRotate = 0.22 + sin(p * pi * 4) * 0.25;
      rightArmRotate = -0.22 - sin(p * pi * 4) * 0.25;
      tailRotate += sin(p * pi * 4) * 0.22;
    case DinoAnimationAction.twirl:
      bodyRotate += sin(p * pi * 2) * 0.3;
      xShift += sin(p * pi * 2) * 3.8;
      tailRotate += sin(p * pi * 6) * 0.32;
    case DinoAnimationAction.tailWag:
      tailRotate += sin(p * pi * 8) * 0.7;
      bodyRotate += sin(p * pi * 4) * 0.04;
  }

  final double talk = speaking ? (0.3 + sin(idleT * pi * 10).abs() * 0.52) : 0;
  final double mouthOpen = speaking
      ? talk
      : max(0.1, 0.15 + sin(p * pi * 2).abs() * 0.05);
  final bool blink = sin(idleT * pi * 2 * 0.85) > 0.96;

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
