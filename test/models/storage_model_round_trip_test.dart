import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/data/models/exercise_session.dart';
import 'package:momrise/data/models/meal_entry.dart';
import 'package:momrise/data/models/reminder_config.dart';
import 'package:momrise/data/models/water_entry.dart';
import 'package:momrise/data/models/weight_entry.dart';

void main() {
  test('ExerciseSession round-trips', () {
    const s = ExerciseSession(
      id: 'e1',
      exerciseId: 'y1',
      category: 'yoga',
      durationMin: 12,
      doneAt: '2026-04-12T18:00:00Z',
    );
    final r = ExerciseSession.fromJson(s.toJson());
    expect(r.category, 'yoga');
    expect(r.durationMin, 12);
    expect(r.exerciseId, 'y1');
  });

  test('WaterEntry round-trips', () {
    const w = WaterEntry(id: '2026-04-12', date: '2026-04-12', cups: 5);
    final r = WaterEntry.fromJson(w.toJson());
    expect(r.cups, 5);
    expect(r.date, '2026-04-12');
  });

  test('MealEntry preserves optional calories', () {
    const m = MealEntry(
      id: 'm1',
      date: '2026-04-12',
      name: 'Yulaf',
      calories: 240,
      createdAt: '2026-04-12T08:00:00Z',
    );
    final r = MealEntry.fromJson(m.toJson());
    expect(r.calories, 240);

    final noCal = MealEntry(
      id: 'm2',
      date: '2026-04-12',
      name: 'Çay',
      createdAt: DateTime.now().toIso8601String(),
    );
    final r2 = MealEntry.fromJson(noCal.toJson());
    expect(r2.calories, isNull);
  });

  test('WeightEntry round-trips with doubles', () {
    const w = WeightEntry(id: 'w1', date: '2026-04-12', kg: 64.5);
    final r = WeightEntry.fromJson(w.toJson());
    expect(r.kg, 64.5);
  });

  test('ReminderConfig copyWith and serialization', () {
    const r = ReminderConfig(
      id: 'r1',
      kind: ReminderKind.water,
      enabled: false,
      intervalMin: 90,
    );
    final updated = r.copyWith(enabled: true, intervalMin: 60);
    expect(updated.enabled, isTrue);
    expect(updated.intervalMin, 60);
    final restored = ReminderConfig.fromJson(updated.toJson());
    expect(restored.kind, ReminderKind.water);
    expect(restored.intervalMin, 60);
  });
}
