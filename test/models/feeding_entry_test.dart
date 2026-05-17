import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/models/feeding_entry.dart';

void main() {
  test('FeedingEntry round-trips for breast feeding', () {
    const entry = FeedingEntry(
      id: 'f1',
      startedAt: '2026-04-12T10:00:00.000Z',
      durationSec: 420,
      side: FeedingSide.left,
    );
    final restored = FeedingEntry.fromJson(entry.toJson());
    expect(restored.id, 'f1');
    expect(restored.side, FeedingSide.left);
    expect(restored.durationSec, 420);
    expect(restored.amountMl, isNull);
  });

  test('FeedingEntry preserves bottle amounts', () {
    const entry = FeedingEntry(
      id: 'f2',
      startedAt: '2026-04-12T11:00:00.000Z',
      durationSec: 0,
      side: FeedingSide.bottle,
      amountMl: 120,
    );
    final json = entry.toJson();
    expect(json['amountMl'], 120);
    final restored = FeedingEntry.fromJson(json);
    expect(restored.amountMl, 120);
    expect(restored.side, FeedingSide.bottle);
  });

  test('Unknown side defaults to left', () {
    final restored = FeedingEntry.fromJson({
      'id': 'x',
      'startedAt': '2026-04-12T00:00:00Z',
      'durationSec': 60,
      'side': 'bogus',
    });
    expect(restored.side, FeedingSide.left);
  });
}
