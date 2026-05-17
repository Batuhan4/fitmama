import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../utils/date_utils.dart';

/// Bridge between Flutter state and the native Android home-screen widget.
/// Mirrors today's water (ml) and calorie totals into the SharedPreferences
/// instance the widget reads, then asks Android to repaint.
class HomeWidgetService {
  HomeWidgetService._();

  static const _androidWidgetName = 'WaterWidgetProvider';
  static const _stepMl = 200;

  static Future<void> pushWaterCups(int cups) async {
    if (!_isAndroid) return;
    final ml = cups * _stepMl;
    final today = todayKey();
    try {
      await HomeWidget.saveWidgetData<String>('mama_water_widget_day', today);
      await HomeWidget.saveWidgetData<int>('mama_water_widget_ml', ml);
      await HomeWidget.updateWidget(androidName: _androidWidgetName);
    } catch (e) {
      debugPrint('home widget water push failed: $e');
    }
  }

  static Future<void> pushKcal(int kcal) async {
    if (!_isAndroid) return;
    try {
      await HomeWidget.saveWidgetData<String>(
        'mama_kcal_widget_today',
        '${todayKey()}|$kcal',
      );
      await HomeWidget.updateWidget(androidName: _androidWidgetName);
    } catch (e) {
      debugPrint('home widget kcal push failed: $e');
    }
  }

  static bool get _isAndroid =>
      defaultTargetPlatform == TargetPlatform.android;

  /// Maps `momrise://nutrition` style URIs from the widget into GoRouter
  /// paths. Anything we don't recognise resolves to the dashboard.
  static String? routeFromUri(Uri? uri) {
    if (uri == null) return null;
    if (uri.scheme != 'momrise') return null;
    // We use the host segment of the URI (momrise://<host>) as the route
    // name because Android sees host=nutrition / exercise / etc. Path is
    // empty for those.
    final host = uri.host;
    switch (host) {
      case 'dashboard':
      case '':
        return '/dashboard';
      case 'nutrition':
        return '/nutrition';
      case 'exercise':
        return '/exercise';
      case 'progress':
        return '/progress';
      case 'water':
        return '/nutrition';
      default:
        return null;
    }
  }

  /// Resolves the route to push when the app cold-starts from a widget tap.
  /// Reads the pref the Kotlin widget code writes before firing the PendingIntent,
  /// then clears it. Falls back to the launch intent URI if the pref is empty.
  static Future<String?> initialRouteFromWidget() async {
    if (!_isAndroid) return null;
    try {
      final raw = await HomeWidget.getWidgetData<String>(
        'momrise_launch_route',
        defaultValue: '',
      );
      if (raw != null && raw.isNotEmpty) {
        await HomeWidget.saveWidgetData<String>(
          'momrise_launch_route',
          '',
        );
        final route = routeFromUri(Uri.tryParse(raw));
        if (route != null) return route;
      }
      final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      return routeFromUri(uri);
    } catch (_) {
      return null;
    }
  }

  /// Emits a GoRouter path each time the user taps a widget tile while the
  /// app is already running.
  static Stream<String> widgetTapRouteStream() {
    if (!_isAndroid) return const Stream<String>.empty();
    return HomeWidget.widgetClicked
        .map(routeFromUri)
        .where((path) => path != null)
        .cast<String>();
  }
}
