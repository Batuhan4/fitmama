import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/ui/features/more/more_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('renders all the navigable shortcuts', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => const MoreScreen(),
      repository: repo,
      size: const Size(420, 2000),
    );
    expect(find.textContaining('Uyku'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Videolar'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Bebek Gelişimi'), findsAtLeastNWidgets(1));
    expect(find.textContaining('İyileşme'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Kegel'), findsAtLeastNWidgets(1));
  });
}
