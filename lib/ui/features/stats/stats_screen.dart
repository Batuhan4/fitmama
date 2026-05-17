import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';
import '../shell/top_bar.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _range = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FitmamaTopBar(
          repository: widget.repository,
          actions: [
            _CalendarPill(
              label: 'Takvim',
              onTap: () => context.push('/activity'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child:
              Text(t.statsTitle, style: theme.textTheme.displaySmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Flexible(
                  child: Text(t.statsSubtitle,
                      style: theme.textTheme.bodyMedium)),
              const SizedBox(width: 4),
              const Text('💪', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        _RangeTabs(
          selected: _range,
          onChanged: (i) => setState(() => _range = i),
          labels: [
            t.statsRangeWeek,
            t.statsRangeMonth,
            t.statsRange3Month,
            t.statsRangeYear,
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _KpiGrid(t: t, repository: widget.repository),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _MuscleCard(t: t),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _DistributionCard(t: t),
        ),
        const SizedBox(height: 20),
        SectionHeader(
          title: t.statsPerformance,
          upper: true,
          trailingLabel: t.statsDetailedAnalysis,
          onTrailingTap: () => context.push('/activity'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _PerformanceGrid(t: t),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _WaterCard(t: t)),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _NutritionSummaryCard(t: t)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _MacroCard(t: t)),
              const SizedBox(width: 12),
              Expanded(child: _CalorieDistributionCard(t: t)),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _CalendarPill extends StatelessWidget {
  const _CalendarPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppPalette.darkSurfaceRaised
              : AppPalette.lightSurfaceRaised,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 16, color: scheme.onSurface),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _RangeTabs extends StatelessWidget {
  const _RangeTabs(
      {required this.selected, required this.onChanged, required this.labels});
  final int selected;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selected;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 8),
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isSelected
                        ? scheme.primary
                        : Theme.of(context).brightness == Brightness.dark
                            ? AppPalette.darkSurfaceRaised
                            : AppPalette.lightSurfaceRaised,
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: isSelected ? Colors.white : scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

String _numberWithDot(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.t, required this.repository});
  final AppLocalizations t;
  final AppRepository repository;

  String _formatHrs(int sec) {
    if (sec <= 0) return '0 dk';
    final m = (sec / 60).round();
    if (m < 60) return '$m dk';
    final h = m ~/ 60;
    final rem = m % 60;
    return rem == 0 ? '$h sa' : '${h}s ${rem}dk';
  }

  @override
  Widget build(BuildContext context) {
    final progSec = repository.totalProgramSeconds;
    final progWorkouts = repository.totalLevelCompletions;
    // Aggregate (base demo values + tracked program data).
    final totalKcal = 2450 + (progWorkouts * 180);
    final totalSec = (10 * 3600 + 45 * 60) + progSec;
    final totalWorkouts = 7 + progWorkouts;
    final activeDays = 6 + (progWorkouts > 0 ? 1 : 0);
    final items = [
      _Kpi(t.statsKpiCalories, _numberWithDot(totalKcal), 'kcal',
          Icons.local_fire_department_rounded, AppPalette.accentOrange, '+%12'),
      _Kpi(t.statsKpiTime, _formatHrs(totalSec), '',
          Icons.schedule_rounded, AppPalette.accentBlue, '+%8'),
      _Kpi(t.statsKpiWorkouts, '$totalWorkouts', t.statsSeans,
          Icons.fitness_center_rounded, AppPalette.primary, '+%16'),
      _Kpi(t.statsKpiActiveDays, '$activeDays', t.statsGun,
          Icons.eco_rounded, AppPalette.accentGreen, '+%20'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (_, i) => _KpiCard(item: items[i]),
    );
  }
}

class _Kpi {
  const _Kpi(
      this.label, this.value, this.unit, this.icon, this.color, this.delta);
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String delta;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.item});
  final _Kpi item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.color.withValues(alpha: 0.15),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 18, height: 1.1),
                ),
                if (item.unit.isNotEmpty)
                  Text(
                    item.unit,
                    style: TextStyle(
                        fontSize: 10, color: scheme.onSurfaceVariant),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded,
                        color: AppPalette.successDark, size: 11),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        '${item.delta} artış',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppPalette.successDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleCard extends StatelessWidget {
  const _MuscleCard({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratings = [
      _MuscleRating(t.statsMuscleHip, t.statsLevelGreat,
          AppPalette.successDark, AppPalette.primary),
      _MuscleRating(t.statsMuscleLegFront, t.statsLevelGood,
          AppPalette.successDark, AppPalette.accentPurple),
      _MuscleRating(t.statsMuscleLegBack, t.statsLevelOk,
          AppPalette.accentOrange, AppPalette.accentOrange),
      _MuscleRating(t.statsMuscleCore, t.statsLevelGood,
          AppPalette.successDark, AppPalette.accentPurple),
      _MuscleRating(t.statsMuscleBack, t.statsLevelOk,
          AppPalette.accentOrange, AppPalette.accentOrange),
      _MuscleRating(t.statsMuscleShoulder, t.statsLevelStart,
          AppPalette.destructiveDark, AppPalette.destructiveDark),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).push('/stats/muscles'),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(t.statsMuscleTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                  Text(t.statsMuscleDetail,
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward_rounded,
                      color: scheme.primary, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                height: 180,
                child: CustomPaint(painter: _BodyPainter()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final r in ratings) ...[
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: r.dotColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              r.name,
                              style: const TextStyle(fontSize: 12.5),
                            ),
                          ),
                          Text(
                            r.level,
                            style: TextStyle(
                                color: r.color,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppPalette.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPalette.primary.withValues(alpha: 0.18),
                  ),
                  child: const Icon(Icons.gps_fixed_rounded,
                      color: AppPalette.primary, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.statsExtraTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        'Alt Karın · Sırt (Üst) · İç Bacak',
                        style: TextStyle(
                            fontSize: 11.5,
                            color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => GoRouter.of(context)
                            .push('/programs/list?title=Önerilen%20programlar'),
                        borderRadius: BorderRadius.circular(6),
                        child: Text(t.statsExtraCta,
                            style: const TextStyle(
                                color: AppPalette.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleRating {
  const _MuscleRating(this.name, this.level, this.color, this.dotColor);
  final String name;
  final String level;
  final Color color;
  final Color dotColor;
}

class _BodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final base = Paint()
      ..color = AppPalette.darkMutedForeground.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final highlight = Paint()
      ..color = AppPalette.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Simple stylized female silhouette (head + body + legs).
    final body = Path();
    body.moveTo(w * 0.5, h * 0.04);
    body.addOval(Rect.fromCircle(
        center: Offset(w * 0.5, h * 0.1), radius: w * 0.09));

    // Torso outline
    final torso = Path()
      ..moveTo(w * 0.35, h * 0.2)
      ..lineTo(w * 0.65, h * 0.2)
      ..lineTo(w * 0.7, h * 0.52)
      ..lineTo(w * 0.6, h * 0.55)
      ..lineTo(w * 0.6, h * 0.95)
      ..lineTo(w * 0.4, h * 0.95)
      ..lineTo(w * 0.4, h * 0.55)
      ..lineTo(w * 0.3, h * 0.52)
      ..close();
    canvas.drawPath(torso, base);
    canvas.drawPath(body, base);

    // Arms
    final armL = Path()
      ..moveTo(w * 0.3, h * 0.22)
      ..quadraticBezierTo(w * 0.18, h * 0.35, w * 0.22, h * 0.5)
      ..lineTo(w * 0.28, h * 0.5)
      ..quadraticBezierTo(w * 0.27, h * 0.34, w * 0.36, h * 0.24)
      ..close();
    final armR = Path()
      ..moveTo(w * 0.7, h * 0.22)
      ..quadraticBezierTo(w * 0.82, h * 0.35, w * 0.78, h * 0.5)
      ..lineTo(w * 0.72, h * 0.5)
      ..quadraticBezierTo(w * 0.73, h * 0.34, w * 0.64, h * 0.24)
      ..close();
    canvas.drawPath(armL, base);
    canvas.drawPath(armR, base);

    // Highlights — core + glute + thighs
    final core = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.3, w * 0.16, h * 0.16),
        const Radius.circular(8),
      ));
    final glute = Path()
      ..addOval(Rect.fromLTWH(w * 0.4, h * 0.5, w * 0.2, h * 0.1));
    final thighL = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.4, h * 0.6, w * 0.09, h * 0.2),
        const Radius.circular(10),
      ));
    final thighR = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.51, h * 0.6, w * 0.09, h * 0.2),
        const Radius.circular(10),
      ));
    canvas.drawPath(core, highlight);
    canvas.drawPath(glute, highlight);
    canvas.drawPath(thighL, highlight);
    canvas.drawPath(thighR, highlight);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final segs = [
      _DonutSeg(t.statsMuscleHip, 25, AppPalette.primary),
      _DonutSeg(t.statsMuscleLegBack, 20, AppPalette.accentPurple),
      _DonutSeg(t.statsMuscleLegFront, 18, AppPalette.accentBlue),
      _DonutSeg(t.statsMuscleCore, 15, AppPalette.accentGreen),
      _DonutSeg(t.statsMuscleBack, 12, AppPalette.accentOrange),
      _DonutSeg(t.statsMuscleShoulder, 10, AppPalette.accentYellow),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).push('/stats/muscles'),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(t.statsDistribution,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                  Text('Tümü',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward_rounded,
                      color: scheme.primary, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 38,
                        startDegreeOffset: -90,
                        sections: segs
                            .map((s) => PieChartSectionData(
                                  color: s.color,
                                  value: s.value,
                                  showTitle: false,
                                  radius: 18,
                                ))
                            .toList(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.statsTotalWork,
                            style: TextStyle(
                              fontSize: 9.5,
                              color: scheme.onSurfaceVariant,
                            )),
                        const SizedBox(height: 2),
                        const Text('10s 45dk',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final s in segs) ...[
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: s.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(s.label,
                                style: const TextStyle(fontSize: 12.5)),
                          ),
                          Text(
                            '${s.value.toInt()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutSeg {
  const _DonutSeg(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}

class _PerformanceGrid extends StatelessWidget {
  const _PerformanceGrid({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final items = [
      _PerfMini('Kalori (kcal)', '2.450', '+%12',
          AppPalette.primary, _genTrend(seed: 1)),
      _PerfMini('Süre (dk)', '645', '+%6',
          AppPalette.accentPurple, _genTrend(seed: 2)),
      _PerfMini('Antrenman', '7', '+%16',
          AppPalette.accentOrange, _genTrend(seed: 3)),
      _PerfMini(t.statsAvgHeart, '128 bpm', '+%5',
          AppPalette.accentGreen, _genTrend(seed: 4)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (_, i) => _PerfMiniCard(item: items[i]),
    );
  }
}

List<double> _genTrend({required int seed}) {
  final rnd = math.Random(seed);
  return List.generate(7, (_) => 0.2 + rnd.nextDouble() * 0.8);
}

class _PerfMini {
  const _PerfMini(this.label, this.value, this.delta, this.color, this.values);
  final String label;
  final String value;
  final String delta;
  final Color color;
  final List<double> values;
}

class _PerfMiniCard extends StatelessWidget {
  const _PerfMiniCard({required this.item});
  final _PerfMini item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.arrow_upward_rounded,
                  color: AppPalette.successDark, size: 11),
              const SizedBox(width: 2),
              Text(
                item.delta,
                style: const TextStyle(
                  color: AppPalette.successDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(item.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 17)),
          const SizedBox(height: 4),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                minY: 0,
                maxY: 1.1,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      item.values.length,
                      (i) => FlSpot(i.toDouble(), item.values[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.45,
                    color: item.color,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          item.color.withValues(alpha: 0.4),
                          item.color.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final values = const [0.6, 0.4, 0.7, 0.5, 0.9, 0.65, 0.85];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.statsWater,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.water_drop_rounded,
                  color: AppPalette.accentBlue, size: 14),
              const SizedBox(width: 4),
              Text(t.statsWaterGoal,
                  style: TextStyle(
                      fontSize: 11.5, color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('2.1',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 28)),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('L', style: theme(context).bodyMedium),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.primary.withValues(alpha: 0.15),
                ),
                child: const Text('84%',
                    style: TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < days.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 40 * values[i],
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppPalette.primary,
                                  AppPalette.accentPurple,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              for (final d in days)
                Expanded(
                  child: Text(d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 9.5, color: scheme.onSurfaceVariant)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

TextTheme theme(BuildContext c) => Theme.of(c).textTheme;

class _NutritionSummaryCard extends StatelessWidget {
  const _NutritionSummaryCard({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rows = [
      _MacroRow(t.statsProtein, 92, 120, AppPalette.primary),
      _MacroRow(t.statsCarb, 132, 180, AppPalette.accentPurple),
      _MacroRow(t.statsFat, 48, 60, AppPalette.accentOrange),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(t.statsNutritionSummary,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14)),
              ),
              const Icon(Icons.eco_rounded,
                  color: AppPalette.accentGreen, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          Text(t.statsDailyAvg,
              style: TextStyle(
                  fontSize: 11.5, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          for (final r in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(r.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12)),
                ),
                Text('${r.value}g / ${r.goal}g',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 11.5)),
              ],
            ),
            const SizedBox(height: 6),
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: r.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: r.value / r.goal,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: r.color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _MacroRow {
  const _MacroRow(this.name, this.value, this.goal, this.color);
  final String name;
  final int value;
  final int goal;
  final Color color;
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final segs = [
      _DonutSeg(t.statsProtein, 30, AppPalette.primary),
      _DonutSeg(t.statsCarb, 45, AppPalette.accentPurple),
      _DonutSeg(t.statsFat, 25, AppPalette.accentOrange),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.statsMacro,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 22,
                startDegreeOffset: -90,
                sections: segs
                    .map((s) => PieChartSectionData(
                          color: s.color,
                          value: s.value,
                          radius: 14,
                          showTitle: false,
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          for (final s in segs) ...[
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: s.color,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(s.label,
                      style: const TextStyle(fontSize: 12)),
                ),
                Text('${s.value.toInt()}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 11.5)),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _CalorieDistributionCard extends StatelessWidget {
  const _CalorieDistributionCard({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final values = _genTrend(seed: 9).map((v) => v * 2000).toList();
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.statsCalorieDistribution,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 4),
          const Text('1.850 kcal',
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 18)),
          Text('Günlük ortalama',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      values.length,
                      (i) => FlSpot(i.toDouble(), values[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.5,
                    color: AppPalette.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppPalette.primary.withValues(alpha: 0.4),
                          AppPalette.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
