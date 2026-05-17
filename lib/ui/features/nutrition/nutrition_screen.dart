import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/profile.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';
import '../shell/top_bar.dart';

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
  _MealIdea(
      slot: 'breakfast',
      title: 'Yulaf ezmesi ve meyveler',
      desc: 'Yavaş salınan karbonhidrat + omega-3 ile sabah enerjisi.',
      kcal: 380,
      blockAllergens: ['gluten']),
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
  _MealIdea(
      slot: 'lunch',
      title: 'Izgara tavuk salata',
      desc: 'Yağsız protein ve tam tahıl.',
      kcal: 520,
      blockDislikes: ['red_meat']),
  _MealIdea(
      slot: 'lunch',
      title: 'Mercimek çorbası + tam buğday ekmek',
      desc: 'Demir, lif ve doyurucu B vitamini.',
      kcal: 440,
      blockDislikes: ['legumes']),
  _MealIdea(
      slot: 'snack',
      title: 'Chia puding',
      desc: 'Hafif, lif yüklü ara öğün.',
      kcal: 220,
      blockAllergens: ['milk']),
  _MealIdea(
      slot: 'snack',
      title: 'Bir avuç badem + 1 elma',
      desc: 'Hızlı enerji ve magnezyum.',
      kcal: 240,
      blockAllergens: ['nuts']),
  _MealIdea(
      slot: 'dinner',
      title: 'Fırın sebzeli somon',
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
  int _categoryTab = 0;
  int _dayTab = DateTime.now().weekday - 1;
  int _seed = 0;

  _MealIdea _pickForSlot(String slot, Profile? profile) {
    final allergens = profile?.allergens ?? const [];
    final dislikes = profile?.dislikes ?? const [];
    final pool = _meals.where((m) => m.slot == slot).toList();
    final safe = pool.where((m) {
      final ba = m.blockAllergens.any((a) => allergens.contains(a));
      final bd = m.blockDislikes.any((d) => dislikes.contains(d));
      return !ba && !bd;
    }).toList();
    final src = safe.isEmpty ? pool : safe;
    final i = (DateTime.now().day + _seed + _dayTab) % src.length;
    return src[i];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = widget.repository.profile;

    final slots = ['breakfast', 'lunch', 'dinner', 'snack'];
    final mealLabels = {
      'breakfast': t.nutMealBreakfast,
      'lunch': t.nutMealLunch,
      'dinner': t.nutMealDinner,
      'snack': t.nutMealSnack,
    };
    final picks = {for (final s in slots) s: _pickForSlot(s, profile)};

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FitmamaTopBar(
          repository: widget.repository,
          actions: [
            HeaderIconButton(
              icon: Icons.search_rounded,
              onTap: () => context.push('/search'),
              tooltip: 'Ara',
            ),
            HeaderIconButton(
              icon: Icons.notifications_none_rounded,
              badge: true,
              onTap: () => context.push('/notifications'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Row(
            children: [
              Text('Beslenme & Tarifler',
                  style: theme.textTheme.displaySmall),
              const SizedBox(width: 8),
              const Text('🌿', style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Flexible(
                  child: Text('Sağlıklı beslen, güçlü kal!',
                      style: theme.textTheme.bodyMedium)),
              const SizedBox(width: 4),
              const Text('💕', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        _CategoryTabs(
          tabs: [
            t.nutTabAll,
            t.nutTabAirfryer,
            t.nutTabDessert,
            t.nutTabOther,
          ],
          selected: _categoryTab,
          onChanged: (i) => setState(() => _categoryTab = i),
        ),
        const SizedBox(height: 20),
        SectionHeader(
          title: t.nutPopular,
          upper: true,
          trailingLabel: t.homeViewAll,
          onTrailingTap: () => context.push('/nutrition/recipes'),
        ),
        const _PopularRow(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.nutWeekPlan,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(t.nutWeekPlanSub,
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.primary,
                ),
                child: const Icon(Icons.calendar_today_rounded,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _DayStrip(
          selected: _dayTab,
          onChanged: (i) => setState(() => _dayTab = i),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (final slot in slots) ...[
                Expanded(
                  child: _MealCard(
                    label: mealLabels[slot]!,
                    title: picks[slot]!.title,
                    kcal: picks[slot]!.kcal,
                    icon: _slotIcon(slot),
                    image: _slotImage(slot, picks[slot]!.title),
                  ),
                ),
                if (slot != slots.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton.icon(
            onPressed: () {
              setState(() => _seed += 1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yeni plan oluşturuldu')),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: Text(t.nutEditPlan),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(title: t.nutMoreTitle, upper: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _SmallActionCard(
                  title: 'AI yemek analizi',
                  sub: 'Yemeği fotoğrafla, kalori + besin değerleri hazır.',
                  icon: Icons.auto_awesome_rounded,
                  iconColor: AppPalette.primary,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onTap: () => context.push('/nutrition/ai'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SmallActionCard(
                  title: t.nutShoppingList,
                  sub: t.nutShoppingListSub,
                  icon: Icons.shopping_basket_rounded,
                  iconColor: AppPalette.accentPurple,
                  trailingIcon: Icons.add_rounded,
                  onTap: () => context.push('/nutrition/shopping'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SmallActionCard(
            title: t.nutBlog,
            sub: t.nutBlogSub,
            icon: Icons.article_rounded,
            iconColor: AppPalette.accentBlue,
            trailingIcon: Icons.arrow_forward_rounded,
            onTap: () => context.push('/nutrition/blog'),
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(title: t.nutNutrients, upper: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _NutrientPills(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: Text('* ${t.nutPerServing}',
              style: theme.textTheme.bodySmall),
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: t.nutFavorites,
          upper: true,
          trailingLabel: t.homeViewAll,
          onTrailingTap: () => context.push('/nutrition/favorites'),
        ),
        const _FavoritesGrid(),
        const SizedBox(height: 28),
      ],
    );
  }

  IconData _slotIcon(String slot) {
    switch (slot) {
      case 'breakfast':
        return Icons.free_breakfast_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      case 'snack':
        return Icons.local_cafe_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  String _slotImage(String slot, String title) {
    final t = title.toLowerCase();
    if (t.contains('yulaf') && t.contains('yoğurt')) {
      return 'assets/images/meals/overnight_oats.jpg';
    }
    if (t.contains('yulaf')) return 'assets/images/meals/overnight_oats.jpg';
    if (t.contains('avokado')) return 'assets/images/meals/avocado_toast.jpg';
    if (t.contains('yoğurt')) return 'assets/images/meals/chia_pudding.jpg';
    if (t.contains('mercimek')) return 'assets/images/meals/beef_stew.jpg';
    if (t.contains('tavuk') && t.contains('salata')) {
      return 'assets/images/meals/chicken_bowl.jpg';
    }
    if (t.contains('tavuk')) return 'assets/images/meals/grilled_chicken.jpg';
    if (t.contains('somon')) return 'assets/images/meals/salmon_rice.jpg';
    if (t.contains('chia')) return 'assets/images/meals/chia_pudding.jpg';
    if (t.contains('badem') || t.contains('elma')) {
      return 'assets/images/meals/banana_oat_smoothie.jpg';
    }
    switch (slot) {
      case 'breakfast':
        return 'assets/images/meals/avocado_toast.jpg';
      case 'lunch':
        return 'assets/images/meals/chicken_bowl.jpg';
      case 'dinner':
        return 'assets/images/meals/salmon_rice.jpg';
      case 'snack':
        return 'assets/images/meals/chia_pudding.jpg';
      default:
        return 'assets/images/meals/grilled_chicken.jpg';
    }
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs(
      {required this.tabs, required this.selected, required this.onChanged});
  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 88,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary
                    : Theme.of(context).brightness == Brightness.dark
                        ? AppPalette.darkSurfaceRaised
                        : AppPalette.lightSurfaceRaised,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_iconFor(i),
                      color: isSelected ? Colors.white : scheme.onSurface,
                      size: 22),
                  const SizedBox(height: 6),
                  Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                      height: 1.15,
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

  IconData _iconFor(int i) {
    switch (i) {
      case 0:
        return Icons.restaurant_rounded;
      case 1:
        return Icons.outdoor_grill_rounded;
      case 2:
        return Icons.cake_rounded;
      case 3:
      default:
        return Icons.local_dining_rounded;
    }
  }
}

class _PopularRow extends StatelessWidget {
  const _PopularRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: kPopularRecipes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _RecipeCard(r: kPopularRecipes[i]),
      ),
    );
  }
}

const kPopularRecipes = <_Recipe>[
  _Recipe('Tavuklu Pesto Makarna', '4.8', 152,
      [Color(0xFFFFEDD5), Color(0xFFFB923C)],
      Icons.ramen_dining_rounded,
      'assets/images/meals/grilled_chicken.jpg'),
  _Recipe('Yulaflı Muz Pankek', '4.9', 213,
      [Color(0xFFFCE7F3), Color(0xFFFF6FB1)],
      Icons.cake_rounded,
      'assets/images/meals/blueberry_cheesecake.jpg'),
  _Recipe('Fit Çikolatalı Mousse', '4.7', 98,
      [Color(0xFF1F1815), Color(0xFF6B3A1C)],
      Icons.icecream_rounded,
      'assets/images/meals/chocolate_mousse.jpg'),
  _Recipe('Avokadolu Tost', '4.6', 87,
      [Color(0xFFDCFCE7), Color(0xFF22C55E)],
      Icons.lunch_dining_rounded,
      'assets/images/meals/avocado_toast.jpg'),
  _Recipe('Proteinli Smoothie Bowl', '4.9', 175,
      [Color(0xFFFCE7F3), Color(0xFFE91E63)],
      Icons.icecream_rounded,
      'assets/images/meals/smoothie_bowl.jpg'),
];

class _Recipe {
  const _Recipe(this.title, this.rating, this.reviews, this.gradient,
      this.icon, this.image);
  final String title;
  final String rating;
  final int reviews;
  final List<Color> gradient;
  final IconData icon;
  final String image;
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.r});
  final _Recipe r;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 170,
      child: FitmamaCard(
        padding: EdgeInsets.zero,
        onTap: () => GoRouter.of(context).push(
          '/nutrition/recipe?title=${Uri.encodeComponent(r.title)}',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17)),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Image.asset(r.image, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    child: const Icon(Icons.favorite_border_rounded,
                        color: AppPalette.primary, size: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppPalette.accentYellow, size: 14),
                      const SizedBox(width: 4),
                      Text(r.rating,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '(${r.reviews})',
                        style: TextStyle(
                            fontSize: 11.5,
                            color: scheme.onSurfaceVariant),
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

class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final days = const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(days.length, (i) {
          final isSelected = i == selected;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == days.length - 1 ? 0 : 4),
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
                    days[i],
                    style: TextStyle(
                      color: isSelected ? Colors.white : scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
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

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.label,
    required this.title,
    required this.kcal,
    required this.icon,
    required this.image,
  });
  final String label;
  final String title;
  final int kcal;
  final IconData icon;
  final String image;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: const EdgeInsets.all(8),
      onTap: () => GoRouter.of(context).push(
          '/nutrition/recipe?title=${Uri.encodeComponent(title)}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5,
                  letterSpacing: 0.3)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 10.5, height: 1.15),
          ),
          const SizedBox(height: 2),
          Text('$kcal kcal',
              style: TextStyle(fontSize: 9.5, color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SmallActionCard extends StatelessWidget {
  const _SmallActionCard({
    required this.title,
    required this.sub,
    required this.icon,
    required this.iconColor,
    required this.trailingIcon,
    this.onTap,
  });
  final String title;
  final String sub;
  final IconData icon;
  final Color iconColor;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap ?? () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.18),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 4),
          Text(sub,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                  height: 1.3)),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.primary,
              ),
              child: Icon(trailingIcon, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutrientPills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final items = [
      _Nutrient('Kalori', '320', 'kcal', AppPalette.accentOrange,
          Icons.local_fire_department_rounded),
      _Nutrient(t.statsProtein, '28', 'g', AppPalette.accentYellow,
          Icons.egg_alt_rounded),
      _Nutrient(t.statsCarb, '32', 'g', AppPalette.accentGreen,
          Icons.grain_rounded),
      _Nutrient(t.statsFat, '12', 'g', AppPalette.accentBlue,
          Icons.opacity_rounded),
      _Nutrient(
          'Lif', '6', 'g', AppPalette.accentPurple, Icons.eco_rounded),
    ];
    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final n = items[i];
          return SizedBox(
            width: 96,
            child: FitmamaCard(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: n.color.withValues(alpha: 0.2),
                    ),
                    child: Icon(n.icon, color: n.color, size: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    n.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: n.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        TextSpan(
                          text: ' ${n.unit}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                  ),
                        ),
                      ],
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

class _Nutrient {
  const _Nutrient(this.label, this.value, this.unit, this.color, this.icon);
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Favorite(
          'Yoğurtlu Yulaf Kasesi',
          [Color(0xFFFFEDD5), Color(0xFFEC4899)],
          Icons.breakfast_dining_rounded,
          'assets/images/meals/overnight_oats.jpg'),
      _Favorite(
          'Proteinli Smoothie',
          [Color(0xFFFCE7F3), Color(0xFFE91E63)],
          Icons.local_drink_rounded,
          'assets/images/meals/strawberry_smoothie.jpg'),
      _Favorite(
          'Fırında Sebzeler',
          [Color(0xFFFFEDD5), Color(0xFFFB923C)],
          Icons.spa_rounded,
          'assets/images/meals/chicken_veg.jpg'),
      _Favorite(
          'Avokadolu Tost',
          [Color(0xFFDCFCE7), Color(0xFF22C55E)],
          Icons.lunch_dining_rounded,
          'assets/images/meals/avocado_toast.jpg'),
    ];
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final f = items[i];
          return SizedBox(
            width: 130,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => GoRouter.of(context).push(
                  '/nutrition/recipe?title=${Uri.encodeComponent(f.name)}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset(f.image, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                            child: const Icon(Icons.favorite_rounded,
                                color: AppPalette.primary, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(f.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Favorite {
  const _Favorite(this.name, this.gradient, this.icon, this.image);
  final String name;
  final List<Color> gradient;
  final IconData icon;
  final String image;
}
