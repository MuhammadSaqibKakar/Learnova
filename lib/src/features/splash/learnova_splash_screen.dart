part of 'package:learnova/main.dart';

class LearnovaSplashScreen extends StatefulWidget {
  const LearnovaSplashScreen({super.key});

  @override
  State<LearnovaSplashScreen> createState() => _LearnovaSplashScreenState();
}

class _LearnovaSplashScreenState extends State<LearnovaSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loopController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat(reverse: true);

  Timer? _phaseTimer;
  int _phase = 0;

  @override
  void initState() {
    super.initState();
    _phaseTimer = Timer(const Duration(milliseconds: 1450), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = 1;
      });
    });
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF58CC02);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF6ADF14), green],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 520),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: _phase == 0
                  ? _SplashLogoPhase(
                      key: const ValueKey<String>('logo'),
                      animation: _loopController,
                    )
                  : _SplashWordmarkPhase(
                      key: const ValueKey<String>('wordmark'),
                      animation: _loopController,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashLogoPhase extends StatelessWidget {
  const _SplashLogoPhase({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double scale = 0.92 + (animation.value * 0.12);
        final double floatY = (animation.value - 0.5) * 14;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
            ),
            child: const Center(child: LearnovaLogo(size: 134)),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading...',
            style: GoogleFonts.nunito(
              fontSize: 22,
              color: Colors.white.withValues(alpha: 0.94),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashWordmarkPhase extends StatelessWidget {
  const _SplashWordmarkPhase({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double opacity = 0.7 + (animation.value * 0.3);
        return Opacity(opacity: opacity, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Learnova',
              style: GoogleFonts.fredoka(
                fontSize: 62,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Joyful Learning for Kids',
              style: GoogleFonts.nunito(
                fontSize: 21,
                color: Colors.white.withValues(alpha: 0.94),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
