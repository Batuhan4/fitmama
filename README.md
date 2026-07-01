# FitMama

FitMama is a mobile postpartum fitness and wellness app built with Flutter for iOS and Android.

It helps mothers track recovery-friendly routines, nutrition, hydration, mood, sleep, feeding, milestones, reminders, and progress in one calm mobile experience.

## Mobile app focus

- Built with Flutter for Android and iOS
- Bottom-tab mobile navigation
- Postpartum-friendly fitness and wellness flows
- Local-first app data with optional Firebase sync
- Multi-language UI powered by Flutter localization

## Demo

<video src="https://github.com/Batuhan4/fitmama/raw/main/assets/demo/fitmama-demo.mp4" controls width="320"></video>

If the preview does not render, open `assets/demo/fitmama-demo.mp4`.

## Tech stack

- Flutter / Dart
- Material 3
- `go_router`
- `shared_preferences`
- Firebase Auth and Firestore for optional cloud sync
- Flutter localizations with ARB files

## Run locally

```bash
flutter pub get
flutter run
flutter test
flutter analyze
```

## Project structure

```text
lib/data/       Data models, services, and repositories
lib/router/     App routing
lib/ui/         Mobile screens, shell navigation, and theme
lib/l10n/       Localization files
assets/         Branding, images, and fonts
android/        Android app project
ios/            iOS app project
```
