import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppPalette.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Paylaş'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text('Topluluk', style: theme.textTheme.displaySmall),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'FitMama topluluğundan motivasyon ve hikayeler.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SectionHeader(title: 'Hikayeler', upper: true),
          _StoryStrip(),
          const SizedBox(height: 20),
          SectionHeader(title: 'Akış', upper: true),
          ..._fakePosts.map((p) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 6),
                child: _PostCard(post: p),
              )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StoryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _StoryUser('Sen', null, true),
      _StoryUser('Sena',
          [const Color(0xFFFF6FB1), const Color(0xFF8E1A4F)], false),
      _StoryUser('Melis',
          [const Color(0xFFFFAFCB), const Color(0xFFB83DA6)], false),
      _StoryUser('Burcu',
          [const Color(0xFFFFD3A5), const Color(0xFFFF9A8B)], false),
      _StoryUser('Elif',
          [const Color(0xFFC4B5FD), const Color(0xFF6D28D9)], false),
      _StoryUser('Defne',
          [const Color(0xFF2BE0C0), const Color(0xFF166534)], false),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _StoryAvatar(item: items[i]),
      ),
    );
  }
}

class _StoryUser {
  const _StoryUser(this.name, this.gradient, this.isMine);
  final String name;
  final List<Color>? gradient;
  final bool isMine;
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.item});
  final _StoryUser item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 68,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppPalette.primary, AppPalette.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surface,
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: item.gradient != null
                      ? LinearGradient(
                          colors: item.gradient!,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: item.gradient == null
                      ? AppPalette.darkSurfaceRaised
                      : null,
                ),
                alignment: Alignment.center,
                child: item.isMine
                    ? const Icon(Icons.add_rounded,
                        color: Colors.white, size: 22)
                    : Text(
                        item.name[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Post {
  const _Post({
    required this.author,
    required this.handle,
    required this.timeAgo,
    required this.text,
    required this.likes,
    required this.comments,
    required this.gradient,
    this.kind = 'workout',
  });
  final String author;
  final String handle;
  final String timeAgo;
  final String text;
  final int likes;
  final int comments;
  final List<Color> gradient;
  final String kind;
}

const _fakePosts = <_Post>[
  _Post(
    author: 'Sena K.',
    handle: '@sena.k',
    timeAgo: '2 sa önce',
    text:
        'Bugün 6. hafta core recovery programını bitirdim 💪 Kendimi her geçen gün daha güçlü hissediyorum, anneler dayanışmaya!',
    likes: 42,
    comments: 8,
    gradient: [Color(0xFFFF6FB1), Color(0xFF8E1A4F)],
  ),
  _Post(
    author: 'Melis A.',
    handle: '@melis.a',
    timeAgo: 'dün',
    text:
        'Pelvic floor egzersizleri ile uyku problemlerimde de iyileşme oldu — uzmanım da onayladı. Bütüncül iyileşmeye inanıyorum 🌸',
    likes: 87,
    comments: 14,
    gradient: [Color(0xFFC4B5FD), Color(0xFF6D28D9)],
  ),
  _Post(
    author: 'Burcu T.',
    handle: '@burcu.t',
    timeAgo: '2 gün önce',
    text:
        'Avokadolu kahvaltı tarifini denedim — bebeğin uyandığı sabahlar bile süper hızlı 🥑',
    likes: 36,
    comments: 5,
    gradient: [Color(0xFF34D399), Color(0xFF166534)],
    kind: 'recipe',
  ),
  _Post(
    author: 'Elif D.',
    handle: '@elif.d',
    timeAgo: '3 gün önce',
    text:
        '21 günlük bel inceltme challenge\'ı tamamladım. Sonuç çok motive edici!',
    likes: 121,
    comments: 22,
    gradient: [Color(0xFFFFD3A5), Color(0xFFFF9A8B)],
  ),
];

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final _Post post;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: post.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    post.author[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      Text(
                        '${post.handle} · ${post.timeAgo}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: post.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                post.kind == 'recipe'
                    ? Icons.restaurant_rounded
                    : Icons.fitness_center_rounded,
                color: Colors.white.withValues(alpha: 0.85),
                size: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Text(post.text, style: const TextStyle(fontSize: 13.5)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
            child: Row(
              children: [
                _PostAction(
                    icon: Icons.favorite_border_rounded,
                    label: '${post.likes}',
                    color: scheme.onSurfaceVariant),
                _PostAction(
                    icon: Icons.mode_comment_outlined,
                    label: '${post.comments}',
                    color: scheme.onSurfaceVariant),
                _PostAction(
                    icon: Icons.share_outlined,
                    label: 'Paylaş',
                    color: scheme.onSurfaceVariant),
                const Spacer(),
                IconButton(
                  iconSize: 20,
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
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

class _PostAction extends StatelessWidget {
  const _PostAction({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(99),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
