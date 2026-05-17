import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class AiFoodAnalyzerScreen extends StatefulWidget {
  const AiFoodAnalyzerScreen({super.key});

  @override
  State<AiFoodAnalyzerScreen> createState() => _AiFoodAnalyzerScreenState();
}

class _AiFoodAnalyzerScreenState extends State<AiFoodAnalyzerScreen> {
  bool _analyzing = false;
  _AnalysisResult? _result;

  Future<void> _runAnalysis() async {
    setState(() {
      _analyzing = true;
      _result = null;
    });
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() {
      _analyzing = false;
      _result = const _AnalysisResult(
        dishName: 'Avokadolu yumurta tost',
        confidence: 0.93,
        calories: 420,
        macros: [
          _Macro('Protein', 22, 'g', AppPalette.primary),
          _Macro('Karbonhidrat', 38, 'g', AppPalette.accentPurple),
          _Macro('Yağ', 19, 'g', AppPalette.accentOrange),
          _Macro('Lif', 6, 'g', AppPalette.accentGreen),
        ],
        tags: ['Sağlıklı yağ', 'B12 kaynağı', 'Postpartum-uygun'],
        warnings: ['Yumurta alerjisi varsa kaçın'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI yemek analizi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          FitmamaCard(
            padding: const EdgeInsets.all(18),
            gradient: LinearGradient(
              colors: [
                AppPalette.primary.withValues(alpha: 0.2),
                AppPalette.accentPurple.withValues(alpha: 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.primary,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tabağını analiz et',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16)),
                          Text(
                            'Yemeği fotoğrafla, AI besin değerlerini hesaplasın.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  icon: Icons.photo_camera_rounded,
                  label: 'Kamerayla çek',
                  onTap: _runAnalysis,
                  filled: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  icon: Icons.image_rounded,
                  label: 'Galeriden seç',
                  onTap: _runAnalysis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_analyzing) ...[
            FitmamaCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    'AI besin değerlerini analiz ediyor…',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ] else if (_result != null) ...[
            SectionHeader(title: 'Sonuç', upper: true),
            FitmamaCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              AppPalette.primary.withValues(alpha: 0.4),
                              AppPalette.accentPurple.withValues(alpha: 0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.restaurant_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_result!.dishName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(
                              'Eşleşme: %${(_result!.confidence * 100).round()}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const _KcalBadge(value: 420),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final m in _result!.macros) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(m.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                        Text('${m.value} ${m.unit}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: m.color.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor:
                              (m.value / _macroMax(m.name)).clamp(0.05, 1.0),
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: m.color,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionHeader(title: 'Etiketler', upper: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in _result!.tags)
                    Chip(
                      label: Text(tag),
                      backgroundColor:
                          AppPalette.primary.withValues(alpha: 0.12),
                      side: BorderSide.none,
                      labelStyle: const TextStyle(
                          color: AppPalette.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  for (final w in _result!.warnings)
                    Chip(
                      avatar: Icon(Icons.warning_amber_rounded,
                          size: 16,
                          color: scheme.error),
                      label: Text(w),
                      backgroundColor: scheme.error.withValues(alpha: 0.12),
                      side: BorderSide.none,
                      labelStyle: TextStyle(
                          color: scheme.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.bookmark_rounded),
                    label: const Text('Beslenme günlüğüne ekle'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ],
            ),
          ] else
            _EmptyHint(),
        ],
      ),
    );
  }

  double _macroMax(String name) {
    switch (name) {
      case 'Protein':
        return 50;
      case 'Karbonhidrat':
        return 80;
      case 'Yağ':
        return 40;
      case 'Lif':
        return 30;
      default:
        return 100;
    }
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: filled ? scheme.primary : scheme.surface,
          border: Border.all(
            color: filled ? scheme.primary : scheme.outline,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 28,
                color: filled ? Colors.white : scheme.onSurface),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: filled ? Colors.white : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KcalBadge extends StatelessWidget {
  const _KcalBadge({required this.value});
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppPalette.accentOrange.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppPalette.accentOrange, size: 14),
          const SizedBox(width: 4),
          Text('$value kcal',
              style: const TextStyle(
                  color: AppPalette.accentOrange,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              size: 36, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            'Yemeğinin fotoğrafını çek ya da galeriden seç.\nAI besin değerlerini saniyeler içinde hesaplar.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AnalysisResult {
  const _AnalysisResult({
    required this.dishName,
    required this.confidence,
    required this.calories,
    required this.macros,
    required this.tags,
    required this.warnings,
  });
  final String dishName;
  final double confidence;
  final int calories;
  final List<_Macro> macros;
  final List<String> tags;
  final List<String> warnings;
}

class _Macro {
  const _Macro(this.name, this.value, this.unit, this.color);
  final String name;
  final int value;
  final String unit;
  final Color color;
}
