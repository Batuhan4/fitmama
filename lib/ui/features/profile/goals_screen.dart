import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  double _weightTarget = 65;
  int _weeklyWorkouts = 4;
  double _waterGoalL = 2.5;
  int _sleepHours = 8;
  final Set<String> _focus = {'Core', 'Pelvik Taban'};

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hedeflerim')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          SectionHeader(
            title: 'Kilo hedefi',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          FitmamaCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_weightTarget.toStringAsFixed(1)} kg',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26),
                          ),
                          Text(
                            'Hedef kilo',
                            style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.trending_down_rounded,
                        color: AppPalette.primary, size: 32),
                  ],
                ),
                Slider(
                  min: 45,
                  max: 100,
                  divisions: 110,
                  value: _weightTarget,
                  label: '${_weightTarget.toStringAsFixed(1)} kg',
                  onChanged: (v) => setState(() => _weightTarget = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Haftalık antrenman',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          FitmamaCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton.filled(
                  onPressed: () => setState(() {
                    _weeklyWorkouts = (_weeklyWorkouts - 1).clamp(1, 14);
                  }),
                  icon: const Icon(Icons.remove_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        AppPalette.primary.withValues(alpha: 0.15),
                    foregroundColor: AppPalette.primary,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$_weeklyWorkouts',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 36),
                      ),
                      Text(
                        'seans / hafta',
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  onPressed: () => setState(() {
                    _weeklyWorkouts = (_weeklyWorkouts + 1).clamp(1, 14);
                  }),
                  icon: const Icon(Icons.add_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppPalette.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Su & uyku',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FitmamaCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop_rounded,
                              color: AppPalette.accentBlue, size: 18),
                          const SizedBox(width: 6),
                          Text('Su',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${_waterGoalL.toStringAsFixed(1)} L',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22)),
                      Slider(
                        min: 1.5,
                        max: 4.0,
                        divisions: 25,
                        value: _waterGoalL,
                        onChanged: (v) => setState(() => _waterGoalL = v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FitmamaCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bedtime_rounded,
                              color: AppPalette.accentPurple, size: 18),
                          const SizedBox(width: 6),
                          Text('Uyku',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('$_sleepHours sa',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22)),
                      Slider(
                        min: 4,
                        max: 11,
                        divisions: 7,
                        value: _sleepHours.toDouble(),
                        onChanged: (v) =>
                            setState(() => _sleepHours = v.round()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Odak alanları',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 4),
          Text(
            'Odaklanmak istediğin alanları seç. Programlar ve öneriler bu seçimlere göre kişiselleşir.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in const [
                'Core',
                'Glute',
                'Pelvik Taban',
                'Bel İnceltme',
                'Postür',
                'Esneklik',
                'Cardio',
                'Kuvvet',
                'Mobilite',
              ])
                _FocusChip(
                  label: f,
                  selected: _focus.contains(f),
                  onTap: () => setState(() {
                    if (!_focus.add(f)) _focus.remove(f);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class _FocusChip extends StatelessWidget {
  const _FocusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? scheme.primary
              : Theme.of(context).brightness == Brightness.dark
                  ? AppPalette.darkSurfaceRaised
                  : AppPalette.lightSurfaceRaised,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.check_rounded,
                    color: Colors.white, size: 14),
              ),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : scheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
