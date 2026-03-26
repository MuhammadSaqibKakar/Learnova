part of 'package:learnova/main.dart';

class SlideFadeIn extends StatelessWidget {
  const SlideFadeIn({
    required this.child,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 550 + delay.inMilliseconds),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? animatedChild) {
        final double scale = 0.96 + (0.04 * value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: Transform.scale(scale: scale, child: animatedChild),
          ),
        );
      },
      child: child,
    );
  }
}

bool _isValidEmail(String value) {
  return RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$').hasMatch(value);
}

String? _validateStrongPassword(String? value) {
  final String password = (value ?? '').trim();
  final RegExp pattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-]).{8,}$',
  );

  if (password.isEmpty) {
    return 'Enter password.';
  }
  if (!pattern.hasMatch(password)) {
    return 'Use 8+ chars with upper, lower, number, and symbol.';
  }
  return null;
}

void _showMessage(BuildContext context, String text, {required Color color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Text(text),
    ),
  );
}

BoxDecoration _cardDecoration(BuildContext context) {
  final LearnovaPalette palette = _palette(context);
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: isDark
        ? const Color(0xFF111C31).withValues(alpha: 0.96)
        : Colors.white.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: isDark ? palette.borderStrong : palette.borderSoft,
    ),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: isDark ? const Color(0xB3000000) : palette.cardShadow,
        blurRadius: 18,
        offset: const Offset(0, 9),
      ),
    ],
  );
}
