import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';
import '../shell/top_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = repository.profile;
    final name = profile?.name ?? 'FitMama';

    final workouts = repository.exercises.length;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FitmamaTopBar(
          repository: repository,
          actions: [
            HeaderIconButton(
              icon: Icons.settings_outlined,
              onTap: () => context.push('/settings'),
              tooltip: 'Ayarlar',
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child:
              Text(t.profileTitle, style: theme.textTheme.displaySmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ProfileHeader(
            name: name,
            handle: name.isNotEmpty
                ? '${name.toLowerCase()}@fitmama.app'
                : 'fitmama.app',
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _XpLevelCard(
            level: repository.userLevel,
            xp: 7000 + repository.totalProgramXp,
            nextLevelXp:
                (repository.userLevel + 1) * 1000,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _KpiStrip(
            workouts:
                (workouts + repository.totalLevelCompletions).toString(),
            weeks: '12',
            achievements: '3',
            t: t,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/profile/goals'),
                  icon: const Icon(Icons.flag_rounded, size: 18),
                  label: const Text('Hedeflerim'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/activity'),
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: const Text('Aktivite'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: t.profileMyProgress,
          upper: true,
          trailingLabel: t.statsRangeWeek,
          onTrailingTap: () => context.go('/stats'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ProgressWeekCard(),
        ),
        const SizedBox(height: 24),
        SectionHeader(title: t.profileFocusAreas, upper: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _FocusList(),
        ),
        const SizedBox(height: 24),
        SectionHeader(title: t.profileMamaTools, upper: true),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          child: Text(t.profileMamaToolsSub,
              style: theme.textTheme.bodySmall),
        ),
        const SizedBox(height: 8),
        _MamaToolsList(repository: repository),
        const SizedBox(height: 24),
        SectionHeader(
          title: t.profileAchievements,
          upper: true,
          trailingLabel: t.homeViewAll,
          onTrailingTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _AchievementsRow(),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutlinedButton.icon(
            onPressed: () => context.push('/welcome'),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Rolü değiştir'),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.handle});
  final String name;
  final String handle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppPalette.primary, AppPalette.primarySoft],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: scheme.surface, width: 3),
              ),
              alignment: Alignment.center,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'F',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.primary,
                  border: Border.all(color: scheme.surface, width: 2),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                handle,
                style: TextStyle(
                    color: scheme.onSurfaceVariant, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _XpLevelCard extends StatelessWidget {
  const _XpLevelCard({
    required this.level,
    required this.xp,
    required this.nextLevelXp,
  });
  final int level;
  final int xp;
  final int nextLevelXp;

  @override
  Widget build(BuildContext context) {
    final progress = (xp % 1000) / 1000;
    final toNext = nextLevelXp - xp;
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [
          AppPalette.primary.withValues(alpha: 0.18),
          AppPalette.accentPurple.withValues(alpha: 0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppPalette.primary, AppPalette.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('LV',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
                Text('$level',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Level $level — Recovery Hero',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                    Text(
                      '$xp XP',
                      style: const TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppPalette.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppPalette.primary,
                              AppPalette.accentPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Bir sonraki seviyeye $toNext XP',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip({
    required this.workouts,
    required this.weeks,
    required this.achievements,
    required this.t,
  });
  final String workouts;
  final String weeks;
  final String achievements;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    Widget kpi(String label, String value) {
      return Expanded(
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 28)),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        kpi(t.profileWorkouts, workouts),
        kpi(t.profileWeeksWithFitmama, weeks),
        kpi(t.profileAchievements, achievements),
      ],
    );
  }
}

class _ProgressWeekCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final values = const [0.4, 0.7, 0.55, 0.85, 0.5, 0.95, 0.3];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MiniMetric(
                  Icons.local_fire_department_rounded,
                  AppPalette.accentOrange,
                  '820',
                  'Kalori'),
              _MiniMetric(Icons.schedule_rounded, AppPalette.accentBlue,
                  '5s 30dk', 'Toplam'),
              _MiniMetric(Icons.check_circle_rounded,
                  AppPalette.successDark, '6', t.statsKpiWorkouts),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < days.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Container(
                        height: 70 * values[i],
                        decoration: BoxDecoration(
                          color: AppPalette.primary
                              .withValues(alpha: 0.2 + values[i] * 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
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
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric(this.icon, this.color, this.value, this.label);
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 14)),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _FocusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _FocusItem('Core Strength', 0.7, AppPalette.primary,
          Icons.local_fire_department_rounded),
      _FocusItem(
          'Pelvik Sağlık', 0.6, AppPalette.accentPurple, Icons.spa_rounded),
      _FocusItem('Mobilite', 0.5, AppPalette.accentGreen,
          Icons.accessibility_new_rounded),
      _FocusItem(
          'Nefes', 0.4, AppPalette.accentYellow, Icons.air_rounded),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: items[i].color,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(items[i].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                ),
                Text('${(items[i].progress * 100).round()}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 12.5)),
              ],
            ),
            const SizedBox(height: 6),
            Stack(
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: items[i].color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: items[i].progress,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: items[i].color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
            if (i < items.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FocusItem {
  const _FocusItem(this.name, this.progress, this.color, this.icon);
  final String name;
  final double progress;
  final Color color;
  final IconData icon;
}

class _MamaToolsList extends StatelessWidget {
  const _MamaToolsList({required this.repository});
  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tools = <_MamaTool>[
      _MamaTool(t.profileToolFeeding, Icons.child_friendly_rounded,
          AppPalette.primary, '/feeding'),
      _MamaTool(t.profileToolSleep, Icons.bedtime_rounded,
          AppPalette.accentPurple, '/sleep'),
      _MamaTool(t.profileToolMood, Icons.sentiment_satisfied_rounded,
          AppPalette.accentYellow, '/mood'),
      _MamaTool(t.profileToolMilestones, Icons.celebration_rounded,
          AppPalette.accentGreen, '/milestones'),
      _MamaTool(t.profileToolRecovery, Icons.healing_rounded,
          AppPalette.accentBlue, '/recovery'),
      _MamaTool(t.profileToolKegel, Icons.favorite_rounded,
          AppPalette.primary, '/kegel'),
      _MamaTool(t.profileToolBreathing, Icons.air_rounded,
          AppPalette.accentGreen, '/breathing'),
      _MamaTool(t.profileToolPartner, Icons.people_rounded,
          AppPalette.accentPurple, '/partner'),
      _MamaTool(t.profileToolReminders, Icons.notifications_active_rounded,
          AppPalette.accentOrange, '/reminders'),
      _MamaTool(t.profileToolCommunity, Icons.forum_rounded,
          AppPalette.accentBlue, '/community'),
      _MamaTool(t.profileToolVideos, Icons.play_circle_fill_rounded,
          AppPalette.primary, '/videos'),
    ];
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tools.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _MamaToolTile(tool: tools[i]),
    );
  }
}

class _MamaTool {
  const _MamaTool(this.label, this.icon, this.color, this.route);
  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class _MamaToolTile extends StatelessWidget {
  const _MamaToolTile({required this.tool});
  final _MamaTool tool;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => GoRouter.of(context).push(tool.route),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tool.color.withValues(alpha: 0.15),
            ),
            child: Icon(tool.icon, color: tool.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(tool.label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Icon(Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant, size: 22),
        ],
      ),
    );
  }
}

class _AchievementsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final badges = [
      _Badge('İlk Antrenman', Icons.workspace_premium_rounded,
          [const Color(0xFFFB923C), const Color(0xFFE91E63)]),
      _Badge('7 Gün Streak', Icons.local_fire_department_rounded,
          [const Color(0xFFF2C94C), const Color(0xFFFB923C)]),
      _Badge('Core Şampiyonu', Icons.emoji_events_rounded,
          [const Color(0xFF4ADE80), const Color(0xFF22C55E)]),
      _Badge('Recovery 30g', Icons.healing_rounded,
          [const Color(0xFFC4B5FD), const Color(0xFF6D28D9)]),
    ];
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final b = badges[i];
          return SizedBox(
            width: 80,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: b.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(b.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  b.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Badge {
  const _Badge(this.name, this.icon, this.gradient);
  final String name;
  final IconData icon;
  final List<Color> gradient;
}
