import 'package:flutter/material.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/momrise_card.dart';

const _glassLabel = L('bardak', 'glass', more: {
  'hi': 'गिलास',
  'pt': 'copo',
  'es': 'vaso',
  'id': 'gelas',
  'ur': 'گلاس',
  'bn': 'গ্লাস',
  'ar': 'كوب',
  'ru': 'стакан',
  'de': 'Glas',
  'fr': 'verre',
  'it': 'bicchiere',
  'ja': 'グラス',
  'ko': '컵',
  'zh': '杯',
  'fil': 'baso',
  'vi': 'cốc',
  'fa': 'لیوان',
  'pl': 'szklanka',
});

/// Each tap on a glass adds [kWaterStepMl] ml. The daily goal is
/// [kWaterGoalMl] ml (≈ 2 L). Internally we store the count in
/// 200 ml units via [AppRepository.setWaterCups].
const int kWaterStepMl = 200;
const int kWaterGoalMl = 2000;
const int kWaterGoalUnits = kWaterGoalMl ~/ kWaterStepMl;

class WaterQuickWidget extends StatelessWidget {
  const WaterQuickWidget({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final today = todayKey();
    final current = repository.waters
            .where((w) => w.date == today)
            .firstOrNull
            ?.cups ??
        0;
    final currentMl = current * kWaterStepMl;
    const sky = Color(0xFF38BDF8);
    final scheme = Theme.of(context).colorScheme;
    return AccentCard(
      color: sky,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_rounded,
                  color: Color(0xFF0284C7), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.waterQuickAdd,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${currentMl}ml / ${kWaterGoalMl}ml',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '+${kWaterStepMl}ml / ${_glassLabel.of(context)}',
            style: TextStyle(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            final w = constraints.maxWidth;
            const spacing = 6.0;
            final size = ((w - spacing * (kWaterGoalUnits - 1)) /
                    kWaterGoalUnits)
                .clamp(20.0, 48.0);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(kWaterGoalUnits, (i) {
                final filled = i < current;
                final next = filled ? current - 1 : current + 1;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => repository.setWaterCups(today, i + 1),
                  onLongPress: () => repository.setWaterCups(today, next),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: filled
                          ? sky
                          : sky.withValues(alpha: 0.18),
                      border: Border.all(
                        color: filled
                            ? sky.withValues(alpha: 0.9)
                            : sky.withValues(alpha: 0.4),
                      ),
                    ),
                    child: filled
                        ? const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                );
              }),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (current / kWaterGoalUnits).clamp(0.0, 1.0),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: '-${kWaterStepMl}ml',
                onPressed: current > 0
                    ? () => repository.setWaterCups(today, current - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              IconButton(
                tooltip: '+${kWaterStepMl}ml',
                onPressed: () =>
                    repository.setWaterCups(today, current + 1),
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
