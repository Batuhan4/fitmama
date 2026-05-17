import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(
              'Topluluğa katıl, gün gün ilerle, rozet kazan.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _FeaturedChallengeCard(),
          ),
          const SizedBox(height: 24),
          SectionHeader(title: 'Aktif challenge\'larım', upper: true),
          ..._myChallenges.map((c) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 6),
                child: _MyChallengeCard(c: c),
              )),
          const SizedBox(height: 24),
          SectionHeader(title: 'Keşfet', upper: true),
          ..._discoverChallenges.map((c) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 6),
                child: _DiscoverChallengeCard(c: c),
              )),
          const SizedBox(height: 24),
          SectionHeader(title: 'Liderlik tablosu', upper: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _LeaderboardCard(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FeaturedChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: const LinearGradient(
                colors: [
                  AppPalette.primary,
                  Color(0xFF6D28D9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(Icons.emoji_events_rounded,
                  color: Colors.white, size: 100),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'BU AYIN CHALLENGE\'I',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '21 Gün Core Recovery',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Postpartum karın bölgesini yeniden güçlendir.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _BadgeChip(
                        icon: Icons.people_rounded, label: '2.4K katılımcı'),
                    const SizedBox(width: 8),
                    _BadgeChip(
                        icon: Icons.calendar_today_rounded,
                        label: '21 gün'),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppPalette.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text('Katıl'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MyChallengeItem {
  const _MyChallengeItem(
      this.name, this.day, this.totalDays, this.color, this.icon);
  final String name;
  final int day;
  final int totalDays;
  final Color color;
  final IconData icon;
}

const _myChallenges = <_MyChallengeItem>[
  _MyChallengeItem('21 Gün Core Recovery', 9, 21, AppPalette.primary,
      Icons.local_fire_department_rounded),
  _MyChallengeItem('Günlük 10K Adım', 14, 30, AppPalette.accentGreen,
      Icons.directions_walk_rounded),
];

class _MyChallengeCard extends StatelessWidget {
  const _MyChallengeCard({required this.c});
  final _MyChallengeItem c;

  @override
  Widget build(BuildContext context) {
    final progress = c.day / c.totalDays;
    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: c.color.withValues(alpha: 0.15),
            ),
            child: Icon(c.icon, color: c.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Gün ${c.day} / ${c.totalDays}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: c.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: c.color,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '%${(progress * 100).round()}',
            style: TextStyle(
                color: c.color, fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _DiscoverItem {
  const _DiscoverItem(this.name, this.subtitle, this.participants, this.icon,
      this.gradient);
  final String name;
  final String subtitle;
  final int participants;
  final IconData icon;
  final List<Color> gradient;
}

const _discoverChallenges = <_DiscoverItem>[
  _DiscoverItem(
      '7 Gün Su Hedefi',
      'Günde 2.5 L su iç',
      1820,
      Icons.water_drop_rounded,
      [Color(0xFF60A5FA), Color(0xFF1E40AF)]),
  _DiscoverItem(
      '30 Gün Pelvik Sağlık',
      'Günde 10 dk pelvik egzersizler',
      980,
      Icons.spa_rounded,
      [Color(0xFFC4B5FD), Color(0xFF6D28D9)]),
  _DiscoverItem(
      'Şekersiz Hafta',
      'İlave şeker yemeden 7 gün',
      540,
      Icons.no_food_rounded,
      [Color(0xFFFB923C), Color(0xFFDC2626)]),
];

class _DiscoverChallengeCard extends StatelessWidget {
  const _DiscoverChallengeCard({required this.c});
  final _DiscoverItem c;

  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(12),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: c.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(c.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                Text(c.subtitle,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.people_rounded,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('${c.participants} katılımcı',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 36),
              textStyle: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
            child: const Text('Katıl'),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = const [
      _LbItem(1, 'Defne S.', 12480, AppPalette.accentYellow),
      _LbItem(2, 'Sena K.', 11920, Color(0xFFA0A0A0)),
      _LbItem(3, 'Elif D.', 11340, Color(0xFFCD7F32)),
      _LbItem(8, 'Sen', 7820, AppPalette.primary),
    ];
    return FitmamaCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _LbRow(item: items[i], highlight: items[i].name == 'Sen'),
            if (i < items.length - 1)
              Divider(
                  height: 18,
                  color: Theme.of(context).colorScheme.outline),
          ],
        ],
      ),
    );
  }
}

class _LbItem {
  const _LbItem(this.rank, this.name, this.xp, this.medal);
  final int rank;
  final String name;
  final int xp;
  final Color medal;
}

class _LbRow extends StatelessWidget {
  const _LbRow({required this.item, this.highlight = false});
  final _LbItem item;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.medal.withValues(alpha: highlight ? 0.3 : 0.18),
          ),
          alignment: Alignment.center,
          child: Text(
            '${item.rank}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: item.medal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.name,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              fontSize: 14,
              color: highlight ? AppPalette.primary : null,
            ),
          ),
        ),
        Text(
          '${item.xp} XP',
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ],
    );
  }
}
