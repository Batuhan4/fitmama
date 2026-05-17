import 'package:intl/intl.dart';

String todayKey({DateTime? now}) {
  final d = now ?? DateTime.now();
  return DateFormat('yyyy-MM-dd').format(d);
}

String dateKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime startOfWeekMonday(DateTime d) {
  final day = startOfDay(d);
  final wd = day.weekday; // Mon = 1
  return day.subtract(Duration(days: wd - 1));
}

List<DateTime> lastNDays(int n, {DateTime? from}) {
  final base = startOfDay(from ?? DateTime.now());
  return List<DateTime>.generate(n, (i) => base.subtract(Duration(days: n - 1 - i)));
}

String shortWeekday(DateTime d, {String? locale}) {
  return DateFormat('EEE', locale).format(d);
}

String formatHm(int totalMinutes, {String hSuffix = 's', String mSuffix = 'd'}) {
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  return '$h$hSuffix $m$mSuffix';
}
