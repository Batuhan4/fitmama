import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';
import '../shell/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final name = repository.profile?.name ?? '';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FitmamaTopBar(
          repository: repository,
          showAvatar: true,
          actions: [
            HeaderIconButton(
              icon: Icons.notifications_none_rounded,
              badge: true,
              tooltip: 'Bildirimler',
              onTap: () => context.push('/notifications'),
            ),
          ],
        ),
        _WelcomeBanner(name: name, motivation: t.homeMotivationToday,
            greeting: t.homeWelcomeBack),
        const SizedBox(height: 20),
        _DiscoveryRow(),
        const SizedBox(height: 28),
        SectionHeader(
          title: t.homeRoutineSuggestions,
          upper: true,
          trailingLabel: t.homeViewAll,
          onTrailingTap: () => context.push('/programs/list?title=Rutin%20önerileri'),
        ),
        const _RoutineStrip(),
        const SizedBox(height: 28),
        SectionHeader(
          title: t.homeNewPrograms,
          upper: true,
          trailingLabel: t.homeViewAll,
          onTrailingTap: () => context.push('/programs/list?title=Yeni%20programlar'),
        ),
        const _NewProgramsRow(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _InviteCard(
            title: t.homeInviteTitle,
            body: t.homeInviteBody,
            cta: t.homeInviteCta,
          ),
        ),
        const SizedBox(height: 28),
        SectionHeader(title: t.homeFavorites, upper: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _FavoriteCard(
                  title: t.homeFavoriteRecipes,
                  subtitle: t.homeFavoriteRecipesSub,
                  icon: Icons.restaurant_rounded,
                  iconColor: AppPalette.accentOrange,
                  image: 'assets/images/meals/smoothie_bowl.jpg',
                  onTap: () => context.push('/nutrition/favorites'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FavoriteCard(
                  title: t.homeFavoriteWorkouts,
                  subtitle: t.homeFavoriteWorkoutsSub,
                  icon: Icons.fitness_center_rounded,
                  iconColor: AppPalette.primary,
                  image: 'assets/images/workouts/plank.jpg',
                  onTap: () => context.push('/programs/favorites'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _CommunityRow(intro: t.homeCommunityIntro, sub: t.homeCommunitySub),
        const SizedBox(height: 28),
        SectionHeader(
          title: t.homeStories,
          upper: true,
          trailingLabel: t.homeAllStories,
          onTrailingTap: () => context.push('/community'),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'Daha güçlü, daha sağlıklı, daha mutlu anneler.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const _TransformationsRow(),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({
    required this.name,
    required this.greeting,
    required this.motivation,
  });
  final String name;
  final String greeting;
  final String motivation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                greeting,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 8),
              const Text('👋', style: TextStyle(fontSize: 24)),
            ],
          ),
          if (name.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              name,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: scheme.primary,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: Text(
                  motivation,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 6),
              const Text('💕', style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscoveryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final items = [
      _DiscoveryItem(
        title: t.homeDiscoverFitness,
        sub: t.homeDiscoverFitnessSub,
        icon: Icons.fitness_center_rounded,
        gradient: const [Color(0xFFFF2E7E), Color(0xFF8E1A4F)],
        image: 'assets/images/discover/fitness.jpg',
        route: '/programs',
      ),
      _DiscoveryItem(
        title: t.homeDiscoverNutrition,
        sub: t.homeDiscoverNutritionSub,
        icon: Icons.eco_rounded,
        gradient: const [Color(0xFF34D399), Color(0xFF166534)],
        image: 'assets/images/discover/nutrition.jpg',
        route: '/nutrition',
      ),
      _DiscoveryItem(
        title: t.homeDiscoverTips,
        sub: t.homeDiscoverTipsSub,
        icon: Icons.favorite_rounded,
        gradient: const [Color(0xFFC4B5FD), Color(0xFF6D28D9)],
        image: 'assets/images/discover/health.jpg',
        route: '/nutrition/blog',
      ),
    ];
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _DiscoveryCard(item: items[i]),
      ),
    );
  }
}

