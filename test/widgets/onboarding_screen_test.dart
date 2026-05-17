import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/ui/features/onboarding/onboarding_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('first step shows welcome heading and name input',
      (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => OnboardingScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    expect(find.text('Hoş geldin anne'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('start button advances to step two', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => OnboardingScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    await tester.tap(find.text('Başla'));
    await tester.pumpAndSettle();
    expect(find.text('Doğum tarihi (bebeğin)'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
    expect(find.text('Sezaryen'), findsOneWidget);
  });
}
