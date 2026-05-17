import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/ui/features/progress/progress_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('shows Pro paywall for free users', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => ProgressScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    expect(find.text("Pro'ya geç"), findsOneWidget);
  });

  testWidgets('upgrade button flips the pro flag and renders charts',
      (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => ProgressScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    await tester.tap(find.text("Pro'ya geç"));
    await tester.pumpAndSettle();
    expect(repo.pro, isTrue);
    expect(find.text('Kilo'), findsOneWidget);
  });
}
