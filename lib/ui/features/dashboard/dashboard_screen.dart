import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/mood_entry.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../core/widgets/momrise_card.dart';
import 'recommendations.dart';
import 'water_quick_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = repository.profile;
    final today = todayKey();

    final feedings = [...repository.feedings];
    feedings.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    final lastFeeding = feedings.isEmpty ? null : feedings.first;
    final minutesSince = lastFeeding == null
        ? null
        : DateTime.now()
            .difference(DateTime.parse(lastFeeding.startedAt))
            .inMinutes;
    final nextInMin = minutesSince == null
        ? null
        : (180 - minutesSince).clamp(0, 999);

    final todayMood = repository.moods.where((m) => m.date == today).firstOrNull;
    final todayWater = repository.waters
            .where((w) => w.date == today)
            .firstOrNull
            ?.cups ??
        0;

    final todaySleepMin = repository.sleeps
        .where((s) =>
            s.start.substring(0, 10) == today && s.who.name == 'mom')
        .fold<int>(0, (acc, s) => acc + s.durationMinutes);

    final todayExerciseMin = repository.exercises
        .where((e) => e.doneAt.substring(0, 10) == today)
        .fold<int>(0, (acc, e) => acc + e.durationMin);

    final tips = <String>[];
    if (minutesSince != null && minutesSince > 120) {
      tips.add(t.dashTip2(minutesSince ~/ 60));
    }
    if (todayWater < 6) tips.add(t.dashTip3);
    tips.add(t.dashTip1);
    if (todayMood != null && negativeMoods.contains(todayMood.mood)) {
      tips.add(t.dashTip4);
    }

    final locale = Localizations.localeOf(context).languageCode;
    final dateLabel = DateFormat('EEEE, d MMMM', locale).format(DateTime.now());

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Text(dateLabel,
            style: TextStyle(
                fontSize: 13, color: scheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(
          '${t.dashHello}, ${profile?.name ?? 'anne'} 💕',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        GradientCard(
          padding: const EdgeInsets.all(20),
          onTap: () => context.push('/feeding'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.child_friendly_rounded, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(t.dashLastFeeding,
                          style: const TextStyle(fontSize: 13))),
                  Text(t.dashAddFeeding,
                      style: const TextStyle(fontSize: 12)),
                  const Icon(Icons.chevron_right_rounded, size: 14),
                ],
              ),
              const SizedBox(height: 12),
              if (lastFeeding == null)
                Text(t.dashNoFeeding,
                    style: const TextStyle(fontSize: 16))
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      minutesSince! < 60
                          ? t.dashMinAgo(minutesSince)
                          : t.dashHAgo(minutesSince ~/ 60),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: scheme.onPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${t.dashNextFeeding}: ${t.dashInMin(nextInMin!.toInt())}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth > 520;
            final children = <Widget>[
              _StatCard(
                icon: Icons.water_drop_rounded,
                accent: const Color(0xFF7DD3FC),
                label: t.dashWater,
                value: t.dashCups(todayWater),
                onTap: () => context.push('/nutrition'),
              ),
              _StatCard(
                icon: Icons.sentiment_satisfied_rounded,
                accent: const Color(0xFFFCD34D),
                label: t.dashMood,
                value: todayMood != null
                    ? _moodEmoji(todayMood.mood)
                    : '—',
                onTap: () => context.push('/mood'),
              ),
              _StatCard(
                icon: Icons.nightlight_round,
                accent: const Color(0xFFA5B4FC),
                label: t.dashSleep,
                value: todaySleepMin > 0
                    ? '${todaySleepMin ~/ 60}s ${todaySleepMin % 60}d'
                    : '—',
                onTap: () => context.push('/sleep'),
              ),
              _StatCard(
                icon: Icons.fitness_center_rounded,
                accent: const Color(0xFF6EE7B7),
                label: t.dashActivity,
                value: todayExerciseMin > 0
                    ? '$todayExerciseMin dk'
                    : '—',
                onTap: () => context.push('/exercise'),
              ),
            ];
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: wide ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: wide ? 1.8 : 1.7,
              children: children,
            );
          },
        ),
        const SizedBox(height: 12),
        WaterQuickWidget(repository: repository),
        const SizedBox(height: 12),
        Recommendations(repository: repository),
        const SizedBox(height: 12),
        MomriseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      size: 16, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(t.dashTips,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              ...tips.take(3).map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ',
                              style: TextStyle(color: scheme.primary)),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                fontSize: 13,
                                color: scheme.onSurfaceVariant,
                              ),
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
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth > 520;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: wide ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: wide ? 2.6 : 2.3,
              children: [
                _DashAction(
                  filled: true,
                  icon: Icons.add,
                  label: t.dashAddFeeding,
                  onTap: () => context.push('/feeding'),
                ),
                _DashAction(
                  icon: Icons.add,
                  label: t.dashLogMood,
                  onTap: () => context.push('/mood'),
                ),
                _DashAction(
                  icon: Icons.add,
                  label: t.dashAddSleep,
                  onTap: () => context.push('/sleep'),
                ),
                _DashAction(
                  icon: Icons.add,
                  label: t.dashAddExercise,
                  onTap: () => context.push('/videos'),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  String _moodEmoji(MoodKind kind) {
    switch (kind) {
      case MoodKind.happy:
        return '😊';
      case MoodKind.tired:
        return '😴';
      case MoodKind.stressed:
        return '😣';
      case MoodKind.anxious:
        return '😟';
      case MoodKind.energetic:
        return '⚡';
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AccentCard(
      color: accent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _DashAction extends StatelessWidget {
  const _DashAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = filled ? scheme.onPrimary : scheme.primary;
    return Material(
      color: filled ? scheme.primary : Colors.transparent,
      shape: RoundedRectangleBorder(
        side: filled
            ? BorderSide.none
            : BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
