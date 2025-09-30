### Weekly Dashboard – Smart Weekly Task Planner

Modern, responsive Flutter app to plan, track, and complete your week. Weekly Dashboard combines fast local task management with cloud sync (Supabase), reminders, deep links, and multilingual support to help you stay on top of what matters.

---

### Table of Contents

- [Features](#features)
- [Screenshots / Demo](#screenshots--demo)
- [Installation & Setup](#installation--setup)
- [Environment Variables](#environment-variables)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

### Features

- **Supabase Authentication**: Email/Password (with Gmail-only check) and Google Sign-In via `supabase_flutter` and `google_sign_in`.
- **Deep Links**: Email verification and password reset flows using custom scheme `io.supabase.weeklydashboard://...` handled in `DeepLinkService`.
- **Password Reset & Email Verification**: OTP verification, resend cooldown, and secure session restoration.
- **Task Management (CRUD)**: Create, edit, delete, and complete weekly tasks with categories, priorities, notes, tags, and recurrence.
- **Reminders & Notifications**: Local notifications (Android/iOS) with timezone support using `flutter_local_notifications` and `timezone`.
- **Weekly Overview & Calendar**: Weekly stats, completion percentages, and a calendar picker via `table_calendar`.
- **Local-First Storage**: Fast offline persistence using `hive`/`hive_flutter` with background migration/sync to Supabase.
- **Themes & Personalization**: Light/Dark modes, dynamic primary color, and Material 3 theming via `AppTheme` and settings.
- **Localization**: English and Arabic with JSON files under `assets/i18n` via a custom `AppLocalizations` delegate.
- **Responsive UI**: Scales for mobile, tablet, and desktop with adaptive typography.
- **Observability**: Crash and performance monitoring via `sentry_flutter`.
- **Nice-to-haves**: Device preview during development, charts via `fl_chart`, SVG and Lottie support, sharing via `share_plus`.

Badges:  
![Flutter](https://img.shields.io/badge/Flutter-Ready-02569B?logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Build](https://img.shields.io/badge/Build-Local%20CI-blue)

---

### Screenshots / Demo

- Add images under `assets/screenshots/` and reference them here:
  - `assets/screenshots/home.png`
  - `assets/screenshots/statistics.png`
- Optional demo GIF/Video: link a hosted file (e.g., GitHub Releases) or embed GIF.

```md
![Home](assets/screenshots/home.png)
![Statistics](assets/screenshots/statistics.png)
```

---

### Installation & Setup

1. Clone the repo

```bash
git clone https://github.com/your-user/weekly_dash_board.git
cd weekly_dash_board
```

2. Install Flutter SDK 3.24+ and Dart 3.8+  
   This project targets Dart SDK constraint in `pubspec.yaml`: `sdk: ^3.8.1`.

3. Get dependencies

```bash
flutter pub get
```

4. Configure environment variables (see [Environment Variables](#environment-variables))

5. Run

```bash
# Android
flutter run -d android --dart-define-from-file=.env

# iOS (on macOS)
flutter run -d ios --dart-define-from-file=.env
```

---

### Environment Variables

This app reads sensitive configuration via `--dart-define` (compatible with CI and release builds). Create a `.env` file in the project root from the example below, or use separate files for dev/prod (`.env.dev`, `.env.prod`).

Required keys:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `GOOGLE_OAUTH_WEB_CLIENT_ID`
- `SENTRY_DSN`

See `env.example`:

```bash
cp env.example .env
```

Run with dart-define file:

```bash
flutter run --dart-define-from-file=.env
```

Or pass keys inline:

```bash
flutter run \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=GOOGLE_OAUTH_WEB_CLIENT_ID=... \
  --dart-define=SENTRY_DSN=...
```

Note: The codebase currently sets Sentry DSN via `String.fromEnvironment('SENTRY_DSN')`. Supabase URL/Anon Key and Google Client ID should also be provided via `--dart-define` and consumed in your bootstrapping (e.g., before `Supabase.initialize`).

---

### Usage

- Debug build

```bash
flutter run --dart-define-from-file=.env
```

- Release build (Android)

```bash
flutter build apk --release --dart-define-from-file=.env
```

- Release build (iOS)

```bash
flutter build ios --release --dart-define-from-file=.env
```

---

### Folder Structure

High-level overview based on the current project layout:

```text
lib/
  core/
    constants/            # Colors, icons, images
    models/               # Core app models (e.g., settings)
    services/             # Cross-cutting services (auth, notifications, deep links, migration, etc.)
    theme/                # Light/Dark themes and typography
    utils/                # Localization, styles, size config
    widgets/              # Reusable widgets and test helpers
  fetuers/                # Feature modules (home, settings, auth, splash, more)
    home/
      data/              # Hive service and data models
      presentation/      # Cubits and feature UI (views/widgets)
    settings/
      presentation/      # Settings cubit, states, and UI widgets
    sinIn_and_sinUp/     # Auth flows (sign-in, sign-up, reset/verify)
    splash/              # Splash screen and bootstrapping
  views/                  # Shell/dashboard layouts and drawer
  main.dart               # App entry, initialization (Sentry, Supabase, Hive, Notifications)

assets/
  i18n/                   # en.json, ar.json translations
  images/                 # Static images (incl. splash)
  fonts/                  # Montserrat fonts
```

Key implementation details:

- `main.dart`: Initializes Sentry, Supabase, Hive, notifications; wires `WeeklyCubit` and `SettingsCubit`; sets themes, locales, and `SplashView`.
- `SupabaseAuthService`: Email/Password signup with Gmail-only constraint, Google Sign-In, OTP verification/resend, password reset, deep link callbacks, local session caching, and post-login data migration/sync.
- `DeepLinkService`: Handles `io.supabase.weeklydashboard://login-callback` and `...://reset-password` links.
- `NotificationService`: Timezone-aware scheduling, updates, cancellation, permission prompts.
- `WeeklyCubit`: Core weekly task logic (CRUD, completion, recurrence, reminders, stats, day grouping), persists to Hive and schedules notifications.
- `HiveService`: Simple local persistence for tasks.
- `AppTheme`: Material 3 theming with dynamic color and responsive text.
- `AppLocalizations`: Loads translations from `assets/i18n` for EN/AR.

---

### Contributing

Contributions are welcome!

- Open an issue describing the problem or feature.
- Fork the repository and create a feature branch.
- Add tests or screenshots if applicable.
- Open a Pull Request with a clear description linked to the issue.

---

### License

This project is licensed under the MIT License. See `LICENSE` for details.

---

### Acknowledgments

- **Flutter** for the UI framework.
- **Supabase** for authentication and backend services.
- **Sentry** for monitoring.
- Libraries used: `flutter_bloc`, `hive`/`hive_flutter`, `flutter_local_notifications`, `timezone`, `google_sign_in`, `table_calendar`, `fl_chart`, `lottie`, `flutter_svg`, `share_plus`, `intl`, `package_info_plus`, `supabase_flutter`, and more (see `pubspec.yaml`).

### Weekly Dashboard

Modern, multilingual Flutter app to plan, track, and reflect on your week. It combines a responsive UI, offline-first task management (Hive), reminders via local notifications, and secure cloud sync and authentication powered by Supabase (Email/Password and Google). Deep links support email verification and password reset flows. The app includes light/dark themes, localization (English/Arabic), analytics/error reporting, and a clean architecture with BLoC.

---

### Table of Contents

- [Features](#features)
- [Screenshots / Demo](#screenshots--demo)
- [Installation & Setup](#installation--setup)
- [Environment Variables](#environment-variables)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

### Features

- **Authentication (Supabase)**: Email/Password sign-in and sign-up, email verification, OTP, and session handling.
- **Password Reset via Deep Links**: Custom scheme `io.supabase.weeklydashboard://reset-password/` handled in-app.
- **Deep Link Handling**: Email confirmation and OAuth callbacks via `io.supabase.weeklydashboard://login-callback/`.
- **Task Management (CRUD)**: Create, edit, delete, and complete tasks; recurring tasks; categories; priorities; tags; notes.
- **Reminders & Notifications**: Local scheduled notifications per task using `flutter_local_notifications` with timezone handling.
- **Offline-first Storage**: Local persistence using Hive with background sync/migration to Supabase.
- **Data Migration & Sync**: Intelligent merge of local tasks/settings with remote data on login.
- **Settings & Personalization**: Week start day, weekend days, reminder times, primary color, language, notifications toggle.
- **Theming**: Light/Dark/System themes with dynamic seed color.
- **Localization (en/ar)**: App content available in English and Arabic using Flutter localization + JSON assets.
- **Responsive UI**: Phone, tablet, and desktop-friendly layouts.
- **Search & Charts**: Fuse-based search and FL Chart-based statistics dashboards.
- **Error Reporting & Performance**: Sentry integration with tracing.

Badges:

![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-blue?logo=flutter)
![Dart SDK](https://img.shields.io/badge/Dart-3.8%2B-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Build](https://img.shields.io/badge/Build-passing-brightgreen)

---

### Screenshots / Demo

- Add screenshots in `assets/screenshots/` and reference them here.
  - Example: `![Home](assets/screenshots/home.png)`
- Demo video/GIF: attach a short clip showcasing task CRUD, reminders, and sign-in.

---

### Installation & Setup

1. **Clone the repo**

```bash
git clone https://github.com/your-org/weekly_dash_board.git
cd weekly_dash_board
```

2. **Flutter SDK**

- Tested with Flutter 3.24+ and Dart SDK ^3.8.1 (see `pubspec.yaml`).

3. **Install dependencies**

```bash
flutter pub get
```

4. **Configure environment**

- Copy `.env.example` to `.env` and fill your values (see [Environment Variables](#environment-variables)).
- For CI or release builds, pass values via `--dart-define`.

5. **Run**

```bash
flutter run -d android
flutter run -d ios
```

Android/iOS platform notes:

- Android 13+ requires runtime notification permission (handled in code).
- Ensure app icon and notification drawable are present (provided in `android/app/src/main/res`).
- iOS: enable push/notification capabilities if you expand features; local notifications already configured.

---

### Environment Variables

The app reads secrets via Dart-define and/or dotenv. Recommended: create `.env` from the example.

Required keys:

- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase public anon key
- `GOOGLE_OAUTH_WEB_CLIENT_ID`: Google OAuth Web Client ID
- `SENTRY_DSN`: Sentry DSN for error reporting

Files:

- `.env.example` – template committed to the repo
- `.env` – your local secrets (do not commit)

Usage options:

1. Dotenv

```bash
cp .env.example .env
# edit .env with your keys
```

2. Dart define

```bash
flutter run \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=GOOGLE_OAUTH_WEB_CLIENT_ID=... \
  --dart-define=SENTRY_DSN=...
```

---

### Usage

- Debug build:

```bash
flutter run
```

- Release build:

```bash
flutter build apk --release
flutter build ios --release
```

- Analyze & format:

```bash
flutter analyze
dart format .
```

---

### Folder Structure

High-level overview based on this repository:

```
lib/
  core/
    constants/            # Colors, icons, image constants
    models/               # App models (drawer, settings)
    services/             # Auth, deep links, notifications, data migration, search, stats
    theme/                # Light/Dark themes
    utils/                # Localization, styles, sizing
    widgets/              # Reusable widgets and test widgets
  fetuers/                # Feature modules (home, settings, auth, splash, more)
    home/
      data/
        models/          # Task, recurrence, weekly state, category models
        services/        # Hive local storage
      presentation/
        view_model/      # BLoC (WeeklyCubit, WeeklyState)
        views/           # Screens and widgets
    settings/            # Settings BLoC, screens, and widgets
    sinIn_and_sinUp/     # Auth screens (sign in, sign up, reset password, etc.)
    splash/              # Splash screen
    more/                # About, stats, contact, etc.
  views/                  # Responsive dashboard views/layouts

assets/
  i18n/                   # en.json, ar.json for localization
  images/                 # App images and splash
  fonts/                  # Montserrat font family

platform/                 # android, ios, macos, linux, windows, web
```

Key flows and modules:

- `SupabaseAuthService`: email/password, Google sign-in, OTP verify, resend, reset password, auth state, deep link handling.
- `DeepLinkService`: handles `login-callback` and `reset-password` custom scheme routes.
- `NotificationService`: timezone-aware local notifications, schedule/update/cancel.
- `DataMigrationService`: merges local (Hive) and remote (Supabase) data on login with conflict strategy.
- `WeeklyCubit`: CRUD, recurrence handling, scheduling notifications, weekly stats, and persistence.

---

### Contributing

Contributions are welcome!

- Open an issue describing the change or bug.
- Fork the repo and create a feature branch.
- Make your changes with clear commits and follow existing code style.
- Open a PR linking the issue. Include screenshots for UI changes.

---

### License

This project is licensed under the MIT License. See the `LICENSE` file (or replace with your chosen license).

---

### Acknowledgments

- **Flutter** – UI toolkit for building beautiful experiences.
- **Supabase** – Auth and Postgres-backed data platform.
- **Sentry** – Error monitoring and performance.
- **Hive** – Local, lightweight key-value database.
- **flutter_local_notifications** – Local notifications and scheduling.
- **flutter_bloc** – State management (BLoC).
- **fl_chart** – Charts for statistics.
- **fuse** – Fast in-memory search.

# weekly_dash_board

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
#   w e e k l y * a p p 
 
 #   w e e k l y * a p p 
 
 
#   w e e k l y _ a p p  
 