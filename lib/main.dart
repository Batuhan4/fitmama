import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

import 'data/repositories/app_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/home_widget_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/storage_service.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'ui/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.instance.ensureGoogleInit();
  await HomeWidget.setAppGroupId('group.com.momrise.momrise');
  await NotificationService.init();
  final storage = await StorageService.create();
  final repository = AppRepository(storage);
  // Sync today's water count to the widget on cold start.
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final cups = repository.waters
          .where((w) => w.date == today)
          .firstOrNull
          ?.cups ??
      0;
  await HomeWidgetService.pushWaterCups(cups);
  await HomeWidgetService.pushKcal(repository.todayKcal());
  final initialRoute = await HomeWidgetService.initialRouteFromWidget();
  runApp(MomriseApp(repository: repository, initialRoute: initialRoute));
}

class MomriseApp extends StatefulWidget {
  const MomriseApp({
    super.key,
    required this.repository,
    this.initialRoute,
  });

  final AppRepository repository;
  final String? initialRoute;

  @override
  State<MomriseApp> createState() => _MomriseAppState();
}

class _MomriseAppState extends State<MomriseApp> {
  late final GoRouter _router;
  StreamSubscription<String>? _widgetTaps;

  @override
  void initState() {
    super.initState();
    // Pass the widget-launch route as initialLocation so GoRouter starts
    // directly on the target page rather than briefly bouncing through
    // '/' → '/dashboard'.
    _router = buildRouter(
      widget.repository,
      initialLocation: widget.initialRoute,
    );
    _widgetTaps = HomeWidgetService.widgetTapRouteStream().listen((route) {
      _router.go(route);
    });
  }

  @override
  void dispose() {
    _widgetTaps?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'momrise',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode:
              widget.repository.isDark ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(widget.repository.language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: _router,
        );
      },
    );
  }
}
