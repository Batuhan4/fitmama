import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/ui/features/breathing/breathing_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('start button toggles to stop after tap', (tester) async {
    await pumpScreen(
      tester,
      (_) => const BreathingScreen(),
      size: const Size(420, 1000),
    );
    expect(find.text('Başlat'), findsOneWidget);
    await tester.tap(find.text('Başlat'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Durdur'), findsOneWidget);
    await tester.tap(find.text('Durdur'));
    await tester.pump(const Duration(milliseconds: 200));
  });
}
