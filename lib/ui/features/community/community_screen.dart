import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';
import '../../core/widgets/section_header.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static const _experts = <_Expert>[
    _Expert('Emzirme danışmanı: Doğru tutuş',
        'Bebeğin tüm areolayı kavramalı, çene göğse değmeli.'),
    _Expert('Pediatrist: Uyku güvenliği',
        'Bebek sırtüstü, sert yatakta, oda sıcaklığı 20-22°C.'),
    _Expert('Psikolog: Lohusalık duyguları',
        'İlk 2 hafta hassasiyet normaldir; 2 haftadan uzun sürerse destek al.'),
  ];

  static const _stories = <String>[
    'İlk hafta uykusuz geçti ama 3. haftada bir ritim oturdu — Selin',
    'Pelvik egzersizler 6. haftada gerçekten fark yarattı — Ayşe',
    'Sezaryen sonrası kısa yürüyüşler iyileşmemi hızlandırdı — Merve',
  ];

  static const _lessons = <String>[
    '5 dakikalık postür düzeltme',
    'Emzirme sonrası beslenme',
    'Bebekle güvenli uyku alanı',
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        GradientCard(
          padding: const EdgeInsets.all(16),
          child: Text(
            '✨ ${t.comComingSoon}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),
        SectionHeader(
          icon: Icons.school_outlined,
          title: t.comExperts,
        ),
        const SizedBox(height: 8),
        ..._experts.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MomriseCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(e.body,
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 16),
        SectionHeader(
          icon: Icons.favorite_outline,
          title: t.comStories,
        ),
        const SizedBox(height: 8),
        ..._stories.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MomriseCard(
                padding: const EdgeInsets.all(12),
                child: Text('"$s"',
                    style: const TextStyle(fontSize: 13)),
              ),
            )),
        const SizedBox(height: 16),
        SectionHeader(
          icon: Icons.auto_awesome_outlined,
          title: t.comLessons,
        ),
        const SizedBox(height: 8),
        ..._lessons.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MomriseCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.primaryContainer,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _Expert {
  const _Expert(this.title, this.body);
  final String title;
  final String body;
}
