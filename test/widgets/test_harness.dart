import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/repositories/app_repository.dart';
import 'package:fitmama/data/services/storage_service.dart';
import 'package:fitmama/l10n/generated/app_localizations.dart';
import 'package:fitmama/ui/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppRepository> bootRepository([Map<String, Object>? seed]) async {
  SharedPreferences.setMockInitialValues(seed ?? <String, Object>{});
  final svc = await StorageService.create();
  return AppRepository(svc);
}

Widget _wrapBuilder(
  WidgetBuilder builder, {
  AppRepository? repository,
  Locale locale = const Locale('tr'),
}) {
  final listenable = repository ?? ChangeNotifier();
  return MaterialApp(
    theme: AppTheme.light(),
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(
      body: ListenableBuilder(
        listenable: listenable,
        builder: (context, _) => Builder(builder: builder),
      ),
    ),
  );
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget Function(BuildContext) builder, {
  AppRepository? repository,
  Size size = const Size(400, 1000),
  Locale locale = const Locale('tr'),
}) async {
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: _wrapBuilder(builder, repository: repository, locale: locale),
    ),
  );
  await tester.pumpAndSettle();
}
