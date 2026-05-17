import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/models/feeding_entry.dart';
import 'package:fitmama/ui/features/feeding/feeding_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('shows empty history initially', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => FeedingScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    expect(find.textContaining('Henüz kayıt yok'), findsOneWidget);
  });

  testWidgets('switching to bottle reveals amount input and saves entry',
      (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => FeedingScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    await tester.tap(find.text('Biberon'));
    await tester.pumpAndSettle();
    final inputs = find.byType(TextField);
    expect(inputs, findsAtLeastNWidgets(1));
    await tester.enterText(inputs.first, '120');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(repo.feedings, hasLength(1));
    expect(repo.feedings.first.amountMl, 120);
    expect(repo.feedings.first.side, FeedingSide.bottle);
  });
}
