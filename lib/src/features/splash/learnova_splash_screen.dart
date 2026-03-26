part of 'package:learnova/main.dart';

class LearnovaSplashScreen extends StatefulWidget {
  const LearnovaSplashScreen({super.key});

  @override
  State<LearnovaSplashScreen> createState() => _LearnovaSplashScreenState();
}

class _LearnovaSplashScreenState extends State<LearnovaSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.92,
    end: 1.06,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));

  late final Animation<double> _float = Tween<double>(
    begin: -7,
    end: 7,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const LearnovaAnimatedBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, _float.value),
                        child: Transform.scale(
                          scale: _scale.value,
                          child: child,
                        ),
                      );
                    },
                    child: const LearnovaLogo(size: 128),
                  ),
                  const SizedBox(height: 26),
                  const SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _AnimatedShimmerText(
                        text: 'Learnova',
                        fontSize: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Learning Adventures for Kids',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  const _AnimatedLoadingDots(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedShimmerText extends StatefulWidget {
  const _AnimatedShimmerText({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  State<_AnimatedShimmerText> createState() => _AnimatedShimmerTextState();
}

class _AnimatedShimmerTextState extends State<_AnimatedShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double center = _controller.value;
        final double start = (center - 0.28).clamp(0.0, 1.0);
        final double end = (center + 0.28).clamp(0.0, 1.0);

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                palette.textPrimary,
                palette.heroAccent,
                palette.textPrimary,
              ],
              stops: <double>[start, center, end],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.text,
        style: GoogleFonts.fredoka(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w600,
          color: palette.textPrimary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _AnimatedLoadingDots extends StatefulWidget {
  const _AnimatedLoadingDots();

  @override
  State<_AnimatedLoadingDots> createState() => _AnimatedLoadingDotsState();
}

class _AnimatedLoadingDotsState extends State<_AnimatedLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LearnovaPalette palette = _palette(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final int dotCount = ((_controller.value * 3).floor() % 3) + 1;
        final String dots = '.' * dotCount;
        return Text(
          'Loading$dots',
          style: TextStyle(
            fontSize: 15,
            color: palette.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }
}
