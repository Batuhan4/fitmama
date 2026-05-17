import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final items = <_MoreItem>[
      _MoreItem('/sleep', Icons.nightlight_round, t.navSleep),
      _MoreItem('/nutrition', Icons.restaurant_rounded, t.navNutrition),
      _MoreItem('/breathing', Icons.air_rounded, t.breathTitle),
      _MoreItem('/reminders', Icons.notifications_outlined, t.navReminders),
      _MoreItem('/recovery', Icons.timeline_rounded, t.recoveryTitle),
      _MoreItem('/community', Icons.people_alt_outlined, t.navCommunity),
      _MoreItem('/settings', Icons.settings_outlined, t.navSettings),
    ];
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        ...items.map(
          (it) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MomriseCard(
              padding: const EdgeInsets.all(14),
              onTap: () => context.push(it.to),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary.withValues(alpha: 0.12),
                    ),
                    child: Icon(it.icon, color: scheme.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(it.label,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: scheme.onSurfaceVariant, size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _MoreItem {
  const _MoreItem(this.to, this.icon, this.label);
  final String to;
  final IconData icon;
  final String label;
}
