import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/feeding_entry.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/id.dart';
import '../../core/widgets/momrise_card.dart';
import 'feeding_schedule_card.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  FeedingSide _side = FeedingSide.left;
  DateTime? _started;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final _bottle = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _bottle.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _started = DateTime.now();
      _elapsed = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_started == null) return;
      setState(() => _elapsed = DateTime.now().difference(_started!));
    });
  }

  Future<void> _stop() async {
    if (_started == null) return;
    final entry = FeedingEntry(
      id: uid(),
      startedAt: _started!.toIso8601String(),
      durationSec: _elapsed.inSeconds,
      side: _side,
    );
    _timer?.cancel();
    _timer = null;
    setState(() {
      _started = null;
      _elapsed = Duration.zero;
    });
    await widget.repository.addFeeding(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).feedSave)),
    );
  }

  Future<void> _addBottle() async {
    final ml = int.tryParse(_bottle.text.trim());
    if (ml == null || ml <= 0) return;
    final entry = FeedingEntry(
      id: uid(),
      startedAt: DateTime.now().toIso8601String(),
      durationSec: 0,
      side: FeedingSide.bottle,
      amountMl: ml,
    );
    _bottle.clear();
    await widget.repository.addFeeding(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).feedSave)),
    );
  }

  Future<void> _confirmDelete(FeedingEntry e) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(t.feedDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.commonDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await widget.repository.removeFeeding(e.id);
    }
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString();
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final entries = widget.repository.feedings;

    final today = DateTime.now();
    final chartData = lastNDays(7, from: today).asMap().entries.map((mapEntry) {
      final i = mapEntry.key;
      final d = mapEntry.value;
      final key = dateKey(d);
      final count =
          entries.where((e) => e.startedAt.substring(0, 10) == key).length;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: scheme.primary,
            width: 16,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    final running = _started != null;
    final locale = Localizations.localeOf(context).languageCode;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        FeedingScheduleCard(repository: widget.repository),
        const SizedBox(height: 12),
        MomriseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.child_friendly_rounded,
                      size: 16, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(t.feedTimer,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final s in FeedingSide.values) ...[
                    Expanded(
                      child: _sideButton(
                        s,
                        s == FeedingSide.left
                            ? t.feedLeft
                            : s == FeedingSide.right
                                ? t.feedRight
                                : t.feedBottle,
                        disabled: running && s != _side,
                      ),
                    ),
                    if (s != FeedingSide.bottle) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              if (_side == FeedingSide.bottle)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bottle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: t.feedAmount),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addBottle,
                      child: Text(t.feedSave),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      _fmt(_elapsed.inSeconds),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: running
                          ? ElevatedButton.icon(
                              onPressed: _stop,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              icon: const Icon(Icons.stop_rounded),
                              label: Text(t.feedStop),
                            )
                          : ElevatedButton.icon(
                              onPressed: _start,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: Text(t.feedStart),
                            ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MomriseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.feedWeekly,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    barGroups: chartData,
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: 1,
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
                          getTitlesWidget: (v, _) {
                            final d = lastNDays(7, from: today)[v.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
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
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(t.feedHistory,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          MomriseCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                t.feedNoEntries,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...entries.take(30).map((e) {
            final label = e.amountMl != null
                ? '${_sideLabel(e.side, t)} • ${e.amountMl} ml'
                : '${_sideLabel(e.side, t)} • ${t.feedMinutes((e.durationSec / 60).round())}';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MomriseCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            DateFormat('d MMM HH:mm', locale)
                                .format(DateTime.parse(e.startedAt)),
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _confirmDelete(e),
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

  String _sideLabel(FeedingSide s, AppLocalizations t) {
    switch (s) {
      case FeedingSide.left:
        return t.feedLeft;
      case FeedingSide.right:
        return t.feedRight;
      case FeedingSide.bottle:
        return t.feedBottle;
    }
  }

  Widget _sideButton(FeedingSide s, String label,
      {bool disabled = false}) {
    final active = _side == s;
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: disabled ? null : () => setState(() => _side = s),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? scheme.primary : scheme.outline,
            width: active ? 2 : 1,
          ),
          color: active
              ? scheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: disabled
                ? scheme.onSurfaceVariant
                : active
                    ? scheme.onSurface
                    : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
