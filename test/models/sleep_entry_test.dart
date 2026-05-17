import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/models/sleep_entry.dart';

void main() {
  test('SleepEntry computes duration in minutes', () {
    const entry = SleepEntry(
      id: 's1',
      who: SleeperType.mom,
      start: '2026-04-12T22:00:00Z',
      end: '2026-04-13T05:30:00Z',
      quality: 4,
    );
    expect(entry.durationMinutes, 450);
  });

  test('SleepEntry serializes and rebuilds', () {
    const entry = SleepEntry(
      id: 's2',
      who: SleeperType.baby,
      start: '2026-04-12T19:00:00Z',
      end: '2026-04-12T20:00:00Z',
      quality: 5,
    );
    final restored = SleepEntry.fromJson(entry.toJson());
    expect(restored.who, SleeperType.baby);
    expect(restored.quality, 5);
    expect(restored.durationMinutes, 60);
  });
}
