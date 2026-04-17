# Learnova

Learnova is a role-based Flutter learning platform for children (ages 4 to 10), with responsive UX across mobile, tablet, laptop, desktop, and web.

## Roles
- Admin: manage users, lecture sequence, and quiz banks
- Parent: manage kids and review reports
- Kid: learn through stage-based lessons, quizzes, leaderboard, avatar system

## Current Feature Set

### Authentication
- Parent registration with OTP-style verification UI
- Login with email/username + password
- Forgot password with code verification
- Remember me (secure mode: identifier only)
- Login protection with temporary lockout after repeated failed attempts

### Dashboard Areas
- Admin dashboard with full management sections:
  - parent user CRUD (created date, edit, delete)
  - kid user CRUD (created date, level assignment)
  - subject content controls (English/Math/GK)
  - lecture sequence editor (add/edit/delete/reorder)
  - quiz question bank editor (add/edit/delete)
  - reset kid progress tools
- Parent dashboard:
  - kid management entry
  - kid reports and attempts history
- Kid dashboard:
  - streak, stars, level display
  - subjects: English, Math, GK
  - stage path progression and quiz unlock logic
  - avatars and leaderboard

### Learning Engine
- Level 1 currently includes 3 lecture paths per subject:
  - English: 3
  - Math: 3
  - GK: 3
- Stage unlock rule: minimum 6/10 quiz score
- Stars use best stage score model (no duplicate accumulation for same stage)

## Demo Credentials
- Admin: `admin@learnova.com` / `Learnova@123`
- Parent: `parent@learnova.com` / `Learnova@123`
- Kid 1: `sparkkid` / `Learnova@123`
- Kid 2: `novakid` / `Learnova@123`

## Tech Stack
- Flutter / Dart
- `shared_preferences`
- `flutter_tts`
- `google_fonts`

## Project Structure
```text
lib/
  main.dart
  src/
    app/
    core/
    features/
      auth/
      dashboard/
      splash/
backend/
  services/
    core-api/
    chatbox/
scripts/
  flutter_quality_gate.py
```

## Getting Started
```bash
flutter pub get
flutter run
```

## Quality Checks
```bash
python scripts/flutter_quality_gate.py --project .
```

Manual equivalents:
```bash
dart format --output=none --set-exit-if-changed lib test scripts
flutter analyze
flutter test -r compact
flutter build web --release
```

## CI
GitHub Actions workflow is included at:
- `.github/workflows/flutter-ci.yml`

## Documentation
- [Architecture](docs/ARCHITECTURE.md)
- [Security](docs/SECURITY.md)
- [Deployment](docs/DEPLOYMENT.md)

## Production Note
This repository is currently a frontend-first demo implementation. For large-scale production, move authentication, account storage, reporting, OTP, and content management to backend APIs with server-side authorization and audit logging.
