part of 'package:learnova/main.dart';

class LearnovaLogo extends StatelessWidget {
  const LearnovaLogo({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.logoGradientStart,
            palette.logoGradientMid,
            palette.logoGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.logoShadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: size * 0.52,
          ),
          Positioned(
            right: size * 0.16,
            top: size * 0.12,
            child: Icon(
              Icons.star_rounded,
              color: palette.logoStar,
              size: size * 0.24,
            ),
          ),
        ],
      ),
    );
  }
}

class LearnovaAnimatedBackground extends StatelessWidget {
  const LearnovaAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.backgroundGradientStart,
            palette.backgroundGradientMid,
            palette.backgroundGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          _FloatingBubble(
            alignment: Alignment(-0.9, -0.65),
            size: 220,
            color: palette.bubbleA,
            periodInMs: 3500,
          ),
          _FloatingBubble(
            alignment: Alignment(0.88, -0.82),
            size: 170,
            color: palette.bubbleB,
            periodInMs: 2900,
          ),
          _FloatingBubble(
            alignment: Alignment(-0.76, 0.82),
            size: 180,
            color: palette.bubbleC,
            periodInMs: 3200,
          ),
          _FloatingBubble(
            alignment: Alignment(0.88, 0.72),
            size: 200,
            color: palette.bubbleD,
            periodInMs: 3800,
          ),
        ],
      ),
    );
  }
}

class _FloatingBubble extends StatefulWidget {
  const _FloatingBubble({
    required this.alignment,
    required this.size,
    required this.color,
    required this.periodInMs,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final int periodInMs;

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.periodInMs),
  )..repeat(reverse: true);

  late final Animation<double> _wave = Tween<double>(
    begin: -8,
    end: 8,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: AnimatedBuilder(
        animation: _wave,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, _wave.value),
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
