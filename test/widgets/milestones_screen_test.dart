import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/data/models/profile.dart';
import 'package:momrise/ui/features/milestones/baby_milestones_screen.dart';
import 'package:momrise/ui/features/milestones/recovery_timeline_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('tapping a milestone toggles its done state', (tester) async {
    final repo = await bootRepository();
    await repo.saveProfile(const Profile(
      name: 'X',
      babyBirthDate: '2026-03-01',
      birthType: BirthType.normal,
      createdAt: '2026-03-01T00:00:00Z',
    ));
    await pumpScreen(
      tester,
      (_) => BabyMilestonesScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1800),
    );
    expect(find.text('İlk sosyal gülümseme'), findsOneWidget);
    await tester.tap(find.text('İlk sosyal gülümseme'));
    await tester.pumpAndSettle();
    expect(repo.milestones, contains('smile'));
  });

  testWidgets('recovery timeline highlights weeks-since header',
      (tester) async {
    final repo = await bootRepository();
    await repo.saveProfile(const Profile(
      name: 'X',
      babyBirthDate: '2026-04-01',
      birthType: BirthType.normal,
      createdAt: '2026-04-01T00:00:00Z',
    ));
    await pumpScreen(
      tester,
      (_) => RecoveryTimelineScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    expect(find.textContaining('hafta'), findsAtLeastNWidgets(1));
  });
}
