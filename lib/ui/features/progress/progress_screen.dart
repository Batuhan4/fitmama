import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/mood_entry.dart';
import '../../../data/models/sleep_entry.dart';
import '../../../data/models/weight_entry.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/id.dart';
import '../../core/widgets/fitmama_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _kg = TextEditingController();

  @override
  void dispose() {
    _kg.dispose();
    super.dispose();
  }

  static int _moodScore(MoodKind m) {
    switch (m) {
      case MoodKind.energetic:
        return 5;
      case MoodKind.happy:
        return 4;
      case MoodKind.tired:
        return 3;
      case MoodKind.stressed:
        return 2;
      case MoodKind.anxious:
        return 1;
    }
  }

  Future<void> _addWeight() async {
    final value = double.tryParse(_kg.text.trim().replaceAll(',', '.'));
    if (value == null || value <= 0) return;
    final entry = WeightEntry(
      id: uid(),
      date: todayKey(),
      kg: value,
    );
    await widget.repository.addWeight(entry);
    _kg.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final pro = widget.repository.pro;

    if (!pro) {
      return _ProPaywall(
        onUpgrade: () => widget.repository.setPro(true),
      );
    }

    final last14 = lastNDays(14);
    final weights = widget.repository.weights;
    final sleeps = widget.repository.sleeps
        .where((s) => s.who == SleeperType.mom)
        .toList();
    final moods = widget.repository.moods;
    final feeds = widget.repository.feedings;
    final exes = widget.repository.exercises;

    final weightSpots = <FlSpot>[];
    for (var i = 0; i < last14.length; i++) {
      final key = dateKey(last14[i]);
      final w = weights.where((x) => x.date == key).firstOrNull;
      if (w != null) weightSpots.add(FlSpot(i.toDouble(), w.kg));
    }

    final sleepSpots = <FlSpot>[];
    final moodSpots = <FlSpot>[];
    final feedBars = <BarChartGroupData>[];
    final exBars = <BarChartGroupData>[];
    for (var i = 0; i < last14.length; i++) {
      final key = dateKey(last14[i]);
      final sleepMin = sleeps
          .where((s) => s.start.substring(0, 10) == key)
          .fold<int>(0, (a, s) => a + s.durationMinutes);
      sleepSpots.add(FlSpot(i.toDouble(), sleepMin / 60));

      final mood = moods.where((m) => m.date == key).firstOrNull;
      moodSpots
          .add(FlSpot(i.toDouble(), mood == null ? 0 : _moodScore(mood.mood).toDouble()));

      final feedCount = feeds
          .where((f) => f.startedAt.substring(0, 10) == key)
          .length;
      feedBars.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: feedCount.toDouble(),
          color: scheme.primary,
          width: 6,
          borderRadius: BorderRadius.circular(4),
        )
      ]));

      final exMin = exes
          .where((e) => e.doneAt.substring(0, 10) == key)
          .fold<int>(0, (a, e) => a + e.durationMin);
      exBars.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: exMin.toDouble(),
          color: const Color(0xFF34D399),
          width: 6,
          borderRadius: BorderRadius.circular(4),
        )
      ]));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        FitmamaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.monitor_weight_outlined,
                      size: 16, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(t.progWeight,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _kg,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(hintText: t.progWeightKg),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addWeight,
                    icon: const Icon(Icons.add, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (weightSpots.length >= 2)
                SizedBox(
                  height: 120,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      titlesData: const FlTitlesData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weightSpots,
                          color: scheme.primary,
                          isCurved: true,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(t.progNoData,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      )),
                ),
              const SizedBox(height: 8),
              ...weights.take(5).map((w) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(w.date,
                            style: const TextStyle(fontSize: 12))),
                        Text('${w.kg} kg',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () =>
                              widget.repository.removeWeight(w.id),
                          icon: const Icon(Icons.delete_outline, size: 16),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _miniChart(t.progSleep, sleepSpots, 'line'),
        const SizedBox(height: 12),
        _miniChart(t.progMood, moodSpots, 'line'),
        const SizedBox(height: 12),
        _miniBar(t.progFeeding, feedBars),
        const SizedBox(height: 12),
        _miniBar(t.progExercise, exBars),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _miniChart(String title, List<FlSpot> spots, String type) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: const FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    color: scheme.primary,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBar(String title, List<BarChartGroupData> groups) {
    return FitmamaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: BarChart(
              BarChartData(
                barGroups: groups,
                borderData: FlBorderData(show: false),
                gridData:
                    const FlGridData(show: true, drawVerticalLine: false),
                titlesData: const FlTitlesData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProPaywall extends StatelessWidget {
  const _ProPaywall({required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        FitmamaCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [scheme.primary, scheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(Icons.workspace_premium_rounded,
                          color: scheme.onPrimary, size: 28),
                    ),
                    const SizedBox(height: 10),
                    Text(t.proBadge,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        )),
                    const SizedBox(height: 6),
                    Text(t.proTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: scheme.onPrimary)),
                    const SizedBox(height: 6),
                    Text(t.proSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.85),
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final f in [t.proF1, t.proF2, t.proF3, t.proF4])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_rounded,
                                color: scheme.primary, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(f,
                                    style: const TextStyle(fontSize: 13))),
                          ],
                        ),
                      ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(t.proPrice,
                              style: TextStyle(
                                fontSize: 11,
                                color: scheme.onSurfaceVariant,
                              )),
                          const SizedBox(height: 2),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '₺149',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                TextSpan(
                                  text: '/${t.proMonth}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: onUpgrade,
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: Text(t.proCta),
                    ),
                    const SizedBox(height: 6),
                    Text(t.proNote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: scheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
