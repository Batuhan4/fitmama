# FitMama

Kadına özel postpartum fitness & wellness companion (Flutter, TR/EN).

## Stack

- Flutter 3.41 / Dart 3.11
- `go_router` (ShellRoute + redirect)
- `shared_preferences` + `AppRepository extends ChangeNotifier`
- `fl_chart`, `google_fonts` (Inter), `intl`, `uuid`
- `flutter_localizations` + ARB (`lib/l10n/app_tr.arb`, `app_en.arb`)
- Firebase (auth, Firestore) — opsiyonel cloud sync

## Hızlı başla

```bash
flutter pub get
flutter run            # bağlı cihazda
flutter test           # tüm testler
flutter analyze        # lint
flutter build apk --debug
flutter build web --debug
```

## Mimari

- `lib/data/models/*` — plain Dart data classes (fromJson/toJson)
- `lib/data/services/storage_service.dart` — SharedPreferences wrapper
- `lib/data/repositories/app_repository.dart` — single source of truth (ChangeNotifier)
- `lib/ui/features/<feature>/` — feature ekranları
- `lib/ui/features/shell/app_shell.dart` — 5-tab bottom-nav Scaffold
- `lib/router/app_router.dart` — `buildRouter(repository)` → `GoRouter`
- `lib/ui/core/theme/app_theme.dart` — FitMama tema (light + dark, Material 3)

## Tasarım kaynağı

`docs/superpowers/specs/2026-05-17-fitmama-rebrand-design.md` — marka, tema token'ları, 5-tab IA, feature mapping, bileşen listesi.
