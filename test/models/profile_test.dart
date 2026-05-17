import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/data/models/profile.dart';

void main() {
  group('Profile JSON', () {
    test('round-trips through JSON without losing data', () {
      const profile = Profile(
        name: 'Ayşe',
        babyBirthDate: '2026-04-12',
        birthType: BirthType.csection,
        healthTags: ['bp', 'thyroid'],
        healthOther: 'Reflü',
        allergens: ['milk'],
        dislikes: ['fish'],
        feedingStyle: ['mixed'],
        goals: [Goal.sleep, Goal.mood],
        createdAt: '2026-04-12T08:00:00.000Z',
      );
      final json = profile.toJson();
      final restored = Profile.fromJson(json);
      expect(restored.name, 'Ayşe');
      expect(restored.birthType, BirthType.csection);
      expect(restored.healthTags, contains('thyroid'));
      expect(restored.healthOther, 'Reflü');
      expect(restored.allergens, ['milk']);
      expect(restored.goals, [Goal.sleep, Goal.mood]);
    });

    test('falls back to defaults on missing fields', () {
      final json = <String, dynamic>{'name': 'X'};
      final p = Profile.fromJson(json);
      expect(p.name, 'X');
      expect(p.birthType, BirthType.normal);
      expect(p.goals, isEmpty);
      expect(p.allergens, isEmpty);
    });

    test('unknown enum strings degrade gracefully', () {
      final p = Profile.fromJson({
        'name': 'X',
        'babyBirthDate': '2026-04-12',
        'birthType': 'unknown',
        'goals': ['sleep', 'invalid', 'mood'],
        'createdAt': '2026-04-12T00:00:00Z',
      });
      expect(p.birthType, BirthType.normal);
      expect(p.goals, [Goal.sleep, Goal.mood]);
    });

    test('copyWith updates selected fields', () {
      const p = Profile(
        name: 'A',
        babyBirthDate: '2026-04-12',
        birthType: BirthType.normal,
        createdAt: '2026-04-12T00:00:00Z',
      );
      final next = p.copyWith(name: 'B', goals: [Goal.weight]);
      expect(next.name, 'B');
      expect(next.babyBirthDate, '2026-04-12');
      expect(next.goals, [Goal.weight]);
    });
  });
}
