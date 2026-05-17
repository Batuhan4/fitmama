import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Notif('Bugünün workoutu hazır',
          'Core Recovery · 20 dk · ısınma dahil.',
          Icons.fitness_center_rounded, AppPalette.primary, 'şimdi'),
      _Notif('Yeni rozet kazandın 🎉',
          '7 günlük streak — Recovery Hero seviyene devam!',
          Icons.emoji_events_rounded, AppPalette.accentYellow, '2 sa'),
      _Notif('Su tüketimini unutma',
          'Bugün 1.4 L içtin, hedefin 2.5 L.',
          Icons.water_drop_rounded, AppPalette.accentBlue, '5 sa'),
      _Notif('Sena bir post paylaştı',
          '"6. hafta core recovery bitti 💪"',
          Icons.favorite_rounded, AppPalette.accentPurple, 'dün'),
      _Notif('Haftalık özet hazır',
          'Geçen hafta 6 antrenman, 820 kcal yaktın.',
          Icons.insights_rounded, AppPalette.accentGreen, '3 gün'),
      _Notif('Yeni blog: pelvik taban',
          'Dr. Aslı Demir\'in yeni yazısı yayında.',
          Icons.article_rounded, AppPalette.accentOrange, '4 gün'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tümü okundu işaretlendi')),
            ),
            child: const Text('Tümü okundu'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _NotifCard(item: items[i]),
      ),
    );
  }
}

class _Notif {
  const _Notif(
      this.title, this.body, this.icon, this.color, this.timeAgo);
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final String timeAgo;
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item});
  final _Notif item;

  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(14),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.color.withValues(alpha: 0.15),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(item.body,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(item.timeAgo,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
