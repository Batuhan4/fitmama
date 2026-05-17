import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/data/models/mood_entry.dart';
import 'package:momrise/ui/features/mood/mood_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('selecting a mood enables save and persists it', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => MoodScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1400),
    );
    await tester.tap(find.text('😊'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(repo.moods, hasLength(1));
    expect(repo.moods.first.mood, MoodKind.happy);
  });

  testWidgets('selecting a negative mood reveals support card', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => MoodScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1400),
    );
    await tester.tap(find.text('😣'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nefes egzersizi'), findsOneWidget);
  });
}
