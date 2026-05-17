import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/ui/features/nutrition/nutrition_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('adding a meal persists it for today', (tester) async {
    final repo = await bootRepository();
    await pumpScreen(
      tester,
      (_) => NutritionScreen(repository: repo),
      repository: repo,
      size: const Size(420, 1600),
    );
    final inputs = find.byType(TextField);
    expect(inputs, findsAtLeastNWidgets(2));
    await tester.enterText(inputs.at(0), 'Kahvaltı');
    await tester.enterText(inputs.at(1), '320');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(repo.meals, hasLength(1));
    expect(repo.meals.first.name, 'Kahvaltı');
    expect(repo.meals.first.calories, 320);
  });
}
