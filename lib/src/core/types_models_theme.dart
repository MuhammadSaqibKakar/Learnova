part of 'package:learnova/main.dart';

enum UserRole { admin, parent, kid }

/// Auth resolution result that routes a user to the right dashboard.
class LoginIdentity {
  const LoginIdentity({required this.role, this.child, this.parentEmail});

  final UserRole role;
  final ChildAccount? child;
  final String? parentEmail;
}

/// Demo/local child account model used by parent/admin management screens.
class ChildAccount {
  const ChildAccount({
    required this.id,
    required this.nickname,
    required this.username,
    required this.password,
    required this.level,
    this.createdAtEpoch = 0,
  });

  final String id;
  final String nickname;
  final String username;
  final String password;
  final String level;
  final int createdAtEpoch;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nickname': nickname,
      'username': username,
      'password': password,
      'level': level,
      'createdAtEpoch': createdAtEpoch,
    };
  }

  factory ChildAccount.fromMap(Map<String, dynamic> map) {
    return ChildAccount(
      id: '${map['id'] ?? ''}'.trim(),
      nickname: '${map['nickname'] ?? ''}'.trim(),
      username: '${map['username'] ?? ''}'.trim(),
      password: '${map['password'] ?? ''}'.trim(),
      level: '${map['level'] ?? ''}'.trim().isEmpty
          ? _levelLabelFromNumber(1)
          : '${map['level'] ?? ''}'.trim(),
      createdAtEpoch: map['createdAtEpoch'] is int
          ? map['createdAtEpoch'] as int
          : int.tryParse('${map['createdAtEpoch']}') ?? 0,
    );
  }
}

/// Demo/local parent account model used by admin management screens.
class ParentAccount {
  const ParentAccount({
    required this.id,
    required this.email,
    required this.password,
    required this.createdAtEpoch,
  });

  final String id;
  final String email;
  final String password;
  final int createdAtEpoch;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'createdAtEpoch': createdAtEpoch,
    };
  }

  factory ParentAccount.fromMap(Map<String, dynamic> map) {
    return ParentAccount(
      id: '${map['id'] ?? ''}'.trim(),
      email: '${map['email'] ?? ''}'.trim(),
      password: '${map['password'] ?? ''}'.trim(),
      createdAtEpoch: map['createdAtEpoch'] is int
          ? map['createdAtEpoch'] as int
          : int.tryParse('${map['createdAtEpoch']}') ?? 0,
    );
  }
}

typedef NavigationHandler = void Function(BuildContext context);
typedef LoginHandler =
    Future<String?> Function(
      BuildContext context,
      String identifier,
      String password,
    );
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
  brandPrimary: Color(0xFF1F7AE0),
  brandAccent: Color(0xFFFFA94D),
  heroAccent: Color(0xFF0EA5E9),
  textPrimary: Color(0xFF16324F),
  textSecondary: Color(0xFF53708C),
  surfaceSoft: Color(0xFFF5F9FF),
  borderSoft: Color(0xFFD8E6F8),
  borderStrong: Color(0xFFC1D7F2),
  error: Color(0xFFE05A66),
  success: Color(0xFF2F9E73),
  menuBackground: Color(0xFF1958A7),
  menuTile: Color(0x20FFFFFF),
  menuSubtext: Color(0xFFE5F1FF),
  menuDivider: Color(0x4F8AB7F0),
  noticeBackground: Color(0xFFFFF2DF),
  noticeBorder: Color(0xFFFFCF8D),
  noticeText: Color(0xFF7B5417),
  headerGradientStart: Color(0xFFEAF4FF),
  headerGradientEnd: Color(0xFFFDFEFF),
  backgroundGradientStart: Color(0xFFF0F7FF),
  backgroundGradientMid: Color(0xFFF9FBFF),
  backgroundGradientEnd: Color(0xFFEAF3FF),
  bubbleA: Color(0x338CC8FF),
  bubbleB: Color(0x33B8D9FF),
  bubbleC: Color(0x33FFD59A),
  bubbleD: Color(0x339FE4D2),
  logoGradientStart: Color(0xFF1F7AE0),
  logoGradientMid: Color(0xFF26A6E8),
  logoGradientEnd: Color(0xFFFFA94D),
  logoStar: Color(0xFFFFD45A),
  logoShadow: Color(0x333E78A8),
  cardShadow: Color(0x16346CA4),
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
