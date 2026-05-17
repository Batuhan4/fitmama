import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/program_catalog.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';
import '../shell/top_bar.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  int _categoryTab = 0;

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
            HeaderIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Ara',
              onTap: () => context.push('/search'),
            ),
            HeaderIconButton(
              icon: Icons.tune_rounded,
              tooltip: 'Filtre',
              onTap: () => _showFilterSheet(context),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Text(t.tabPrograms,
              style: theme.textTheme.displaySmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'Sana en iyi gelen programı seç, dönüşümünü başlat! 💪',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        SectionHeader(title: t.progLocationTitle, upper: true),
        _LocationRow(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ChallengePromo(),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: _ContinueCard(repository: widget.repository),
        ),
        const SizedBox(height: 16),
        SectionHeader(title: t.progCategories, upper: true),
        _CategoryTabs(
          selected: _categoryTab,
          onChanged: (i) => setState(() => _categoryTab = i),
          tabs: [
            t.progCategoryRegion,
            t.progCategoryGoal,
            t.progCategoryType,
            t.progCategoryLevel,
          ],
        ),
        const SizedBox(height: 14),
        _CategoryGrid(tab: _categoryTab),
        const SizedBox(height: 24),
        SectionHeader(
          title: t.progFeatured,
          upper: true,
          trailingLabel: 'Tümünü gör',
          onTrailingTap: () => context.push('/programs/list'),
        ),
        const _FeaturedRow(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _AiCard(
            title: t.progAiTitle,
            sub: t.progAiSub,
            cta: t.progAiCta,
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

void _showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filtrele',
                style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 14),
            const Text('Seviye',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final l in const ['Başlangıç', 'Orta', 'İleri', 'Tüm seviye'])
                  Chip(
                    label: Text(l),
                    backgroundColor:
                        AppPalette.primary.withValues(alpha: 0.12),
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Süre',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final l in const ['10 dk', '20 dk', '30 dk', '45 dk+'])
                  Chip(
                    label: Text(l),
                    backgroundColor:
                        AppPalette.accentPurple.withValues(alpha: 0.12),
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Uygula'),
            ),
          ],
        ),
      );
    },
  );
}

class _LocationRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final items = [
      _LocationItem(
        title: t.progLocationHome,
        sub: t.progLocationHomeSub,
        icon: Icons.home_rounded,
        image: 'assets/images/programs/home_squat.jpg',
      ),
      _LocationItem(
        title: t.progLocationGym,
        sub: t.progLocationGymSub,
        icon: Icons.fitness_center_rounded,
        image: 'assets/images/programs/gym_lunge.jpg',
      ),
      _LocationItem(
        title: t.progLocationOutdoor,
        sub: t.progLocationOutdoorSub,
        icon: Icons.directions_run_rounded,
        image: 'assets/images/programs/outdoor_run.jpg',
      ),
    ];
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _LocationCard(item: items[i]),
      ),
    );
  }
}

class _LocationItem {
  const _LocationItem({
    required this.title,
    required this.sub,
    required this.icon,
    required this.image,
  });
  final String title;
  final String sub;
  final IconData icon;
  final String image;
}

