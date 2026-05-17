import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  int _selected = 1; // 0 = aylık, 1 = yıllık (önerilen)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final alreadyPro = widget.repository.pro;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Üyelik'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Center(
            child: Image.asset(
              'assets/branding/fitmama_logo.png',
              height: 60,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Gerçek Kadınlar, Gerçek Değişimler',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Daha güçlü, daha sağlıklı, daha mutlu anneler.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          _TrialBanner(),
          const SizedBox(height: 14),
          _PlanCard(
            isSelected: _selected == 0,
            onTap: () => setState(() => _selected = 0),
            title: 'Aylık Plan',
            price: '249 TL',
            period: ' / ay',
            subtitle: null,
            features: const [
              'Tüm premium özelliklere erişim',
              'Kişisel antrenman & beslenme planı',
              'Gelişim takibi & analiz',
              'Topluluk desteği',
            ],
            cta: 'Aylık Planı Seç',
            popular: false,
          ),
          const SizedBox(height: 12),
          _PlanCard(
            isSelected: _selected == 1,
            onTap: () => setState(() => _selected = 1),
            title: 'Yıllık Plan',
            price: '1990 TL',
            period: ' / yıl',
            subtitle: 'Aylık sadece 165 TL',
            savingBadge: 'YILLIK PLANLA 708 TL TASARRUF ET!',
            features: const [
              'Tüm premium özelliklere erişim',
              'Kişisel antrenman & beslenme planı',
              'Gelişim takibi & analiz',
              'Topluluk desteği',
            ],
            cta: 'Yıllık Planı Seç',
            popular: true,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: alreadyPro ? null : () => _confirm(context),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: AppPalette.primary,
            ),
            child: Text(
              alreadyPro
                  ? 'Zaten Premium üyesin'
                  : (_selected == 0
                      ? 'Aylık Planı Başlat'
                      : 'Yıllık Planı Başlat'),
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Aboneliği istediğin zaman iptal edebilirsin. Ödeme sonrası eklenir.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 28),
          const _FeatureStrip(),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final isYearly = _selected == 1;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            isYearly ? 'Yıllık plan aktif edilsin mi?' : 'Aylık plan aktif edilsin mi?'),
        content: Text(isYearly
            ? '1990 TL/yıl — istediğin zaman iptal edebilirsin.'
            : '249 TL/ay — istediğin zaman iptal edebilirsin.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Onayla')),
        ],
      ),
    );
    if (ok == true) {
      await widget.repository.setPro(true);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('🎉 Premium üyelik aktif! Hoş geldin.'),
        ),
      );
    }
  }
}

class _TrialBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [
          AppPalette.primary.withValues(alpha: 0.12),
          AppPalette.accentPurple.withValues(alpha: 0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppPalette.primary.withValues(alpha: 0.18),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.workspace_premium_rounded,
                color: AppPalette.primary, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('7 Gün Ücretsiz Deneme',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 1.1)),
                const SizedBox(height: 4),
                Text(
                  'Tüm premium özellikleri dene, farkı hisset.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.isSelected,
    required this.onTap,
    required this.title,
    required this.price,
    required this.period,
    required this.subtitle,
    required this.features,
    required this.cta,
    required this.popular,
    this.savingBadge,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String title;
  final String price;
  final String period;
  final String? subtitle;
  final List<String> features;
  final String cta;
  final bool popular;
  final String? savingBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          color: isSelected
              ? AppPalette.primary.withValues(alpha: 0.06)
              : scheme.surface,
          border: Border.all(
            color: isSelected
                ? AppPalette.primary
                : scheme.outlineVariant.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                if (popular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppPalette.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'EN POPÜLER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: price,
                    style: const TextStyle(
                      color: AppPalette.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: period,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppPalette.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            for (final f in features) ...[
              _FeatureRow(text: f),
              const SizedBox(height: 8),
            ],
            if (savingBadge != null) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppPalette.accentGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.savings_rounded,
                        color: AppPalette.accentGreen, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        savingBadge!,
                        style: const TextStyle(
                          color: AppPalette.accentGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                backgroundColor:
                    popular ? AppPalette.primary : Colors.transparent,
                foregroundColor: popular ? Colors.white : AppPalette.primary,
                side: popular
                    ? BorderSide.none
                    : const BorderSide(
                        color: AppPalette.primary, width: 1.5),
              ),
              child: Text(cta,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppPalette.primary.withValues(alpha: 0.18),
          ),
          child: const Icon(Icons.check_rounded,
              color: AppPalette.primary, size: 12),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _FeatureStrip extends StatelessWidget {
  const _FeatureStrip();

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Kişisel Antrenman', 'Sana özel programlar',
          Icons.fitness_center_rounded, AppPalette.primary),
      ('Beslenme Planları', 'Lezzetli & sağlıklı tarifler',
          Icons.restaurant_rounded, AppPalette.accentOrange),
      ('Pelvik Sağlık & Recovery', 'Güçlü bir temel',
          Icons.favorite_rounded, AppPalette.accentPurple),
      ('Anne Topluluğu', 'Destek al, ilham ver',
          Icons.diversity_3_rounded, AppPalette.accentBlue),
      ('Gelişim Takibi', 'İlerlemeni gör',
          Icons.bar_chart_rounded, AppPalette.accentGreen),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PREMIUM AYRICALIKLAR',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8)),
        const SizedBox(height: 10),
        for (final item in items) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: item.$4.withValues(alpha: 0.08),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: item.$4.withValues(alpha: 0.18),
                  ),
                  alignment: Alignment.center,
                  child: Icon(item.$3, color: item.$4, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      Text(item.$2,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
