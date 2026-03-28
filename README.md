# Learnova

Learnova is a kid-focused Flutter learning app (ages 4 to 10) with role-based flows for **Admin**, **Parent**, and **Kid** users.  
The UI is responsive for mobile/tablet/desktop and currently uses a front-end demo data model with local persistence via SharedPreferences.

## Current Product Scope

### Authentication
- Parent registration (OTP-style flow UI)
- Login with email/username + password
- Remember Me support (saves both identifier and password)
- Forgot password flow
- Dual splash experience

### Themes and Visual System
- `Green Spark` (default)
- `Light Theme`
- `Dark Theme`
- Theme picker on login and selected screens

### Parent Area
- Parent dashboard with kid management entry
- Full kid management page
- Add, edit, delete kid accounts
- Kid level assignment
- Kid reports and attempts history integration

### Kid Area
- Kid dashboard with nickname, level, streak, stars
- Avatar system and avatar selection
- Subject cards and level-based path map
- Subject lecture flow with Dino instructor + TTS
- Quiz flow with explanations and score tracking
- Stars persisted by best stage score model

### Level 1 Lectures (Implemented)
- **English**: 3 lectures
- **Math**: 3 lectures
- **Urdu**: 3 lectures
- Each lecture contains a 30-slide lesson path (learn/practice/use pattern)
- Stage unlock rule: minimum `6/10` quiz score

### Admin Area
- Admin dashboard foundation and access route
- Role entry in same auth system
- Ready for backend integration and advanced controls

## Demo Credentials

- Admin: `admin@learnova.com` / `Learnova@123`
- Parent: `parent@learnova.com` / `Learnova@123`
- Kid username (seed): `sparkkid` / `Learnova@123`
- Kid username (seed): `novakid` / `Learnova@123`

## Tech Stack

- Flutter (Dart)
- `flutter_tts`
- `shared_preferences`
- `google_fonts`

## Project Structure

```text
lib/
  main.dart
  src/
    app/
    core/
      types_models_theme.dart
      widgets/
      utils/
    features/
      auth/
      dashboard/
      splash/
```

## Run Locally

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
flutter analyze
flutter test -r compact
```

## Notes

- Current app state is front-end heavy and uses local persistence.
- Backend integration (Node.js) is planned for auth, content, reports, and chatbox modules.
- Lecture and quiz engines are structured for future scaling by level, subject, and content packs.
