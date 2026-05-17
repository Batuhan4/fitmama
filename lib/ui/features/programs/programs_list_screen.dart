import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/program_catalog.dart';
import '../../../data/repositories/app_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';

class ProgramsListScreen extends StatelessWidget {
  const ProgramsListScreen({
    super.key,
    this.title = 'Tüm programlar',
    required this.repository,
  });

  final String title;
  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListenableBuilder(
        listenable: repository,
        builder: (_, _) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          itemCount: kAllPrograms.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final p = kAllPrograms[i];
            final def = programById(p.id);
            final progress = repository.progressFor(p.id);
            final totalLevels = def?.levels.length ?? 0;
            final doneLevels = progress.completedLevels.length;
            final pct = totalLevels == 0 ? 0.0 : doneLevels / totalLevels;
            return FitmamaCard(
              padding: EdgeInsets.zero,
              onTap: () => GoRouter.of(context).push(
                '/programs/${Uri.encodeComponent(p.id)}?title=${Uri.encodeComponent(p.title)}',
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(17)),
                    child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Image.asset(p.image, fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(p.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _MiniBadge(
                                  icon: Icons.layers_rounded,
                                  label: '$totalLevels sv'),
                              const SizedBox(width: 6),
                              _MiniBadge(
                                  icon: Icons.schedule_rounded,
                                  label: p.duration),
                              const SizedBox(width: 6),
                              _MiniBadge(
                                  icon: Icons.bar_chart_rounded,
                                  label: p.level),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: AppPalette.primary
                                            .withValues(alpha: 0.16),
                                        borderRadius:
                                            BorderRadius.circular(99),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: pct.clamp(0.0, 1.0),
                                      child: Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: AppPalette.primary,
                                          borderRadius:
                                              BorderRadius.circular(99),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                doneLevels == 0
                                    ? 'Başla'
                                    : '$doneLevels/$totalLevels',
                                style: const TextStyle(
                                  color: AppPalette.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoriteWorkoutsScreen extends StatelessWidget {
  const FavoriteWorkoutsScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    return ProgramsListScreen(
        title: 'Favori workoutlar', repository: repository);
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppPalette.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppPalette.primary, size: 10),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  color: AppPalette.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class ProgramMini {
  const ProgramMini({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.days,
    required this.duration,
    required this.level,
    required this.icon,
    required this.gradient,
    required this.image,
  });
  final String id;
  final String title;
  final String subtitle;
  final String days;
  final String duration;
  final String level;
  final IconData icon;
  final List<Color> gradient;
  final String image;
}

const kAllPrograms = <ProgramMini>[
  ProgramMini(
    id: 'core-recovery',
    title: 'Core Recovery',
    subtitle: 'Postpartum karın bölgesini güvenli adımlarla yeniden inşa et.',
    days: '30 gün',
    duration: '20 dk',
    level: 'Tüm seviye',
    icon: Icons.self_improvement_rounded,
    gradient: [Color(0xFFE91E63), Color(0xFF6D28D9)],
    image: 'assets/images/workouts/mom_baby.jpg',
  ),
  ProgramMini(
    id: 'kalca-gelistirme',
    title: 'Kalça Geliştirme',
    subtitle: 'Glute + kalça odaklı 4 haftalık güç programı.',
    days: '28 gün',
    duration: '25 dk',
    level: 'Orta',
    icon: Icons.directions_run_rounded,
    gradient: [Color(0xFFFF6FB1), Color(0xFFE91E63)],
    image: 'assets/images/workouts/donkey_kick.jpg',
  ),
  ProgramMini(
    id: 'bel-inceltme',
    title: 'Bel İnceltme',
    subtitle: 'Diastasis-safe core + nefes ile bel çevresini hedefle.',
    days: '21 gün',
    duration: '15 dk',
    level: 'Başlangıç',
    icon: Icons.accessibility_new_rounded,
    gradient: [Color(0xFFC4B5FD), Color(0xFF6D28D9)],
    image: 'assets/images/workouts/bicycle_crunch.jpg',
  ),
  ProgramMini(
    id: 'guclu-anne',
    title: 'Güçlü Anne',
    subtitle: 'Full body kuvvet programı; haftada 3 seans.',
    days: '45 gün',
    duration: '40 dk',
    level: 'İleri',
    icon: Icons.fitness_center_rounded,
    gradient: [Color(0xFFFB923C), Color(0xFFDC2626)],
    image: 'assets/images/workouts/kettlebell_squat.jpg',
  ),
  ProgramMini(
    id: 'pelvik-taban',
    title: 'Pelvik Taban Reset',
    subtitle: 'Günlük 10 dk pelvik farkındalık + nefes.',
    days: '14 gün',
    duration: '10 dk',
    level: 'Başlangıç',
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFFCE7F3), Color(0xFFEC4899)],
    image: 'assets/images/workouts/yoga_stretch.jpg',
  ),
  ProgramMini(
    id: 'hiit-burn',
    title: 'HIIT Burn',
    subtitle: '15 dk yüksek yoğunluk; düşük etki versiyon dahil.',
    days: '21 gün',
    duration: '15 dk',
    level: 'İleri',
    icon: Icons.local_fire_department_rounded,
    gradient: [Color(0xFFDC2626), Color(0xFF7C2D12)],
    image: 'assets/images/workouts/cardio_kick.jpg',
  ),
  ProgramMini(
    id: 'yoga-flow',
    title: 'Yoga & Mobilite',
    subtitle: 'Esneklik + zihinsel toparlanma için akıcı yoga.',
    days: '30 gün',
    duration: '25 dk',
    level: 'Tüm seviye',
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFA78BFA), Color(0xFF4C1D95)],
    image: 'assets/images/workouts/meditation.jpg',
  ),
  ProgramMini(
    id: 'gunluk-yuruyus',
    title: 'Günlük Yürüyüş',
    subtitle: 'Aktif gün için 30 dk yapılandırılmış yürüyüş planı.',
    days: '30 gün',
    duration: '30 dk',
    level: 'Tüm seviye',
    icon: Icons.directions_walk_rounded,
    gradient: [Color(0xFF34D399), Color(0xFF166534)],
    image: 'assets/images/programs/outdoor_run.jpg',
  ),
];
