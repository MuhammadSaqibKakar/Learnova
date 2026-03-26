part of 'package:learnova/main.dart';

enum UserRole { admin, parent, kid }

class LoginIdentity {
  const LoginIdentity({required this.role, this.child});

  final UserRole role;
  final ChildAccount? child;
}

class ChildAccount {
  const ChildAccount({
    required this.id,
    required this.nickname,
    required this.username,
    required this.password,
    required this.level,
  });

  final String id;
  final String nickname;
  final String username;
  final String password;
  final String level;
}

typedef NavigationHandler = void Function(BuildContext context);
typedef LoginHandler =
    String? Function(BuildContext context, String identifier, String password);
typedef ResetPasswordHandler =
    String? Function(String email, String newPassword);
typedef RememberMeHandler =
    Future<void> Function(bool rememberMe, String identifier, String password);
typedef ThemePickerHandler = void Function(BuildContext context);

enum LearnovaVisualStyle { greenSpark, light, dark }

class LearnovaPalette extends ThemeExtension<LearnovaPalette> {
  const LearnovaPalette({
    required this.name,
    required this.brandPrimary,
    required this.brandAccent,
    required this.heroAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.surfaceSoft,
    required this.borderSoft,
    required this.borderStrong,
    required this.error,
    required this.success,
    required this.menuBackground,
    required this.menuTile,
    required this.menuSubtext,
    required this.menuDivider,
    required this.noticeBackground,
    required this.noticeBorder,
    required this.noticeText,
    required this.headerGradientStart,
    required this.headerGradientEnd,
    required this.backgroundGradientStart,
    required this.backgroundGradientMid,
    required this.backgroundGradientEnd,
    required this.bubbleA,
    required this.bubbleB,
    required this.bubbleC,
    required this.bubbleD,
    required this.logoGradientStart,
    required this.logoGradientMid,
    required this.logoGradientEnd,
    required this.logoStar,
    required this.logoShadow,
    required this.cardShadow,
  });

  final String name;
  final Color brandPrimary;
  final Color brandAccent;
  final Color heroAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color surfaceSoft;
  final Color borderSoft;
  final Color borderStrong;
  final Color error;
  final Color success;
  final Color menuBackground;
  final Color menuTile;
  final Color menuSubtext;
  final Color menuDivider;
  final Color noticeBackground;
  final Color noticeBorder;
  final Color noticeText;
  final Color headerGradientStart;
  final Color headerGradientEnd;
  final Color backgroundGradientStart;
  final Color backgroundGradientMid;
  final Color backgroundGradientEnd;
  final Color bubbleA;
  final Color bubbleB;
  final Color bubbleC;
  final Color bubbleD;
  final Color logoGradientStart;
  final Color logoGradientMid;
  final Color logoGradientEnd;
  final Color logoStar;
  final Color logoShadow;
  final Color cardShadow;