class _ChallengePromo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      onTap: () => GoRouter.of(context).push('/challenges'),
      gradient: const LinearGradient(
        colors: [AppPalette.primary, AppPalette.accentPurple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.22),
            ),
            child: const Icon(Icons.emoji_events_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('21 Gün Core Recovery',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
                SizedBox(height: 2),
                Text('Bu ayın challenge\'ına katıl, rozet kazan.',
                    style: TextStyle(
                        color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded,
              color: Colors.white),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.item});
  final _LocationItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: InkWell(
        onTap: () => GoRouter.of(context).push(
            '/programs/list?title=${Uri.encodeComponent(item.title)}'),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.image, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPalette.primary,
                    ),
                    child:
                        Icon(item.icon, color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.sub,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11.5,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.primary,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.repository});
  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // Pick the most-recent program with progress, else first catalog entry.
    final lastId = repository.lastProgramId ?? kProgramCatalog.first.id;
    final prog = programById(lastId) ?? kProgramCatalog.first;
    final progress = repository.progressFor(prog.id);
    final totalLevels = prog.levels.length;
    final doneLevels = progress.completedLevels.length;
    final nextLvl =
        progress.nextLevelIndex.clamp(0, totalLevels - 1);
    final pct = totalLevels == 0 ? 0.0 : doneLevels / totalLevels;
    final mins = prog.levels[nextLvl].estimatedMinutes;
    return ListenableBuilder(
      listenable: repository,
      builder: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text(t.progContinueTitle.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ))),
                InkWell(
                  onTap: () => context.push('/programs/list'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 4),
                    child: Text(t.homeViewAll,
                        style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          FitmamaCard(
            padding: const EdgeInsets.all(12),
            onTap: () => context.push(
                '/programs/${prog.id}?title=${Uri.encodeComponent(prog.title)}'),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        AppPalette.primary.withValues(alpha: 0.4),
                        AppPalette.accentPurple.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.self_improvement_rounded,
                      size: 38, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prog.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                          'Seviye ${nextLvl + 1} · ~$mins dk',
                          style: theme.textTheme.bodySmall),
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppPalette.primary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: pct.clamp(0.0, 1.0),
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppPalette.primary,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('%${(pct * 100).round()} tamamlandı',
                              style: theme.textTheme.bodySmall),
                          FilledButton(
                            onPressed: () => context.push(
                                '/programs/${prog.id}/play/$nextLvl'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              minimumSize: const Size(0, 36),
                              textStyle: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            child: Text(
                                doneLevels == 0
                                    ? 'Başla'
                                    : t.progContinue),
                          ),
                        ],
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

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs(
      {required this.selected, required this.onChanged, required this.tabs});
  final int selected;
  final ValueChanged<int> onChanged;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isSelected
                    ? scheme.primary
                    : Theme.of(context).brightness == Brightness.dark
                        ? AppPalette.darkSurfaceRaised
                        : AppPalette.lightSurfaceRaised,
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : scheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.tab});
  final int tab;

  @override
  Widget build(BuildContext context) {
    final items = _categoriesFor(tab);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        return FitmamaCard(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          onTap: () => GoRouter.of(context).push(
              '/programs/list?title=${Uri.encodeComponent(item.label)}'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: item.color, size: 30),
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CatItem {
  const _CatItem(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

List<_CatItem> _categoriesFor(int tab) {
  switch (tab) {
    case 0:
      return const [
        _CatItem('Core', Icons.center_focus_strong_rounded, AppPalette.primary),
        _CatItem(
            'Full Body', Icons.accessibility_new_rounded, AppPalette.primary),
        _CatItem('Upper Body', Icons.front_hand_rounded, AppPalette.primary),
        _CatItem(
            'Lower Body', Icons.directions_walk_rounded, AppPalette.primary),
        _CatItem('Glute', Icons.airline_seat_legroom_extra_rounded,
            AppPalette.primary),
        _CatItem(
            'Pelvik Taban', Icons.favorite_border_rounded, AppPalette.primary),
        _CatItem('Bel İnceltme', Icons.straighten_rounded, AppPalette.primary),
        _CatItem(
            'Sırt & Postur', Icons.accessibility_rounded, AppPalette.primary),
      ];
    case 1:
      return const [
        _CatItem('Yağ Yakımı', Icons.local_fire_department_rounded,
            AppPalette.accentOrange),
        _CatItem(
            'Güç & Kuvvet', Icons.fitness_center_rounded, AppPalette.primary),
        _CatItem(
            'Recovery', Icons.healing_rounded, AppPalette.accentPurple),
        _CatItem(
            'Esneklik', Icons.self_improvement_rounded, AppPalette.accentBlue),
        _CatItem('Dayanıklılık', Icons.directions_run_rounded,
            AppPalette.accentGreen),
        _CatItem('Postür', Icons.accessibility_rounded, AppPalette.accentBlue),
        _CatItem('Düşük Etki', Icons.spa_rounded, AppPalette.accentGreen),
        _CatItem('Enerji', Icons.bolt_rounded, AppPalette.accentYellow),
      ];
    case 2:
      return const [
        _CatItem('Kardiyo', Icons.favorite_rounded, AppPalette.primary),
        _CatItem('HIIT', Icons.local_fire_department_rounded,
            AppPalette.accentOrange),
        _CatItem(
            'Pilates', Icons.self_improvement_rounded, AppPalette.accentPurple),
        _CatItem('Yoga', Icons.spa_rounded, AppPalette.accentPurple),
        _CatItem(
            'Kuvvet', Icons.fitness_center_rounded, AppPalette.primary),
        _CatItem(
            'Esneme', Icons.accessibility_new_rounded, AppPalette.accentBlue),
        _CatItem(
            'Dance Fitness', Icons.music_note_rounded, AppPalette.accentPurple),
        _CatItem(
            'Walking', Icons.directions_walk_rounded, AppPalette.accentGreen),
      ];
    case 3:
    default:
      return const [
        _CatItem('Başlangıç', Icons.star_border_rounded, AppPalette.accentGreen),
        _CatItem('Orta', Icons.star_half_rounded, AppPalette.accentOrange),
        _CatItem('İleri', Icons.star_rounded, AppPalette.primary),
        _CatItem('Tüm Seviye', Icons.bar_chart_rounded, AppPalette.accentBlue),
      ];
  }
}

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Featured('guclu-anne', 'Güçlü Anne', '45 dk · İleri',
          'assets/images/workouts/kettlebell_squat.jpg'),
      _Featured('kalca-gelistirme', 'Kalça Geliştirme', '40 dk · Orta',
          'assets/images/workouts/barbell_hip_thrust.jpg'),
      _Featured('hiit-burn', 'HIIT Burn', '30 dk · İleri',
          'assets/images/workouts/cardio_kick.jpg'),
    ];
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _FeaturedCard(item: items[i]),
      ),
    );
  }
}

class _Featured {
  const _Featured(this.id, this.title, this.meta, this.image);
  final String id;
  final String title;
  final String meta;
  final String image;
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item});
  final _Featured item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: () => GoRouter.of(context).push(
            '/programs/${item.id}?title=${Uri.encodeComponent(item.title)}'),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: SizedBox(
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.image, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                    child: const Icon(Icons.bookmark_border_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            item.meta,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('🔥', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiCard extends StatelessWidget {
  const _AiCard({required this.title, required this.sub, required this.cta});
  final String title;
  final String sub;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(18),
      onTap: () => GoRouter.of(context).push(
          '/programs/core-recovery?title=Core%20Recovery'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => GoRouter.of(context).push(
                      '/programs/core-recovery?title=Core%20Recovery'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    minimumSize: const Size(0, 40),
                  ),
                  child: Text(cta),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  AppPalette.primary.withValues(alpha: 0.4),
                  AppPalette.accentPurple.withValues(alpha: 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 38),
          ),
        ],
      ),
    );
  }
}
