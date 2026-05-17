import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/utils/date_utils.dart';

void main() {
  test('todayKey returns ISO-8601 date for given time', () {
    final d = DateTime(2026, 4, 12, 14, 30);
    expect(todayKey(now: d), '2026-04-12');
  });

  test('dateKey formats arbitrary dates', () {
    expect(dateKey(DateTime(2026, 1, 3)), '2026-01-03');
  });

  test('startOfWeekMonday returns Monday of the same week', () {
    final wednesday = DateTime(2026, 4, 15);
    final monday = startOfWeekMonday(wednesday);
    expect(monday.year, 2026);
    expect(monday.month, 4);
    expect(monday.day, 13);
  });

  test('lastNDays returns N entries, oldest first', () {
    final days = lastNDays(7, from: DateTime(2026, 4, 12));
    expect(days, hasLength(7));
    expect(days.first.day, 6);
    expect(days.last.day, 12);
  });

  test('formatHm formats minute totals as h/d label', () {
    expect(formatHm(125), '2s 5d');
  });
}