  @override
  LearnovaPalette copyWith({
    String? name,
    Color? brandPrimary,
    Color? brandAccent,
    Color? heroAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? surfaceSoft,
    Color? borderSoft,
    Color? borderStrong,
    Color? error,
    Color? success,
    Color? menuBackground,
    Color? menuTile,
    Color? menuSubtext,
    Color? menuDivider,
    Color? noticeBackground,
    Color? noticeBorder,
    Color? noticeText,
    Color? headerGradientStart,
    Color? headerGradientEnd,
    Color? backgroundGradientStart,
    Color? backgroundGradientMid,
    Color? backgroundGradientEnd,
    Color? bubbleA,
    Color? bubbleB,
    Color? bubbleC,
    Color? bubbleD,
    Color? logoGradientStart,
    Color? logoGradientMid,
    Color? logoGradientEnd,
    Color? logoStar,
    Color? logoShadow,
    Color? cardShadow,
  }) {
    return LearnovaPalette(
      name: name ?? this.name,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandAccent: brandAccent ?? this.brandAccent,
      heroAccent: heroAccent ?? this.heroAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      borderSoft: borderSoft ?? this.borderSoft,
      borderStrong: borderStrong ?? this.borderStrong,
      error: error ?? this.error,
      success: success ?? this.success,
      menuBackground: menuBackground ?? this.menuBackground,
      menuTile: menuTile ?? this.menuTile,
      menuSubtext: menuSubtext ?? this.menuSubtext,
      menuDivider: menuDivider ?? this.menuDivider,
      noticeBackground: noticeBackground ?? this.noticeBackground,
      noticeBorder: noticeBorder ?? this.noticeBorder,
      noticeText: noticeText ?? this.noticeText,
      headerGradientStart: headerGradientStart ?? this.headerGradientStart,
      headerGradientEnd: headerGradientEnd ?? this.headerGradientEnd,
      backgroundGradientStart:
          backgroundGradientStart ?? this.backgroundGradientStart,
      backgroundGradientMid:
          backgroundGradientMid ?? this.backgroundGradientMid,
      backgroundGradientEnd:
          backgroundGradientEnd ?? this.backgroundGradientEnd,
      bubbleA: bubbleA ?? this.bubbleA,
      bubbleB: bubbleB ?? this.bubbleB,
      bubbleC: bubbleC ?? this.bubbleC,
      bubbleD: bubbleD ?? this.bubbleD,
      logoGradientStart: logoGradientStart ?? this.logoGradientStart,
      logoGradientMid: logoGradientMid ?? this.logoGradientMid,
      logoGradientEnd: logoGradientEnd ?? this.logoGradientEnd,
      logoStar: logoStar ?? this.logoStar,
      logoShadow: logoShadow ?? this.logoShadow,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  LearnovaPalette lerp(ThemeExtension<LearnovaPalette>? other, double t) {
    if (other is! LearnovaPalette) {
      return this;
    }

    return LearnovaPalette(
      name: t < 0.5 ? name : other.name,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      heroAccent: Color.lerp(heroAccent, other.heroAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      menuBackground: Color.lerp(menuBackground, other.menuBackground, t)!,
      menuTile: Color.lerp(menuTile, other.menuTile, t)!,
      menuSubtext: Color.lerp(menuSubtext, other.menuSubtext, t)!,
      menuDivider: Color.lerp(menuDivider, other.menuDivider, t)!,
      noticeBackground: Color.lerp(
        noticeBackground,
        other.noticeBackground,
        t,
      )!,
      noticeBorder: Color.lerp(noticeBorder, other.noticeBorder, t)!,
      noticeText: Color.lerp(noticeText, other.noticeText, t)!,
      headerGradientStart: Color.lerp(
        headerGradientStart,
        other.headerGradientStart,
        t,
      )!,
      headerGradientEnd: Color.lerp(
        headerGradientEnd,
        other.headerGradientEnd,
        t,
      )!,
      backgroundGradientStart: Color.lerp(
        backgroundGradientStart,
        other.backgroundGradientStart,
        t,
      )!,
      backgroundGradientMid: Color.lerp(
        backgroundGradientMid,
        other.backgroundGradientMid,
        t,
      )!,
      backgroundGradientEnd: Color.lerp(
        backgroundGradientEnd,
        other.backgroundGradientEnd,
        t,
      )!,
      bubbleA: Color.lerp(bubbleA, other.bubbleA, t)!,
      bubbleB: Color.lerp(bubbleB, other.bubbleB, t)!,
      bubbleC: Color.lerp(bubbleC, other.bubbleC, t)!,
      bubbleD: Color.lerp(bubbleD, other.bubbleD, t)!,
      logoGradientStart: Color.lerp(
        logoGradientStart,
        other.logoGradientStart,
        t,
      )!,
      logoGradientMid: Color.lerp(logoGradientMid, other.logoGradientMid, t)!,
      logoGradientEnd: Color.lerp(logoGradientEnd, other.logoGradientEnd, t)!,
      logoStar: Color.lerp(logoStar, other.logoStar, t)!,
      logoShadow: Color.lerp(logoShadow, other.logoShadow, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}

const LearnovaPalette _greenSparkPalette = LearnovaPalette(
  name: 'Green Spark',
  brandPrimary: Color(0xFF58CC02),
  brandAccent: Color(0xFFFFC800),
  heroAccent: Color(0xFF58CC02),
  textPrimary: Color(0xFF27331A),
  textSecondary: Color(0xFF5B7342),
  surfaceSoft: Color(0xFFF7FFE9),
  borderSoft: Color(0xFFDDEFC8),
  borderStrong: Color(0xFFC8E7AB),
  error: Color(0xFFFF4B4B),
  success: Color(0xFF43A047),
  menuBackground: Color(0xFF4FB504),
  menuTile: Color(0x26FFFFFF),
  menuSubtext: Color(0xFFE9FFD6),
  menuDivider: Color(0x5697D469),
  noticeBackground: Color(0xFFFFF5DC),
  noticeBorder: Color(0xFFFFD889),
  noticeText: Color(0xFF7C5900),
  headerGradientStart: Color(0xFFEAFBD4),
  headerGradientEnd: Color(0xFFF7FFEC),
  backgroundGradientStart: Color(0xFFF5FFE8),
  backgroundGradientMid: Color(0xFFF9FFEF),
  backgroundGradientEnd: Color(0xFFF2FEE4),
  bubbleA: Color(0x33A7E06D),
  bubbleB: Color(0x33B2F2A4),
  bubbleC: Color(0x33FFD97C),
  bubbleD: Color(0x339ED9FF),
  logoGradientStart: Color(0xFF58CC02),
  logoGradientMid: Color(0xFF6ADF1F),
  logoGradientEnd: Color(0xFF1CB0F6),
  logoStar: Color(0xFFFFDC5A),
  logoShadow: Color(0x337CBF41),
  cardShadow: Color(0x1F8ABA4C),
);

const LearnovaPalette _lightPalette = LearnovaPalette(
  name: 'Light Theme',
  brandPrimary: Color(0xFF2E9E35),
  brandAccent: Color(0xFFFFCA62),
  heroAccent: Color(0xFF2E9E35),
  textPrimary: Color(0xFF1E3A1F),
  textSecondary: Color(0xFF4E6B4F),
  surfaceSoft: Color(0xFFF5FBF3),
  borderSoft: Color(0xFFDCECD8),
  borderStrong: Color(0xFFC6DEC0),
  error: Color(0xFFE05A66),
  success: Color(0xFF2E9E46),
  menuBackground: Color(0xFF2A7E37),
  menuTile: Color(0x14FFFFFF),
  menuSubtext: Color(0xFFE4F3DE),
  menuDivider: Color(0x4478B970),
  noticeBackground: Color(0xFFFFF4DF),
  noticeBorder: Color(0xFFFFD895),
  noticeText: Color(0xFF7B5B1C),
  headerGradientStart: Color(0xFFE8F7E3),
  headerGradientEnd: Color(0xFFF7FDF4),
  backgroundGradientStart: Color(0xFFEFF8E9),
  backgroundGradientMid: Color(0xFFF8FDF5),
  backgroundGradientEnd: Color(0xFFF2FAED),
  bubbleA: Color(0x33A5E286),
  bubbleB: Color(0x33B6E6B0),
  bubbleC: Color(0x33FFE59A),
  bubbleD: Color(0x3394D8C6),
  logoGradientStart: Color(0xFF248C3F),
  logoGradientMid: Color(0xFF43B04A),
  logoGradientEnd: Color(0xFF74C844),
  logoStar: Color(0xFFFFD862),
  logoShadow: Color(0x33508E59),
  cardShadow: Color(0x163E9151),
);

const LearnovaPalette _darkPalette = LearnovaPalette(
  name: 'Dark Theme',
  brandPrimary: Color(0xFF7CEB36),
  brandAccent: Color(0xFFFFC84A),
  heroAccent: Color(0xFF7CEB36),
  textPrimary: Color(0xFFF1F5F9),
  textSecondary: Color(0xFFC7D3E2),
  surfaceSoft: Color(0xFF0B1220),
  borderSoft: Color(0xFF27364E),
  borderStrong: Color(0xFF395071),
  error: Color(0xFFFF6B6B),
  success: Color(0xFF4ADE80),
  menuBackground: Color(0xFF0B1220),
  menuTile: Color(0x1AFFFFFF),
  menuSubtext: Color(0xFFCDD9E8),
  menuDivider: Color(0x3A5D7486),
  noticeBackground: Color(0xFF3B2A16),
  noticeBorder: Color(0xFF8F6A2C),
  noticeText: Color(0xFFF8D98E),
  headerGradientStart: Color(0xFF101A2E),
  headerGradientEnd: Color(0xFF0B1220),
  backgroundGradientStart: Color(0xFF0B1220),
  backgroundGradientMid: Color(0xFF111A2E),
  backgroundGradientEnd: Color(0xFF0A1020),
  bubbleA: Color(0x2E6CCB3A),
  bubbleB: Color(0x2448A5FF),
  bubbleC: Color(0x22FFC84A),
  bubbleD: Color(0x1D7C4DFF),
  logoGradientStart: Color(0xFF58CC02),
  logoGradientMid: Color(0xFF2EA043),
  logoGradientEnd: Color(0xFF1CB0F6),
  logoStar: Color(0xFFFFDD6E),
  logoShadow: Color(0x3328334D),
  cardShadow: Color(0x85000000),
);

LearnovaPalette _palette(BuildContext context) =>
    Theme.of(context).extension<LearnovaPalette>() ?? _greenSparkPalette;
