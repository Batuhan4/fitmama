import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog yazıları')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: kBlogPosts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final p = kBlogPosts[i];
          return _BlogCard(post: p, onTap: () {
            GoRouter.of(context)
                .push('/nutrition/blog/${Uri.encodeComponent(p.slug)}');
          });
        },
      ),
    );
  }
}

class BlogPostScreen extends StatelessWidget {
  const BlogPostScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final post = kBlogPosts.firstWhere(
      (p) => p.slug == slug,
      orElse: () => kBlogPosts.first,
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.black.withValues(alpha: 0.35),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: post.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(post.icon,
                      size: 92,
                      color: Colors.white.withValues(alpha: 0.85)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            sliver: SliverList.list(children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppPalette.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(post.tag,
                        style: const TextStyle(
                            color: AppPalette.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11)),
                  ),
                  const SizedBox(width: 8),
                  Text('${post.minutes} dk okuma · ${post.author}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 12),
              Text(post.title,
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 14),
              for (final para in post.body) ...[
                Text(para,
                    style: const TextStyle(fontSize: 14.5, height: 1.55)),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 8),
              FitmamaCard(
                padding: const EdgeInsets.all(16),
                gradient: LinearGradient(
                  colors: [
                    AppPalette.primary.withValues(alpha: 0.15),
                    AppPalette.accentPurple.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates_rounded,
                        color: AppPalette.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(post.takeaway,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post, required this.onTap});
  final BlogPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FitmamaCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(17)),
              gradient: LinearGradient(
                colors: post.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(post.icon,
                color: Colors.white.withValues(alpha: 0.85), size: 38),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(post.tag,
                      style: const TextStyle(
                          color: AppPalette.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.5,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.2)),
                  const SizedBox(height: 4),
                  Text(
                    '${post.minutes} dk · ${post.author}',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlogPost {
  const BlogPost({
    required this.slug,
    required this.title,
    required this.tag,
    required this.minutes,
    required this.author,
    required this.icon,
    required this.gradient,
    required this.body,
    required this.takeaway,
  });
  final String slug;
  final String title;
  final String tag;
  final int minutes;
  final String author;
  final IconData icon;
  final List<Color> gradient;
  final List<String> body;
  final String takeaway;
}

const kBlogPosts = <BlogPost>[
  BlogPost(
    slug: 'pelvik-taban',
    title: 'Doğum sonrası pelvik taban: yeni başlayan için rehber',
    tag: 'PELVİK SAĞLIK',
    minutes: 5,
    author: 'Dr. Aslı Demir, Kadın Doğum',
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFC4B5FD), Color(0xFF6D28D9)],
    body: [
      'Postpartum dönemde pelvik taban kaslarının iyileşmesi sadece idrar kaçırma değil, doğru postür ve dayanıklılık için de kritiktir.',
      'İlk 6 haftada bedenle çalışmaya yumuşak farkındalık egzersizleriyle başlanır: nefes ile birlikte hafif kasma–bırakma. Kendini zorlamak yerine günlük 5 dakika tutarlı tekrar etmek çok daha etkilidir.',
      'Sezaryen sonrası egzersizlerde mutlaka doktor onayı al; iyileşme süresi normal doğumdan farklı seyreder.',
    ],
    takeaway:
        'Pelvik taban için en güçlü iki kelime: tutarlılık ve nefes. Günde 5 dk yeterli.',
  ),
  BlogPost(
    slug: 'emzirme-ve-beslenme',
    title: 'Emzirme döneminde proteini doğru almak',
    tag: 'BESLENME',
    minutes: 6,
    author: 'Dyt. Selin Kaya',
    icon: Icons.restaurant_rounded,
    gradient: [Color(0xFFFFEDD5), Color(0xFFFB923C)],
    body: [
      'Emzirme döneminde günlük ortalama 500 kcal ekstra ihtiyacı var; bunun büyük bir kısmı kaliteli protein ile karşılanmalı.',
      'Yumurta, yoğurt, mercimek, balık ve tavuk gibi tam protein kaynaklarını her öğüne yaymak süt üretimini destekler, kan şekerini stabilize eder.',
      'Hızlı atıştırmalıklar için humus + havuç, fıstık ezmeli muz ya da Yunan yoğurdu+ ceviz harika kombinler.',
    ],
    takeaway: 'Her öğünde bir protein kaynağı + bir lif → enerji stabil kalır.',
  ),
  BlogPost(
    slug: 'core-recovery',
    title: 'Diastasis recti: hangi hareketlerden uzak durmalı?',
    tag: 'RECOVERY',
    minutes: 7,
    author: 'Fzt. Ece Yılmaz',
    icon: Icons.healing_rounded,
    gradient: [Color(0xFFFCE7F3), Color(0xFFEC4899)],
    body: [
      'Gebelikte karın kaslarının ortasındaki bağ dokusu (linea alba) ayrılır. Bu duruma diastasis recti denir ve postpartum dönemde %60 oranında görülür.',
      'İlk haftalarda sit-up, plank, crunch gibi öne eğici klasik karın hareketleri ayrılığı artırır. Yerine dead bug, glute bridge ve transvers nefes önerilir.',
      '8-12. haftada uzman gözetiminde kontrol şart; iyileşme bireysel olarak değişir.',
    ],
    takeaway:
        'Crunch yerine transvers nefes. Karnını içeri çekme tekniğiyle başla.',
  ),
  BlogPost(
    slug: 'mental-saglik',
    title: 'Postpartum mood: ne zaman uzman desteği almalı?',
    tag: 'MENTAL SAĞLIK',
    minutes: 4,
    author: 'Psk. Burcu Tunç',
    icon: Icons.psychology_rounded,
    gradient: [Color(0xFFFFD3A5), Color(0xFFFF9A8B)],
    body: [
      'İlk iki hafta "baby blues" denilen hassas dönemde mood dalgalanmaları normaldir. Hormonal değişim ve uykusuzluk birlikte etkili olur.',
      'Eğer üzüntü, anhedoni veya çocuğuna karşı yabancılaşma 2 haftadan uzun sürerse postpartum depresyon ihtimali değerlendirilmelidir.',
      'Erken müdahale hem anne hem bebek için kritik. Yardım istemek zayıflık değil, sorumluluktur.',
    ],
    takeaway: 'İki haftadan uzun süren mood düşüklüğünde mutlaka destek al.',
  ),
  BlogPost(
    slug: 'uyku',
    title: 'Anne uykusu: kalitesini katlayan 5 micro habit',
    tag: 'UYKU',
    minutes: 4,
    author: 'FitMama editör',
    icon: Icons.bedtime_rounded,
    gradient: [Color(0xFF60A5FA), Color(0xFF1E40AF)],
    body: [
      'Postpartum dönemde uyku süresi kısalır ama kalitesi artırılabilir.',
      'Yatak öncesi 20 dk ekran molası, kafeini öğleden sonra kesme, magnezyum açısından zengin atıştırmalık ve karanlık + serin oda kuralları uykunun kalitesini gözle görülür artırır.',
      'Bebek uyuduğunda uyumak için kendini eğit: "10 dk gözünü kapatma" pratiği zamanla derin uykuya geçişi kolaylaştırır.',
    ],
    takeaway:
        'Kalite > süre. Ekran molası + serin oda + magnezyum → katlayıcı etki.',
  ),
];
