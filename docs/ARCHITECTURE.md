# Architecture

## Overview
Learnova is a Flutter application for ages 4-10 with three roles:
- Admin
- Parent
- Kid

The app currently runs with local demo persistence (`shared_preferences`) and is structured to migrate cleanly to Node.js backend services.

## Frontend Structure

```text
lib/
  main.dart
  src/
    app/
      learnova_app.dart
    core/
      types_models_theme.dart
      utils/helpers.dart
      widgets/
    features/
      auth/
      dashboard/
      splash/
```

## State and Data
- App shell state lives in `learnova_app.dart`.
- Local user/content/progress persistence uses key-scoped shared preferences.
- Admin can override lectures/quiz banks per subject (English/Math/GK).
- Kid runtime loads admin overrides first, then falls back to default built-in content.

## Content Engine
- Subject path uses stage progression with unlock rules.
- Lecture modules and quiz banks are modeled with explicit DTO classes.
- Quiz results persist attempts, mistakes, stars, tests taken, and report metadata.

## Responsiveness
- Auth shell uses adaptive wide + compact layout.
- Dashboards are composed with constrained widths and responsive row/column switching.
- Desktop/tablet/mobile are all supported from one codebase.

## Backend Direction
A separate backend folder exists for service split:
- `backend/services/core-api`
- `backend/services/chatbox`

This keeps chatbox and core APIs independently deployable.
