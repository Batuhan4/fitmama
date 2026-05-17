import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/mood_entry.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/id.dart';
import '../../core/widgets/fitmama_card.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  MoodKind? _picked;
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    final today = todayKey();
    final existing =
        widget.repository.moods.where((m) => m.date == today).firstOrNull;
    _picked = existing?.mood;
    _note.text = existing?.note ?? '';
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    if (_picked == null) return;
    final today = todayKey();
    final existing =
        widget.repository.moods.where((m) => m.date == today).firstOrNull;
    final entry = MoodEntry(
      id: existing?.id ?? uid(),
      date: today,
      mood: _picked!,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await widget.repository.upsertMood(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.moodSave)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final negative =
        _picked != null && negativeMoods.contains(_picked!);

    final entries = widget.repository.moods;
    final days = lastNDays(14);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        FitmamaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.moodTodayQ,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 14),
              LayoutBuilder(builder: (context, c) {
                final w = c.maxWidth;
                final size = ((w - 4 * 8) / 5).clamp(54.0, 78.0);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: MoodKind.values.map((m) {
                    final active = _picked == m;
                    return GestureDetector(
                      onTap: () => setState(() => _picked = m),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: active
                              ? _moodColor(m).withValues(alpha: 0.7)
                              : scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: active ? scheme.primary : scheme.outline,
                            width: active ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_moodEmoji(m),
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(
                              _moodLabel(m, t),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 16),
              TextField(
                controller: _note,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: t.moodNotePh,
                  counterText: '',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _picked == null ? null : _save,
                child: Text(t.moodSave),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (negative)
          GradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(t.moodSupport,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: scheme.onPrimary,
                              )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(t.moodMotivation,
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => context.push('/breathing'),
                  icon: const Icon(Icons.air_rounded),
                  label: Text(t.moodBreathing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.surface,
                    foregroundColor: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        if (negative) const SizedBox(height: 12),
        FitmamaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.moodHistory,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              LayoutBuilder(builder: (context, c) {
                final size = ((c.maxWidth - 6 * 6) / 7).clamp(20.0, 40.0);
                return Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: days.map((d) {
                    final key = dateKey(d);
                    final m =
                        entries.where((e) => e.date == key).firstOrNull;
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: m == null
                            ? scheme.surfaceContainerHighest
                            : _moodColor(m.mood).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: m == null
                          ? Text('${d.day}',
                              style: TextStyle(
                                fontSize: 10,
                                color: scheme.onSurfaceVariant,
                              ))
                          : Text(_moodEmoji(m.mood),
                              style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  static Color _moodColor(MoodKind m) {
    switch (m) {
      case MoodKind.happy:
        return const Color(0xFFFEF3C7);
      case MoodKind.energetic:
        return const Color(0xFFA7F3D0);
      case MoodKind.tired:
        return const Color(0xFFC7D2FE);
      case MoodKind.stressed:
        return const Color(0xFFFED7AA);
      case MoodKind.anxious:
        return const Color(0xFFFECACA);
    }
  }

  static String _moodEmoji(MoodKind m) {
    switch (m) {
      case MoodKind.happy:
        return '😊';
      case MoodKind.energetic:
        return '⚡';
      case MoodKind.tired:
        return '😴';
      case MoodKind.stressed:
        return '😣';
      case MoodKind.anxious:
        return '😟';
    }
  }

  String _moodLabel(MoodKind m, AppLocalizations t) {
    switch (m) {
      case MoodKind.happy:
        return t.moodHappy;
      case MoodKind.energetic:
        return t.moodEnergetic;
      case MoodKind.tired:
        return t.moodTired;
      case MoodKind.stressed:
        return t.moodStressed;
      case MoodKind.anxious:
        return t.moodAnxious;
    }
  }
}
