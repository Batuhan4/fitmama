import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final data = _RecipeDb.get(title);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 240,
            backgroundColor: scheme.surface,
            leading: _CircleBack(),
            actions: [
              _CircleIcon(icon: Icons.favorite_border_rounded, onTap: () {}),
              _CircleIcon(icon: Icons.share_outlined, onTap: () {}),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(data.image, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.5),
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
          SliverList.list(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Text(title,
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 26)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _IconStat(
                      icon: Icons.schedule_rounded, label: data.minutes),
                  _IconStat(
                      icon: Icons.local_fire_department_rounded,
                      label: '${data.kcal} kcal'),
                  _IconStat(
                      icon: Icons.star_rounded, label: data.rating),
                  _IconStat(
                      icon: Icons.bar_chart_rounded, label: data.difficulty),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'Besin değerleri', upper: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _MacroChip(label: 'Protein',
                      value: '${data.protein}g',
                      color: AppPalette.primary),
                  const SizedBox(width: 8),
                  _MacroChip(label: 'Karb',
                      value: '${data.carbs}g',
                      color: AppPalette.accentPurple),
                  const SizedBox(width: 8),
                  _MacroChip(label: 'Yağ',
                      value: '${data.fat}g',
                      color: AppPalette.accentOrange),
                  const SizedBox(width: 8),
                  _MacroChip(label: 'Lif',
                      value: '${data.fiber}g',
                      color: AppPalette.accentGreen),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: 'Malzemeler', upper: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FitmamaCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    for (var i = 0; i < data.ingredients.length; i++) ...[
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppPalette.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(data.ingredients[i],
                                style: const TextStyle(fontSize: 13.5)),
                          ),
                        ],
                      ),
                      if (i < data.ingredients.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: 'Yapılışı', upper: true),
            for (var i = 0; i < data.steps.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: FitmamaCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.primary,
                        ),
                        alignment: Alignment.center,
                        child: Text('${i + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(data.steps[i],
                            style: const TextStyle(
                                fontSize: 13.5, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                              content: Text('"$title" plana eklendi'))),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Plana ekle'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                            content: Text('Alışverişe eklendi'))),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(50, 50),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.shopping_basket_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ]),
        ],
      ),
    );
  }
}

class _CircleBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _IconStat extends StatelessWidget {
  const _IconStat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.primary.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: AppPalette.primary, size: 18),
          ),
          const SizedBox(height: 6),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface)),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: color)),
            Text(label,
                style: TextStyle(fontSize: 10.5, color: color)),
          ],
        ),
      ),
    );
  }
}

class _RecipeData {
  const _RecipeData({
    required this.minutes,
    required this.kcal,
    required this.rating,
    required this.difficulty,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.ingredients,
    required this.steps,
    required this.icon,
    required this.gradient,
    required this.image,
  });
  final String minutes;
  final int kcal;
  final String rating;
  final String difficulty;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final List<String> ingredients;
  final List<String> steps;
  final IconData icon;
  final List<Color> gradient;
  final String image;
}

class _RecipeDb {
  static const _generic = _RecipeData(
    minutes: '20 dk',
    kcal: 380,
    rating: '4.7',
    difficulty: 'Kolay',
    protein: 22,
    carbs: 38,
    fat: 14,
    fiber: 6,
    ingredients: [
      '2 yumurta',
      '1 dilim tam buğday ekmek',
      '½ avokado',
      'Çekilmiş karabiber, tuz',
      '1 tatlı kaşığı zeytinyağı',
      'Bir tutam pul biber',
    ],
    steps: [
      'Tavayı ısıt, zeytinyağı ekle.',
      'Yumurtaları kır, hafifçe karıştırarak omlet pişir.',
      'Ekmeği tost makinesine at, kızar kızmaz çıkar.',
      'Avokadoyu püre yap, baharatlarla karıştır.',
      'Ekmeği avokado püresiyle sür, üzerine omleti yerleştir.',
      'Pul biberle servis et.',
    ],
    icon: Icons.lunch_dining_rounded,
    gradient: [Color(0xFFFCE7F3), Color(0xFFE91E63)],
    image: 'assets/images/meals/avocado_toast.jpg',
  );

  static const _yulaf = _RecipeData(
    minutes: '10 dk',
    kcal: 310,
    rating: '4.9',
    difficulty: 'Çok kolay',
    protein: 14,
    carbs: 45,
    fat: 8,
    fiber: 8,
    ingredients: [
      '½ su bardağı yulaf ezmesi',
      '1 su bardağı süt',
      '1 muz',
      '1 yemek kaşığı bal',
      '1 tatlı kaşığı tarçın',
      'Bir avuç ceviz',
    ],
    steps: [
      'Yulafı süt ile bir tencerede orta ateşte 5 dk karıştırarak pişir.',
      'Muzu dilimle, yulafın üzerine ekle.',
      'Bal ve tarçınla tatlandır.',
      'Üzerine cevizi serpiştir, servis et.',
    ],
    icon: Icons.breakfast_dining_rounded,
    gradient: [Color(0xFFFCE7F3), Color(0xFFFF6FB1)],
    image: 'assets/images/meals/overnight_oats.jpg',
  );

  static const _pankek = _RecipeData(
    minutes: '20 dk',
    kcal: 410,
    rating: '4.9',
    difficulty: 'Kolay',
    protein: 16,
    carbs: 54,
    fat: 10,
    fiber: 7,
    ingredients: [
      '1 muz',
      '2 yumurta',
      '½ su bardağı yulaf',
      '1 ölçek protein tozu',
      '1 tatlı kaşığı kabartma tozu',
      'Bir tutam tarçın',
    ],
    steps: [
      'Tüm malzemeleri blenderdan geçir.',
      'Yapışmaz tavada her iki yüzünü 1-2 dk pişir.',
      'Üstüne meyve ve bal ile servis et.',
    ],
    icon: Icons.cake_rounded,
    gradient: [Color(0xFFFCE7F3), Color(0xFFFF6FB1)],
    image: 'assets/images/meals/blueberry_cheesecake.jpg',
  );

  static const _mousse = _RecipeData(
    minutes: '15 dk + 2 sa dinlenme',
    kcal: 220,
    rating: '4.7',
    difficulty: 'Kolay',
    protein: 8,
    carbs: 28,
    fat: 9,
    fiber: 5,
    ingredients: [
      '1 olgun avokado',
      '3 yemek kaşığı kakao',
      '2 yemek kaşığı bal veya hurma şurubu',
      '½ su bardağı badem sütü',
      '1 tutam tuz',
      'Vanilya',
    ],
    steps: [
      'Avokadoyu blendera al, tüm malzemeleri ekle.',
      'Pürüzsüz olana dek karıştır.',
      'Kaselere döküp 2 saat buzdolabında bekletip servis et.',
    ],
    icon: Icons.icecream_rounded,
    gradient: [Color(0xFF1F1815), Color(0xFF6B3A1C)],
    image: 'assets/images/meals/chocolate_mousse.jpg',
  );

  static _RecipeData get(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('yulaf')) return _yulaf;
    if (lower.contains('pankek')) return _pankek;
    if (lower.contains('mousse')) return _mousse;
    return _generic;
  }
}
