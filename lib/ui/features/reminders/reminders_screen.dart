import 'package:flutter/material.dart';

import '../../../data/models/reminder_config.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../data/services/notification_service.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  static const _intervals = <int>[30, 60, 90, 120, 180, 240];
  bool _hourlyWater = false;

  String _kindLabel(ReminderKind k, AppLocalizations t) {
    switch (k) {
      case ReminderKind.feeding:
        return t.remFeeding;
      case ReminderKind.water:
        return t.remWater;
      case ReminderKind.sleep:
        return t.remSleep;
      case ReminderKind.exercise:
        return t.remExercise;
      case ReminderKind.mood:
        return t.remMood;
      case ReminderKind.doctor:
        return t.remDoctor;
    }
  }

  Future<void> _toggleHourly(bool value) async {
    final messenger = ScaffoldMessenger.of(context);
    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(content: Text('Bildirim izni reddedildi')),
        );
        return;
      }
      await NotificationService.scheduleHourlyWaterReminder();
    } else {
      await NotificationService.cancelHourlyWaterReminder();
    }
    if (!mounted) return;
    setState(() => _hourlyWater = value);
  }

  Future<void> _testNotification() async {
    final messenger = ScaffoldMessenger.of(context);
    final granted = await NotificationService.requestPermission();
    if (!granted) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Bildirim izni reddedildi')),
      );
      return;
    }
    await NotificationService.showTestNow();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final items = widget.repository.reminders;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        MomriseCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary.withValues(alpha: 0.12),
                    ),
                    child: Icon(Icons.water_drop_rounded,
                        color: scheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saatlik su hatırlatması',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Her saat "bugün suyunu içtin mi?" bildirimi',
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(value: _hourlyWater, onChanged: _toggleHourly),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _testNotification,
                  icon: const Icon(Icons.notifications_active_outlined,
                      size: 16),
                  label: const Text('Test bildirimi'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            'Uygulama içi hatırlatmalar',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.1,
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MomriseCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(_kindLabel(r.kind, t),
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Switch(
                        value: r.enabled,
                        onChanged: (v) =>
                            widget.repository.toggleReminder(r.id, v),
                      ),
                    ],
                  ),
                  if (r.enabled) ...[
                    Text(t.remEvery(r.intervalMin),
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        )),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _intervals.map((m) {
                        final active = r.intervalMin == m;
                        return InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => widget.repository
                              .setReminderInterval(r.id, m),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: active
                                  ? scheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: active
                                    ? scheme.primary
                                    : scheme.outline,
                              ),
                            ),
                            child: Text(
                              '$m dk',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? scheme.onPrimary
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
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
