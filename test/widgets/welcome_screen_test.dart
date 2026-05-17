import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/ui/features/welcome/welcome_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('shows role cards by default', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => WelcomeScreen(repository: repo),
      repository: repo,
      size: const Size(420, 900),
    );
    expect(find.text('Ben anneyim'), findsWidgets);
    expect(find.text('Partner / Arkadaş'), findsOneWidget);
  });

  testWidgets('partner tap reveals the pairing code form', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => WelcomeScreen(repository: repo),
      repository: repo,
      size: const Size(420, 900),
    );
    await tester.tap(find.text('Eşleşme kodunu gir'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Bağlan'), findsOneWidget);
  });
}
