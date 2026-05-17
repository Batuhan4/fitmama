import 'package:flutter_test/flutter_test.dart';
import 'package:momrise/data/models/mood_entry.dart';

void main() {
  test('Mood entry round-trips and detects negative moods', () {
    const entry = MoodEntry(
      id: 'm1',
      date: '2026-04-12',
      mood: MoodKind.stressed,
      note: 'zor gün',
      createdAt: '2026-04-12T20:00:00Z',
    );
    final restored = MoodEntry.fromJson(entry.toJson());
    expect(restored.mood, MoodKind.stressed);
    expect(restored.note, 'zor gün');
    expect(negativeMoods.contains(restored.mood), isTrue);
  });

  test('happy and energetic are not flagged as negative', () {
    expect(negativeMoods.contains(MoodKind.happy), isFalse);
    expect(negativeMoods.contains(MoodKind.energetic), isFalse);
  });
}
