import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/ui/features/dashboard/water_quick_widget.dart';
import 'package:momrise/utils/date_utils.dart';

import 'test_harness.dart';

void main() {
  testWidgets('water widget renders empty state', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => WaterQuickWidget(repository: repo),
      repository: repo,
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(repo.waters, isEmpty);
  });

  testWidgets('tapping the + button persists count via repository',
      (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => WaterQuickWidget(repository: repo),
      repository: repo,
    );

    await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
    await tester.pumpAndSettle();

    final today = todayKey();
    expect(repo.waters.first.cups, 1);
    expect(repo.waters.first.date, today);

    await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
    await tester.pumpAndSettle();
    expect(repo.waters.first.cups, 2);

    await tester.tap(find.byIcon(Icons.remove_circle_outline_rounded));
    await tester.pumpAndSettle();
    expect(repo.waters.first.cups, 1);
  });
}
