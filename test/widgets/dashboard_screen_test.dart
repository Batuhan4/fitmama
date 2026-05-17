import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/models/profile.dart';
import 'package:fitmama/ui/features/dashboard/dashboard_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('renders greeting with profile name', (tester) async {
    final repo = await bootRepository();
    await repo.saveProfile(const Profile(
      name: 'Ayşe',
      babyBirthDate: '2026-04-12',
      birthType: BirthType.normal,
      createdAt: '2026-04-12T00:00:00Z',
    ));
    await pumpScreen(
      tester,
      (_) => DashboardScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    expect(find.textContaining('Ayşe'), findsWidgets);
    expect(find.textContaining('Henüz beslenme'), findsOneWidget);
  });

  testWidgets('water widget action updates repository state', (tester) async {
    final repo = await bootRepository();
    await repo.saveProfile(const Profile(
      name: 'X',
      babyBirthDate: '2026-04-12',
      birthType: BirthType.normal,
      createdAt: '2026-04-12T00:00:00Z',
    ));
    await pumpScreen(
      tester,
      (_) => DashboardScreen(repository: repo),
      repository: repo,
      size: const Size(420, 2200),
    );
    final add = find.byIcon(Icons.add_circle_outline_rounded);
    expect(add, findsWidgets);
    await tester.ensureVisible(add.first);
    await tester.tap(add.first);
    await tester.pumpAndSettle();
    expect(repo.waters.first.cups, 1);
  });
}
