import 'package:fitmama/data/models/program_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('kProgramCatalog', () {
    test('has 8 programs', () {
      expect(kProgramCatalog.length, 8);
    });

    test('every program has 4 levels with ≥4 timed exercises', () {
      for (final p in kProgramCatalog) {
        expect(p.id, isNotEmpty, reason: 'program needs id');
        expect(p.title, isNotEmpty);
        expect(p.subtitle, isNotEmpty);
        expect(p.levels.length, 4,
            reason: '${p.id} should have 4 levels (got ${p.levels.length})');
        for (final l in p.levels) {
          expect(l.exercises.length, greaterThanOrEqualTo(4),
              reason: '${p.id} L${l.index} has only ${l.exercises.length} exercises');
          expect(l.estimatedMinutes, greaterThan(0));
          for (final ex in l.exercises) {
            expect(ex.seconds, greaterThan(0),
                reason: '${p.id} L${l.index} "${ex.name}" needs positive seconds');
            expect(ex.sets, greaterThan(0));
          }
        }
      }
    });

    test('level indices are sequential 0..3', () {
      for (final p in kProgramCatalog) {
        for (var i = 0; i < p.levels.length; i++) {
          expect(p.levels[i].index, i,
              reason: '${p.id} level at position $i has index ${p.levels[i].index}');
        }
      }
    });

    test('programById returns matching entry', () {
      expect(programById('core-recovery'), isNotNull);
      expect(programById('guclu-anne'), isNotNull);
      expect(programById('does-not-exist'), isNull);
    });

    test('every program has a meaningful XP reward path', () {
      for (final p in kProgramCatalog) {
        final xps = p.levels.map((l) => l.xpReward).toList();
        // XP must be monotonically non-decreasing across levels
        for (var i = 1; i < xps.length; i++) {
          expect(xps[i], greaterThanOrEqualTo(xps[i - 1]),
              reason: '${p.id} L$i XP regresses (${xps[i - 1]} -> ${xps[i]})');
        }
      }
    });
  });
}
