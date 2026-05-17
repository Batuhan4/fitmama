import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';

class RecipesListScreen extends StatelessWidget {
  const RecipesListScreen({super.key, this.title = 'Tüm tarifler'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Arama yakında')),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: kAllRecipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, i) {
          final r = kAllRecipes[i];
          return FitmamaCard(
            padding: EdgeInsets.zero,
            onTap: () => GoRouter.of(context).push(
                '/nutrition/recipe?title=${Uri.encodeComponent(r.title)}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(17)),
                          child: Image.asset(r.image, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              height: 1.2)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppPalette.accentYellow, size: 13),
                          const SizedBox(width: 2),
                          Text(r.rating,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                          const SizedBox(width: 4),
                          Text('· ${r.minutes} dk',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall),
                        ],
                      ),
                    ],
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

class FavoriteRecipesScreen extends StatelessWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecipesListScreen(title: 'Favori tariflerim');
  }
}

class RecipeMini {
  const RecipeMini({
    required this.title,
    required this.rating,
    required this.minutes,
    required this.gradient,
    required this.icon,
    required this.image,
  });
  final String title;
  final String rating;
  final int minutes;
  final List<Color> gradient;
  final IconData icon;
  final String image;
}

const kAllRecipes = <RecipeMini>[
  RecipeMini(
      title: 'Tavuklu Pesto Makarna',
      rating: '4.8',
      minutes: 25,
      gradient: [Color(0xFFFFEDD5), Color(0xFFFB923C)],
      icon: Icons.ramen_dining_rounded,
      image: 'assets/images/meals/grilled_chicken.jpg'),
  RecipeMini(
      title: 'Yulaflı Muz Pankek',
      rating: '4.9',
      minutes: 20,
      gradient: [Color(0xFFFCE7F3), Color(0xFFFF6FB1)],
      icon: Icons.cake_rounded,
      image: 'assets/images/meals/blueberry_cheesecake.jpg'),
  RecipeMini(
      title: 'Fit Çikolatalı Mousse',
      rating: '4.7',
      minutes: 15,
      gradient: [Color(0xFF1F1815), Color(0xFF6B3A1C)],
      icon: Icons.icecream_rounded,
      image: 'assets/images/meals/chocolate_mousse.jpg'),
  RecipeMini(
      title: 'Avokadolu Tost',
      rating: '4.6',
      minutes: 10,
      gradient: [Color(0xFFDCFCE7), Color(0xFF22C55E)],
      icon: Icons.lunch_dining_rounded,
      image: 'assets/images/meals/avocado_toast.jpg'),
  RecipeMini(
      title: 'Proteinli Smoothie Bowl',
      rating: '4.9',
      minutes: 8,
      gradient: [Color(0xFFFCE7F3), Color(0xFFE91E63)],
      icon: Icons.icecream_rounded,
      image: 'assets/images/meals/smoothie_bowl.jpg'),
  RecipeMini(
      title: 'Yulaf Ezmesi ve Meyveler',
      rating: '4.7',
      minutes: 12,
      gradient: [Color(0xFFFFE4E6), Color(0xFFEC4899)],
      icon: Icons.breakfast_dining_rounded,
      image: 'assets/images/meals/overnight_oats.jpg'),
  RecipeMini(
      title: 'Izgara Tavuk Salata',
      rating: '4.8',
      minutes: 20,
      gradient: [Color(0xFFDCFCE7), Color(0xFF166534)],
      icon: Icons.dinner_dining_rounded,
      image: 'assets/images/meals/chicken_bowl.jpg'),
  RecipeMini(
      title: 'Fırın Sebzeli Somon',
      rating: '4.9',
      minutes: 30,
      gradient: [Color(0xFFFFE4E6), Color(0xFFEC4899)],
      icon: Icons.dinner_dining_rounded,
      image: 'assets/images/meals/salmon_rice.jpg'),
  RecipeMini(
      title: 'Mercimek Çorbası',
      rating: '4.6',
      minutes: 25,
      gradient: [Color(0xFFFFEDD5), Color(0xFFFB923C)],
      icon: Icons.soup_kitchen_rounded,
      image: 'assets/images/meals/beef_stew.jpg'),
  RecipeMini(
      title: 'Chia Puding',
      rating: '4.7',
      minutes: 5,
      gradient: [Color(0xFFC4B5FD), Color(0xFF6D28D9)],
      icon: Icons.icecream_rounded,
      image: 'assets/images/meals/chia_pudding.jpg'),
  RecipeMini(
      title: 'Airfryer Sebze Cipsi',
      rating: '4.5',
      minutes: 15,
      gradient: [Color(0xFFFEF3C7), Color(0xFFF59E0B)],
      icon: Icons.fastfood_rounded,
      image: 'assets/images/meals/chicken_veg.jpg'),
  RecipeMini(
      title: 'Yoğurtlu Yulaf Kasesi',
      rating: '4.8',
      minutes: 7,
      gradient: [Color(0xFFFFEDD5), Color(0xFFEC4899)],
      icon: Icons.breakfast_dining_rounded,
      image: 'assets/images/meals/overnight_oats.jpg'),
];
