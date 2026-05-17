import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/ui/features/reminders/reminders_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('toggling a reminder switch updates the repository', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => RemindersScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    final switches = find.byType(Switch);
    expect(switches, findsAtLeastNWidgets(1));
    await tester.tap(switches.first);
    await tester.pumpAndSettle();
    expect(repo.reminders.first.enabled, isTrue);
  });
}
