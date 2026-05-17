import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/sleep_entry.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/id.dart';
import '../../core/widgets/fitmama_card.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  SleeperType _who = SleeperType.mom;

  DateTime _start = DateTime.now().subtract(const Duration(hours: 3));
  DateTime _end = DateTime.now();
  int _quality = 3;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        setState(() =>
            _who = _tab.index == 0 ? SleeperType.mom : SleeperType.baby);
      }
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    if (!_end.isAfter(_start)) return;
    final entry = SleepEntry(
      id: uid(),
      who: _who,
      start: _start.toIso8601String(),
      end: _end.toIso8601String(),
      quality: _quality,
    );
    await widget.repository.addSleep(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.sleepSave)));
  }

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (d == null) return null;
    if (!mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(d.year, d.month, d.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final today = todayKey();
    final entries = widget.repository.sleeps;
    final filtered = entries.where((e) => e.who == _who).toList();
    final todayTotal = filtered
        .where((e) => e.start.substring(0, 10) == today)
        .fold<int>(0, (acc, e) => acc + e.durationMinutes);

    final days = lastNDays(7);
    final chartSpots = <FlSpot>[];
    for (var i = 0; i < days.length; i++) {
      final key = dateKey(days[i]);
      final total = filtered
          .where((e) => e.start.substring(0, 10) == key)
          .fold<int>(0, (acc, e) => acc + e.durationMinutes);
      chartSpots.add(FlSpot(i.toDouble(), (total / 60.0)));
    }

    final locale = Localizations.localeOf(context).languageCode;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        TabBar(
          controller: _tab,
          tabs: [
            Tab(text: t.sleepMom),
            Tab(text: t.sleepBaby),
          ],
        ),
        const SizedBox(height: 12),
        AccentCard(
          color: const Color(0xFFA5B4FC),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.nightlight_round, size: 16),
                  const SizedBox(width: 6),
                  Text(t.sleepToday,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${todayTotal ~/ 60}s ${todayTotal % 60}d',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FitmamaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.sleepAddSession,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _dateField(t.sleepStart, _start, () async {
                final res = await _pickDateTime(_start);
                if (res != null) setState(() => _start = res);
              }),
              const SizedBox(height: 8),
              _dateField(t.sleepEnd, _end, () async {
                final res = await _pickDateTime(_end);
                if (res != null) setState(() => _end = res);
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(t.sleepQuality,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: 6),
                  Text('$_quality/5',
                      style: TextStyle(color: scheme.primary)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _quality = star),
                    icon: Icon(
                      star <= _quality
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: scheme.primary,
                      size: 28,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _save,
                child: Text(t.sleepSave),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FitmamaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.sleepWeekly,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: 2,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (v, _) {
                            final d = lastNDays(7)[v.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                DateFormat('EEE', locale).format(d),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartSpots,
                        color: scheme.primary,
                        barWidth: 3,
                        isCurved: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: scheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          FitmamaCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                t.sleepNoEntries,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...filtered.take(20).map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FitmamaCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${e.durationMinutes ~/ 60}s ${e.durationMinutes % 60}d · ⭐ ${e.quality}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${DateFormat('d MMM HH:mm', locale).format(DateTime.parse(e.start))} → ${DateFormat('HH:mm').format(DateTime.parse(e.end))}',
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.repository.removeSleep(e.id),
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 18),
                    ),
                  ],
                ),
              ),
            );
          }),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _dateField(String label, DateTime value, VoidCallback onTap) {
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.calendar_today_rounded, size: 14),
          label: Text(
              DateFormat('d MMM y HH:mm', locale).format(value)),
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            minimumSize: const Size.fromHeight(46),
          ),
        ),
      ],
    );
  }
}
