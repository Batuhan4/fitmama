import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    _month = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivite geçmişi'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          SectionHeader(
            title: 'Yıllık aktivite',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          FitmamaCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '184 aktivite günü',
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      DateTime.now().year.toString(),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Text('Son 12 ay',
                    style: theme.textTheme.bodySmall),
                const SizedBox(height: 14),
                const _ContributionGrid(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Az',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(width: 6),
                    for (final a in const [0.0, 0.25, 0.5, 0.75, 1.0]) ...[
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: _cellColor(a),
                        ),
                      ),
                    ],
                    const SizedBox(width: 6),
                    Text('Çok',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              IconButton.outlined(
                onPressed: () => setState(() {
                  _month =
                      DateTime(_month.year, _month.month - 1);
                }),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  _monthLabel(_month),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              IconButton.outlined(
                onPressed: () => setState(() {
                  _month =
                      DateTime(_month.year, _month.month + 1);
                }),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CalendarGrid(month: _month),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Günün detayı',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          _SelectedDayCard(),
        ],
      ),
    );
  }
}

String _monthLabel(DateTime d) {
  const names = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];
  return '${names[d.month - 1]} ${d.year}';
}

Color _cellColor(double intensity) {
  final clamped = intensity.clamp(0.0, 1.0);
  if (clamped == 0) {
    return AppPalette.darkSurfaceRaised;
  }
  return Color.lerp(
        AppPalette.primary.withValues(alpha: 0.25),
        AppPalette.primary,
        clamped,
      ) ??
      AppPalette.primary;
}

class _ContributionGrid extends StatelessWidget {
  const _ContributionGrid();

  @override
  Widget build(BuildContext context) {
    const cols = 52;
    const rows = 7;
    final rnd = math.Random(42);
    final values = List.generate(
      cols * rows,
      (_) {
        final r = rnd.nextDouble();
        if (r < 0.45) return 0.0;
        if (r < 0.7) return 0.3;
        if (r < 0.9) return 0.6;
        return 1.0;
      },
    );
    return LayoutBuilder(builder: (context, c) {
      final cell = ((c.maxWidth - 4) / cols) - 2;
      return SizedBox(
        height: rows * (cell + 2) + 2,
        child: Stack(
          children: [
            for (var col = 0; col < cols; col++)
              for (var row = 0; row < rows; row++)
                Positioned(
                  left: col * (cell + 2),
                  top: row * (cell + 2),
                  width: cell,
                  height: cell,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: _cellColor(values[col * rows + row]),
                    ),
                  ),
                ),
          ],
        ),
      );
    });
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.month});
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leading = (first.weekday + 6) % 7; // monday = 0
    final total = leading + daysInMonth;
    final rows = (total / 7).ceil();
    final rnd = math.Random(month.month * 31 + month.year);

    final headers = const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              for (final h in headers)
                Expanded(
                  child: Center(
                    child: Text(
                      h,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurfaceVariant),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (var r = 0; r < rows; r++) ...[
            Row(
              children: [
                for (var c = 0; c < 7; c++) ...[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _DayCell(
                        day: (r * 7 + c) - leading + 1,
                        valid:
                            (r * 7 + c) >= leading &&
                            (r * 7 + c) < leading + daysInMonth,
                        intensity: rnd.nextDouble() > 0.45
                            ? rnd.nextDouble() * 0.9 + 0.1
                            : 0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell(
      {required this.day, required this.valid, required this.intensity});
  final int day;
  final bool valid;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!valid) return const SizedBox.shrink();
    final color = _cellColor(intensity);
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: intensity > 0.4 ? Colors.white : scheme.onSurface,
        ),
      ),
    );
  }
}

class _SelectedDayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('15 Mayıs · Pazartesi',
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16)),
          Text('Toplam 3 aktivite · 45 dk',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 14),
          _ActivityRow(
              icon: Icons.self_improvement_rounded,
              color: AppPalette.primary,
              name: 'Core Recovery',
              meta: '20 dk · 180 kcal'),
          const SizedBox(height: 8),
          _ActivityRow(
              icon: Icons.directions_walk_rounded,
              color: AppPalette.accentGreen,
              name: 'Günlük yürüyüş',
              meta: '15 dk · 95 kcal'),
          const SizedBox(height: 8),
          _ActivityRow(
              icon: Icons.water_drop_rounded,
              color: AppPalette.accentBlue,
              name: 'Su tüketimi',
              meta: '2.4 / 2.5 L'),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.color,
    required this.name,
    required this.meta,
  });
  final IconData icon;
  final Color color;
  final String name;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13.5)),
              Text(meta,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