class _DiscoveryItem {
  const _DiscoveryItem({
    required this.title,
    required this.sub,
    required this.icon,
    required this.gradient,
    required this.route,
    this.image,
  });
  final String title;
  final String sub;
  final IconData icon;
  final List<Color> gradient;
  final String route;
  final String? image;
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.item});
  final _DiscoveryItem item;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SizedBox(
      width: 200,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () {
          if (item.route.startsWith('/nutrition/blog') ||
              item.route.contains('/recipe') ||
              item.route.contains('/profile') ||
              item.route.contains('/programs/')) {
            GoRouter.of(context).push(item.route);
          } else {
            GoRouter.of(context).go(item.route);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.image != null)
                Image.asset(item.image!, fit: BoxFit.cover)
              else
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.28),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(item.icon, color: Colors.white, size: 20),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.sub,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppPalette.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t.homeDiscoverExplore,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutineStrip extends StatelessWidget {
  const _RoutineStrip();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = <_RoutineItem>[
      _RoutineItem('Şekeri Bırakma', Icons.no_food_rounded,
          AppPalette.accentPurple, '/nutrition/blog/emzirme-ve-beslenme'),
      _RoutineItem('Yağ Oranı Düşürme', Icons.local_fire_department_rounded,
          AppPalette.accentOrange,
          '/programs/hiit-burn?title=HIIT%20Burn'),
      _RoutineItem('Core Güçlendirme', Icons.center_focus_strong_rounded,
          AppPalette.accentYellow,
          '/programs/core-recovery?title=Core%20Recovery'),
      _RoutineItem('Shuffle Workout', Icons.shuffle_rounded,
          AppPalette.accentBlue, '/programs/list?title=Shuffle%20workout'),
      _RoutineItem('Meditasyon & Yoga', Icons.self_improvement_rounded,
          AppPalette.accentPurple,
          '/programs/yoga-flow?title=Yoga%20%26%20Mobilite'),
      _RoutineItem('Stretch & Release', Icons.accessibility_new_rounded,
          AppPalette.primary,
          '/programs/pelvik-taban?title=Pelvik%20Taban%20Reset'),
      _RoutineItem('Günlük Yürüyüş', Icons.directions_walk_rounded,
          AppPalette.accentGreen,
          '/programs/gunluk-yuruyus?title=G%C3%BCnl%C3%BCk%20Y%C3%BCr%C3%BCy%C3%BC%C5%9F'),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final item = items[i];
          return SizedBox(
            width: 76,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => GoRouter.of(context).push(item.route),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: item.color.withValues(alpha: 0.35)),
                    ),
                    child: Icon(item.icon, color: item.color, size: 26),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoutineItem {
  const _RoutineItem(this.label, this.icon, this.color, this.route);
  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class _NewProgramsRow extends StatelessWidget {
  const _NewProgramsRow();

  @override
  Widget build(BuildContext context) {
    final programs = <_ProgramTeaser>[
      _ProgramTeaser('Kalça Geliştirme', '28 gün · Orta',
          AppPalette.primary, Icons.directions_run_rounded,
          'assets/images/workouts/donkey_kick.jpg'),
      _ProgramTeaser('Bel İnceltme', '21 gün · Başlangıç',
          AppPalette.accentPurple, Icons.accessibility_new_rounded,
          'assets/images/workouts/bicycle_crunch.jpg'),
      _ProgramTeaser('Core Recovery', '30 gün · Tüm seviye',
          AppPalette.accentOrange, Icons.self_improvement_rounded,
          'assets/images/workouts/mom_baby.jpg'),
      _ProgramTeaser('Güçlü Anne', '45 gün · İleri',
          AppPalette.accentGreen, Icons.fitness_center_rounded,
          'assets/images/workouts/kettlebell_squat.jpg'),
    ];
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: programs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _ProgramTeaserCard(p: programs[i]),
      ),
    );
  }
}

class _ProgramTeaser {
  const _ProgramTeaser(this.title, this.meta, this.color, this.icon, this.image);
  final String title;
  final String meta;
  final Color color;
  final IconData icon;
  final String image;
}

class _ProgramTeaserCard extends StatelessWidget {
  const _ProgramTeaserCard({required this.p});
  final _ProgramTeaser p;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 150,
      child: FitmamaCard(
        padding: EdgeInsets.zero,
        onTap: () => GoRouter.of(context).push(
            '/programs/${Uri.encodeComponent(p.title.toLowerCase())}?title=${Uri.encodeComponent(p.title)}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17)),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: Image.asset(p.image, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppPalette.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      t.homeNewBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 13, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        p.meta,
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard(
      {required this.title, required this.body, required this.cta});
  final String title;
  final String body;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      gradient: LinearGradient(
        colors: [
          AppPalette.primary.withValues(alpha: 0.18),
          AppPalette.primary.withValues(alpha: 0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppPalette.primary.withValues(alpha: 0.35)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.primary.withValues(alpha: 0.18),
            ),
            child: const Icon(Icons.group_add_rounded,
                color: AppPalette.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppPalette.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Davet linki kopyalandı')),
                  ),
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
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.image,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              SizedBox(
                height: 96,
                width: double.infinity,
                child: Image.asset(image!, fit: BoxFit.cover),
              )
            else
              Container(
                height: 96,
                color: iconColor.withValues(alpha: 0.15),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 32),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 11.5,
                        color: scheme.onSurfaceVariant,
                        height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.primary,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityRow extends StatelessWidget {
  const _CommunityRow({required this.intro, required this.sub});
  final String intro;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final socials = <_SocialItem>[
      _SocialItem(Icons.camera_alt_rounded, const Color(0xFFE1306C),
          'Instagram'),
      _SocialItem(Icons.music_note_rounded, const Color(0xFF111111),
          'TikTok'),
      _SocialItem(Icons.play_arrow_rounded, const Color(0xFFFF0000),
          'YouTube'),
      _SocialItem(Icons.facebook_rounded, const Color(0xFF1877F2),
          'Facebook'),
      _SocialItem(Icons.email_rounded, AppPalette.accentBlue, 'Mail'),
    ];
    return Column(
      children: [
        Text(intro.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              letterSpacing: 0.8,
            )),
        const SizedBox(height: 4),
        Text(sub,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.5, color: scheme.onSurfaceVariant)),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final s in socials)
              _SocialChip(item: s),
          ],
        ),
      ],
    );
  }
}

