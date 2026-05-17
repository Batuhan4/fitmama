import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/program_catalog.dart';
import '../../../data/models/program_progress.dart';
import '../../../data/repositories/app_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

String _imageForId(String id) {
  final lower = id.toLowerCase();
  if (lower.contains('kalca') || lower.contains('glute')) {
    return 'assets/images/workouts/donkey_kick.jpg';
  }
  if (lower.contains('bel') || lower.contains('inceltme')) {
    return 'assets/images/workouts/bicycle_crunch.jpg';
  }
  if (lower.contains('hiit') || lower.contains('burn')) {
    return 'assets/images/workouts/cardio_kick.jpg';
  }
  if (lower.contains('guclu') || lower.contains('strong') ||
      lower.contains('mama')) {
    return 'assets/images/workouts/kettlebell_squat.jpg';
  }
  if (lower.contains('pelvik') || lower.contains('pelvic')) {
    return 'assets/images/workouts/yoga_stretch.jpg';
  }
  if (lower.contains('yoga') || lower.contains('mobilite') ||
      lower.contains('meditasyon')) {
    return 'assets/images/workouts/meditation.jpg';
  }
  if (lower.contains('yuruyus') || lower.contains('walk')) {
    return 'assets/images/programs/outdoor_run.jpg';
  }
  return 'assets/images/workouts/mom_baby.jpg';
}

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({
    super.key,
    required this.programId,
    required this.title,
    required this.repository,
  });

  final String programId;
  final String title;
  final AppRepository repository;

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late final ProgramDefinition? _program = programById(widget.programId);

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_onRepoChange);
  }

  @override
  void dispose() {
    widget.repository.removeListener(_onRepoChange);
    super.dispose();
  }

  void _onRepoChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final prog = _program;
    final progress = widget.repository.progressFor(widget.programId);
    final nextLvl = progress.nextLevelIndex;
    final totalLevels = prog?.levels.length ?? 0;
    final doneLevels = progress.completedLevels.length;
    final overallPct = totalLevels == 0 ? 0.0 : doneLevels / totalLevels;
    final totalMins = prog == null
        ? 0
        : prog.levels.fold<int>(0, (a, l) => a + l.estimatedMinutes);
    final difficulty = prog == null || prog.levels.isEmpty
        ? 'Karışık'
        : (prog.levels.length >= 4 ? 'Kademeli' : 'Standart');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 280,
            backgroundColor: scheme.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.black.withValues(alpha: 0.35),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: const Icon(Icons.bookmark_border_rounded,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(_imageForId(widget.programId),
                      fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Pill(
                                icon: Icons.layers_rounded,
                                label: '$totalLevels seviye'),
                            const SizedBox(width: 8),
                            _Pill(
                                icon: Icons.schedule_rounded,
                                label: '$totalMins dk toplam'),
                            const SizedBox(width: 8),
                            _Pill(
                                icon: Icons.bar_chart_rounded,
                                label: difficulty),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.title,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList.list(
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  prog?.subtitle ??
                      'Postpartum recovery için tasarlanmış kademeli program.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _OverallProgress(
                  doneLevels: doneLevels,
                  totalLevels: totalLevels,
                  pct: overallPct,
                  totalSec: progress.totalSeconds,
                  xp: progress.xp,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: prog == null
                            ? null
                            : () {
                                final target =
                                    nextLvl.clamp(0, totalLevels - 1);
                                context.push(
                                    '/programs/${widget.programId}/play/$target');
                              },
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(doneLevels == 0
                            ? 'Hemen başla'
                            : (doneLevels >= totalLevels
                                ? 'Tekrarla'
                                : 'Devam et')),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(52, 52),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.calendar_today_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Seviyeler', upper: true),
              if (prog != null) _LevelsList(program: prog, progress: progress),
              const SizedBox(height: 20),
              SectionHeader(title: 'Bu programın hedefleri', upper: true),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _GoalsCard(),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: 'AI önerisi', upper: true),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _AiSuggestionCard(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverallProgress extends StatelessWidget {
  const _OverallProgress({
    required this.doneLevels,
    required this.totalLevels,
    required this.pct,
    required this.totalSec,
    required this.xp,
  });
  final int doneLevels;
  final int totalLevels;
  final double pct;
  final int totalSec;
  final int xp;

  @override
  Widget build(BuildContext context) {
    final mins = (totalSec / 60).round();
    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Genel ilerleme',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14)),
              const Spacer(),
              Text('%${(pct * 100).round()}',
                  style: const TextStyle(
                      color: AppPalette.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppPalette.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              FractionallySizedBox(
                widthFactor: pct.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppPalette.primary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniStat(
                  icon: Icons.layers_rounded,
                  label: '$doneLevels / $totalLevels seviye',
                  color: AppPalette.primary),
              const SizedBox(width: 14),
              _MiniStat(
                  icon: Icons.schedule_rounded,
                  label: '$mins dk',
                  color: AppPalette.accentBlue),
              const SizedBox(width: 14),
              _MiniStat(
                  icon: Icons.bolt_rounded,
                  label: '$xp XP',
                  color: AppPalette.accentYellow),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(
      {required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _LevelsList extends StatelessWidget {
  const _LevelsList({required this.program, required this.progress});
  final ProgramDefinition program;
  final ProgramProgress progress;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: program.levels.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final lvl = program.levels[i];
        final unlocked = progress.isLevelUnlocked(i);
        final done = progress.isLevelCompleted(i);
        return _LevelCard(
          program: program,
          level: lvl,
          unlocked: unlocked,
          done: done,
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.program,
    required this.level,
    required this.unlocked,
    required this.done,
  });
  final ProgramDefinition program;
  final ProgramLevelDef level;
  final bool unlocked;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicator = done
        ? const _Indicator(
            icon: Icons.check_rounded,
            color: AppPalette.accentGreen,
            label: 'Tamamlandı')
        : unlocked
            ? const _Indicator(
                icon: Icons.play_arrow_rounded,
                color: AppPalette.primary,
                label: 'Başla')
            : const _Indicator(
                icon: Icons.lock_rounded,
                color: AppPalette.accentBlue,
                label: 'Kilitli');

    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      onTap: unlocked
          ? () => context.push(
              '/programs/${program.id}/play/${level.index}')
          : null,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: indicator.color.withValues(alpha: 0.15),
            ),
            alignment: Alignment.center,
            child: Text(
              '${level.index + 1}',
              style: TextStyle(
                color: indicator.color,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(level.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  level.tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.fitness_center_rounded,
                        size: 12, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('${level.exercises.length} hareket',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(width: 10),
                    Icon(Icons.schedule_rounded,
                        size: 12, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('~${level.estimatedMinutes} dk',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(width: 10),
                    Icon(Icons.bolt_rounded,
                        size: 12, color: AppPalette.accentYellow),
                    const SizedBox(width: 4),
                    Text('+${level.xpReward} XP',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked ? indicator.color : indicator.color.withValues(alpha: 0.3),
            ),
            child: Icon(indicator.icon, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _Indicator {
  const _Indicator(
      {required this.icon, required this.color, required this.label});
  final IconData icon;
  final Color color;
  final String label;
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goals = const [
      ('Core kontrolünü geri kazanmak', Icons.center_focus_strong_rounded),
      ('Diastasis recti iyileşmesi', Icons.healing_rounded),
      ('Pelvik taban toparlanması', Icons.favorite_rounded),
      ('Postür ve denge', Icons.accessibility_new_rounded),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (var i = 0; i < goals.length; i++) ...[
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPalette.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(goals[i].$2,
                      color: AppPalette.primary, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(goals[i].$1,
                      style: const TextStyle(fontSize: 13.5)),
                ),
              ],
            ),
            if (i < goals.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _AiSuggestionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [
          AppPalette.primary.withValues(alpha: 0.15),
          AppPalette.accentPurple.withValues(alpha: 0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.primary.withValues(alpha: 0.18),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: AppPalette.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bugün enerjin orta seviyede',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Diaphragmatic breath ile başlayıp ısınmayı tamamla. '
                  'Glute bridge setlerinde aralar arası 60 sn dinlen.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
