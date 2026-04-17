import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'src/core/types_models_theme.dart';
part 'src/app/learnova_app.dart';
part 'src/core/services/cloud_sync.dart';
part 'src/features/auth/login_screen.dart';
part 'src/features/auth/register_screen.dart';
part 'src/features/auth/forgot_password_screen.dart';
part 'src/features/dashboard/parent_dashboard_screen.dart';
part 'src/features/dashboard/kid_management_screen.dart';
part 'src/features/dashboard/admin_dashboard_screen.dart';
part 'src/features/dashboard/dashboard_shells.dart';
part 'src/features/dashboard/lesson_content.dart';
part 'src/features/splash/learnova_splash_screen.dart';
part 'src/features/auth/auth_shell.dart';
part 'src/core/widgets/learnova_widgets.dart';
part 'src/core/widgets/dino_mascot.dart';
part 'src/core/utils/helpers.dart';

void main() {
  runApp(const LearnovaApp());
}