class _SocialItem {
  const _SocialItem(this.icon, this.color, this.label);
  final IconData icon;
  final Color color;
  final String label;
}

class _SocialChip extends StatelessWidget {
  const _SocialChip({required this.item});
  final _SocialItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.label} açılıyor…')),
      ),
      borderRadius: BorderRadius.circular(99),
      child: Tooltip(
        message: item.label,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.color.withValues(alpha: 0.12),
            border: Border.all(color: item.color.withValues(alpha: 0.5)),
          ),
          child: Icon(item.icon, color: item.color, size: 22),
        ),
      ),
    );
  }
}

class _Transformation {
  const _Transformation({
    required this.name,
    required this.beforeAsset,
    required this.afterAsset,
    required this.lossKg,
    required this.months,
  });
  final String name;
  final String beforeAsset;
  final String afterAsset;
  final int lossKg;
  final int months;
}

class _TransformationsRow extends StatelessWidget {
  const _TransformationsRow();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Transformation(
        name: 'Aslı, 34',
        beforeAsset: 'assets/images/transformations/m1_before.jpg',
        afterAsset: 'assets/images/transformations/m1_after.jpg',
        lossKg: 14,
        months: 5,
      ),
      _Transformation(
        name: 'Deniz, 31',
        beforeAsset: 'assets/images/transformations/m2_before.jpg',
        afterAsset: 'assets/images/transformations/m2_after.jpg',
        lossKg: 18,
        months: 6,
      ),
      _Transformation(
        name: 'Ece, 29',
        beforeAsset: 'assets/images/transformations/m3_before.jpg',
        afterAsset: 'assets/images/transformations/m3_after.jpg',
        lossKg: 12,
        months: 4,
      ),
    ];
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _TransformationCard(item: items[i]),
      ),
    );
  }
}

class _TransformationCard extends StatelessWidget {
  const _TransformationCard({required this.item});
  final _Transformation item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 240,
      child: FitmamaCard(
        padding: EdgeInsets.zero,
        onTap: () => GoRouter.of(context).push('/community'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(17)),
              child: Row(
                children: [
                  Expanded(
                    child: _BeforeAfterPhoto(
                      asset: item.beforeAsset,
                      label: 'ÖNCE',
                      labelColor: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),
                  Expanded(
                    child: _BeforeAfterPhoto(
                      asset: item.afterAsset,
                      label: 'SONRA',
                      labelColor: AppPalette.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppPalette.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '−${item.lossKg} kg',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${item.months} ayda FitMama ile',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeforeAfterPhoto extends StatelessWidget {
  const _BeforeAfterPhoto({
    required this.asset,
    required this.label,
    required this.labelColor,
  });
  final String asset;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.85,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(asset, fit: BoxFit.cover),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: labelColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
