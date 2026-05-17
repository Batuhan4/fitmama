import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/mood_entry.dart';
import '../../../data/models/sleep_entry.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../data/repositories/partner_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../core/widgets/fitmama_card.dart';

/// Hosts the [PartnerRepository] for the currently paired mom and
/// rebuilds when that data changes. If no momUid is paired we fall
/// back to the local repository so the screen still renders empty.
class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  PartnerRepository? _partnerRepo;
  String? _attachedTo;

  void _ensurePartnerRepo() {
    final momUid = widget.repository.pairedMomUid;
    if (momUid == _attachedTo) return;
    _partnerRepo?.dispose();
    _partnerRepo = momUid != null ? PartnerRepository(momUid) : null;
    _attachedTo = momUid;
  }

  @override
  void dispose() {
    _partnerRepo?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensurePartnerRepo();
    final listenable = _partnerRepo ?? widget.repository;
    return ListenableBuilder(
      listenable: listenable,
      builder: (context, _) => _PartnerBody(
        repository: widget.repository,
        partnerRepo: _partnerRepo,
      ),
    );
  }
}

class _PartnerBody extends StatelessWidget {
  const _PartnerBody({required this.repository, required this.partnerRepo});

  final AppRepository repository;
  final PartnerRepository? partnerRepo;

  String _moodEmoji(MoodKind k) {
    switch (k) {
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

  String _moodLabel(MoodKind k, AppLocalizations t) {
    switch (k) {
      case MoodKind.happy:
        return t.moodHappy;
      case MoodKind.tired:
        return t.moodTired;
      case MoodKind.stressed:
        return t.moodStressed;
      case MoodKind.anxious:
        return t.moodAnxious;
      case MoodKind.energetic:
        return t.moodEnergetic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Prefer paired mom's cloud data; fall back to local repo for screenshots
    // / demo mode where there's no paired uid.
    final profile = partnerRepo?.profile ?? repository.profile;
    final today = todayKey();

    final src = partnerRepo;
    final feedingsSrc = src?.feedings ?? repository.feedings;
    final moodsSrc = src?.moods ?? repository.moods;
    final watersSrc = src?.waters ?? repository.waters;
    final sleepsSrc = src?.sleeps ?? repository.sleeps;
    final exercisesSrc = src?.exercises ?? repository.exercises;

    final feedings = [...feedingsSrc];
    feedings.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    final lastFeeding = feedings.isEmpty ? null : feedings.first;
    final minutesSince = lastFeeding == null
        ? null
        : DateTime.now()
            .difference(DateTime.parse(lastFeeding.startedAt))
            .inMinutes;

    final todayMood =
        moodsSrc.where((m) => m.date == today).firstOrNull;
    final todayWater = watersSrc
            .where((w) => w.date == today)
            .firstOrNull
            ?.cups ??
        0;
    final todaySleepMin = sleepsSrc
        .where((s) =>
            s.start.substring(0, 10) == today && s.who == SleeperType.mom)
        .fold<int>(0, (a, s) => a + s.durationMinutes);
    final todayExerciseMin = exercisesSrc
        .where((e) => e.doneAt.substring(0, 10) == today)
        .fold<int>(0, (a, e) => a + e.durationMin);

    final concerns = <String>[];
    if (todayWater < 4) concerns.add(t.partnerCWater);
    if (minutesSince != null && minutesSince > 180) {
      concerns.add(t.partnerCFeeding);
    }
    if (todayMood != null && negativeMoods.contains(todayMood.mood)) {
      concerns.add(t.partnerCMood);
    }
    if (todaySleepMin > 0 && todaySleepMin < 240) {
      concerns.add(t.partnerCSleep);
    }

    final tips = [
      t.partnerTip1,
      t.partnerTip2,
      t.partnerTip3,
      t.partnerTip4,
    ];

    final locale = Localizations.localeOf(context).languageCode;
    final dateLabel =
        DateFormat('EEEE, d MMMM', locale).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(t.partnerTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              Text(dateLabel,
                  style: TextStyle(
                      fontSize: 13, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(
                '${profile?.name ?? t.partnerMom} 💕',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(t.partnerSubtitle,
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text(t.partnerStatusToday,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      todayMood == null
                          ? t.partnerNoMood
                          : '${_moodEmoji(todayMood.mood)} ${_moodLabel(todayMood.mood, t)}',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: scheme.onPrimary,
                          ),
                    ),
                    if (todayMood?.note?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text('"${todayMood!.note}"',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.7,
                children: [
                  _Stat(
                      icon: Icons.child_friendly_rounded,
                      label: t.dashLastFeeding,
                      value: minutesSince == null
                          ? '—'
                          : minutesSince < 60
                              ? t.dashMinAgo(minutesSince)
                              : t.dashHAgo(minutesSince ~/ 60),
                      accent: const Color(0xFFFB7185)),
                  _Stat(
                      icon: Icons.water_drop_rounded,
                      label: t.dashWater,
                      value: t.dashCups(todayWater),
                      accent: const Color(0xFF38BDF8)),
                  _Stat(
                      icon: Icons.nightlight_round,
                      label: t.dashSleep,
                      value: todaySleepMin > 0
                          ? '${todaySleepMin ~/ 60}s ${todaySleepMin % 60}d'
                          : '—',
                      accent: const Color(0xFFA5B4FC)),
                  _Stat(
                      icon: Icons.fitness_center_rounded,
                      label: t.dashActivity,
                      value: todayExerciseMin > 0
                          ? '$todayExerciseMin dk'
                          : '—',
                      accent: const Color(0xFF34D399)),
                ],
              ),
              if (concerns.isNotEmpty) ...[
                const SizedBox(height: 12),
                FitmamaCard(
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sentiment_satisfied_rounded,
                              size: 16, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text(t.partnerHowToHelp,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...concerns.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style: TextStyle(color: scheme.primary)),
                              Expanded(
                                child: Text(c,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: scheme.onSurfaceVariant,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FitmamaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 16, color: scheme.primary),
                        const SizedBox(width: 8),
                        Text(t.partnerSupportTips,
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...tips.map(
                      (tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: TextStyle(color: scheme.primary)),
                            Expanded(
                              child: Text(tip,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/progress'),
                      child: Text(t.navProgress),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await repository.setRole(null);
                        if (!context.mounted) return;
                        context.go('/welcome');
                      },
                      icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                      label: Text(t.partnerSwitchRole),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AccentCard(
      color: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  )),
            ],
          ),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
