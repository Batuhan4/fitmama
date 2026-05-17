import 'package:flutter/material.dart';

import '../../../data/models/profile.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';
import '../dashboard/water_quick_widget.dart';

class _MealIdea {
  const _MealIdea({
    required this.slot,
    required this.title,
    required this.desc,
    required this.kcal,
    this.blockAllergens = const [],
    this.blockDislikes = const [],
  });
  final String slot;
  final String title;
  final String desc;
  final int kcal;
  final List<String> blockAllergens;
  final List<String> blockDislikes;
}

const _meals = <_MealIdea>[
  // Kahvaltı
  _MealIdea(
      slot: 'breakfast',
      title: 'Yulaflı kahvaltı + muz + ceviz',
      desc: 'Yavaş salınan karbonhidrat + omega-3 ile sabah enerjisi.',
      kcal: 380,
      blockAllergens: ['gluten', 'nuts']),
  _MealIdea(
      slot: 'breakfast',
      title: 'Avokadolu yumurta tost',
      desc: 'Protein + sağlıklı yağ, emzirme sabahı için ideal.',
      kcal: 420,
      blockAllergens: ['egg', 'gluten']),
  _MealIdea(
      slot: 'breakfast',
      title: 'Yoğurt + meyve + chia',
      desc: 'Probiyotik ve kalsiyum.',
      kcal: 310,
      blockAllergens: ['milk'],
      blockDislikes: ['dairy']),

  // Öğle
  _MealIdea(
      slot: 'lunch',
      title: 'Mercimek çorbası + tam buğday ekmek',
      desc: 'Demir, lif ve doyurucu B vitamini.',
      kcal: 440,
      blockDislikes: ['legumes']),
  _MealIdea(
      slot: 'lunch',
      title: 'Izgara tavuk + kinoa + sebze',
      desc: 'Yağsız protein ve tam tahıl.',
      kcal: 520,
      blockDislikes: ['red_meat']),
  _MealIdea(
      slot: 'lunch',
      title: 'Somonlu salata + bulgur',
      desc: 'Omega-3 ruh halini destekler.',
      kcal: 490,
      blockAllergens: ['seafood'],
      blockDislikes: ['fish']),

  // Ara öğün
  _MealIdea(
      slot: 'snack',
      title: 'Humus + havuç + tam tahıllı kraker',
      desc: 'Hafif, lif yüklü ara öğün.',
      kcal: 220,
      blockDislikes: ['legumes', 'veg']),
  _MealIdea(
      slot: 'snack',
      title: 'Bir avuç badem + 1 elma',
      desc: 'Hızlı enerji ve magnezyum.',
      kcal: 240,
      blockAllergens: ['nuts']),
  _MealIdea(
      slot: 'snack',
      title: 'Yoğurt + bal + tarçın',
      desc: 'Süt proteini + sıcak baharatlı doku.',
      kcal: 200,
      blockAllergens: ['milk'],
      blockDislikes: ['dairy']),

  // Akşam
  _MealIdea(
      slot: 'dinner',
      title: 'Sebzeli tavuk sote + pirinç',
      desc: 'Hafif akşam, kolay sindirim.',
      kcal: 540,
      blockDislikes: ['red_meat']),
  _MealIdea(
      slot: 'dinner',
      title: 'Fırın somon + tatlı patates',
      desc: 'D vitamini ve omega-3.',
      kcal: 560,
      blockAllergens: ['seafood'],
      blockDislikes: ['fish']),
  _MealIdea(
      slot: 'dinner',
      title: 'Mercimek köftesi + yeşillik salatası',
      desc: 'Etsiz, doyurucu, demir kaynağı.',
      kcal: 470,
      blockDislikes: ['legumes']),
];

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  int _seed = 0;

  List<_MealIdea> _pickForSlot(String slot, Profile? profile) {
    final allergens = profile?.allergens ?? const [];
    final dislikes = profile?.dislikes ?? const [];
    final pool = _meals.where((m) => m.slot == slot).toList();
    final safe = pool.where((m) {
      final ba = m.blockAllergens.any((a) => allergens.contains(a));
      final bd = m.blockDislikes.any((d) => dislikes.contains(d));
      return !ba && !bd;
    }).toList();
    final src = safe.isEmpty ? pool : safe;
    final i = (DateTime.now().day + _seed) % src.length;
    return [src[i]];
  }

  String _slotLabel(String slot) {
    switch (slot) {
      case 'breakfast':
        return 'Kahvaltı';
      case 'lunch':
        return 'Öğle';
      case 'snack':
        return 'Ara öğün';
      case 'dinner':
        return 'Akşam';
      default:
        return slot;
    }
  }

  IconData _slotIcon(String slot) {
    switch (slot) {
      case 'breakfast':
        return Icons.free_breakfast_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'snack':
        return Icons.local_cafe_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = widget.repository.profile;
    final slots = ['breakfast', 'lunch', 'snack', 'dinner'];
    final picks = {
      for (final s in slots) s: _pickForSlot(s, profile).first,
    };
    final totalKcal = picks.values.fold<int>(0, (a, m) => a + m.kcal);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        WaterQuickWidget(repository: widget.repository),
        const SizedBox(height: 12),
        AccentCard(
          color: const Color(0xFF6EE7B7),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.nutWhatToEat,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shuffle_rounded, size: 18),
                    onPressed: () => setState(() => _seed += 1),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$totalKcal kcal/gün — emzirme döneminde ortalama +500 kcal önerilir',
                style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...slots.map((slot) {
          final pick = picks[slot]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MomriseCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primary.withValues(alpha: 0.12),
                        ),
                        child: Icon(_slotIcon(slot),
                            color: scheme.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_slotLabel(slot).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                  color: scheme.onSurfaceVariant,
                                )),
                            Text(pick.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Text(
                        '${pick.kcal} kcal',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(pick.desc,
                      style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 60),
      ],
    );
  }
}
