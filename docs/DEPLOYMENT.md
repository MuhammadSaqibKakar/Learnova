# Deployment Guide

## Prerequisites
- Flutter stable (3.38+)
- Dart SDK (3.10+)
- Android SDK / Xcode / Chrome (depending on target)

## Local Quality Gate
```bash
python scripts/flutter_quality_gate.py --project .
```

## Run Targets
```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

## Release Builds
```bash
flutter build apk --release
flutter build appbundle --release
flutter build web --release
flutter build windows --release
```

## CI
GitHub Actions workflow: `.github/workflows/flutter-ci.yml`
- `flutter pub get`
- format check
- analyze
- tests
- web release build

## Scaling Path
- Keep frontend responsive shell as is.
- Move user/content/report logic to backend APIs.
- Use feature flags and remote-config for lecture rollouts.
