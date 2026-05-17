import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/profile.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _name = TextEditingController();
  DateTime _birthDate = DateTime.now();
  BirthType _birthType = BirthType.normal;

  final Set<String> _health = {};
  final _healthOther = TextEditingController();
  final Set<String> _allergens = {};
  final _allergenOther = TextEditingController();
  final Set<String> _dislikes = {};
  final _dislikeOther = TextEditingController();
  final Set<String> _feedingStyle = {};
  final _feedingOther = TextEditingController();
  final Set<Goal> _goals = {};

  @override
  void initState() {
    super.initState();
    final existing = widget.repository.profile;
    if (existing != null) {
      _name.text = existing.name;
      _birthDate = DateTime.tryParse(existing.babyBirthDate) ?? DateTime.now();
      _birthType = existing.birthType;
      _health.addAll(existing.healthTags);
      _allergens.addAll(existing.allergens);
      _dislikes.addAll(existing.dislikes);
      _feedingStyle.addAll(existing.feedingStyle);
      _goals.addAll(existing.goals);
      _healthOther.text = existing.healthOther ?? '';
      _allergenOther.text = existing.allergenOther ?? '';
      _dislikeOther.text = existing.dislikeOther ?? '';
      _feedingOther.text = existing.feedingOther ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _healthOther.dispose();
    _allergenOther.dispose();
    _dislikeOther.dispose();
    _feedingOther.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final dateStr = DateFormat('yyyy-MM-dd').format(_birthDate);
    final profile = Profile(
      name: _name.text.trim().isEmpty ? 'Anne' : _name.text.trim(),
      babyBirthDate: dateStr,
      birthType: _birthType,
      healthTags: _health.toList(),
      healthOther: _healthOther.text.trim().isEmpty
          ? null
          : _healthOther.text.trim(),
      allergens: _allergens.toList(),
      allergenOther: _allergenOther.text.trim().isEmpty
          ? null
          : _allergenOther.text.trim(),
      dislikes: _dislikes.toList(),
      dislikeOther: _dislikeOther.text.trim().isEmpty
          ? null
          : _dislikeOther.text.trim(),
      feedingStyle: _feedingStyle.toList(),
      feedingOther: _feedingOther.text.trim().isEmpty
          ? null
          : _feedingOther.text.trim(),
      goals: _goals.toList(),
      createdAt:
          widget.repository.profile?.createdAt ?? DateTime.now().toIso8601String(),
    );
    await widget.repository.saveProfile(profile);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(t.onbSaved)));
    context.go('/dashboard');
  }

  Future<void> _pickDate() async {
    final res = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (res != null) setState(() => _birthDate = res);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final steps = <Widget>[
      _stepZero(t),
      _stepOne(t),
      _stepTwo(t),
      _stepThree(t),
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: List.generate(4, (i) {
                      final active = i <= _step;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: active
                                ? scheme.primary
                                : scheme.outline.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),
                  Expanded(child: SingleChildScrollView(child: steps[_step])),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_step > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _step -= 1),
                            child: Text(t.onbBack),
                          ),
                        ),
                      if (_step > 0) const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _step < 3
                              ? () => setState(() => _step += 1)
                              : _finish,
                          child: Text(
                            _step == 0
                                ? t.onbStart
                                : _step < 3
                                    ? t.onbNext
                                    : t.onbFinish,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepZero(AppLocalizations t) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(Icons.favorite_rounded,
                color: scheme.onPrimary, size: 44),
          ),
        ),
        const SizedBox(height: 20),
        Text(t.onbWelcomeTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(t.onbWelcomeSub,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 28),
        Text(t.onbName, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        TextField(
          controller: _name,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: t.onbNamePh,
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _stepOne(AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.onbBirthDate,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_today_rounded, size: 16),
          label: Text(DateFormat.yMMMMd().format(_birthDate)),
        ),
        const SizedBox(height: 28),
        Text(t.onbBirthType, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _typeButton(BirthType.normal, t.onbNormal),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _typeButton(BirthType.csection, t.onbCsection),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typeButton(BirthType type, String label) {
    final scheme = Theme.of(context).colorScheme;
    final active = _birthType == type;
    return InkWell(
      onTap: () => setState(() => _birthType = type),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? scheme.primary
                : scheme.outline.withValues(alpha: 0.6),
            width: active ? 2 : 1,
          ),
          color: active
              ? scheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: active ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _stepTwo(AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.onbPreferences,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(t.onbPreferencesSub,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
        const SizedBox(height: 20),
        _chipBlock(
          title: t.onbHealthLabel,
          options: [
            _Opt('bp', t.onbHBp),
            _Opt('diabetes', t.onbHDiabetes),
            _Opt('thyroid', t.onbHThyroid),
            _Opt('anemia', t.onbHAnemia),
            _Opt('ppd', t.onbHPpd),
            _Opt('backpain', t.onbHBack),
            _Opt('incision', t.onbHIncision),
            _Opt('other', t.onbOther),
          ],
          values: _health,
          other: _healthOther,
          otherPh: t.onbOtherPh,
        ),
        const SizedBox(height: 16),
        _chipBlock(
          title: t.onbAllergenLabel,
          options: [
            _Opt('milk', t.onbAMilk),
            _Opt('egg', t.onbAEgg),
            _Opt('nuts', t.onbANuts),
            _Opt('gluten', t.onbAGluten),
            _Opt('seafood', t.onbASeafood),
            _Opt('soy', t.onbASoy),
            _Opt('other', t.onbOther),
          ],
          values: _allergens,
          other: _allergenOther,
          otherPh: t.onbOtherPh,
        ),
        const SizedBox(height: 16),
        _chipBlock(
          title: t.onbDislikeLabel,
          options: [
            _Opt('red_meat', t.onbDMeat),
            _Opt('fish', t.onbDFish),
            _Opt('veg', t.onbDVeg),
            _Opt('spicy', t.onbDSpicy),
            _Opt('dairy', t.onbDDairy),
            _Opt('legumes', t.onbDLegumes),
            _Opt('other', t.onbOther),
          ],
          values: _dislikes,
          other: _dislikeOther,
          otherPh: t.onbOtherPh,
        ),
        const SizedBox(height: 16),
        _chipBlock(
          title: t.onbFeedingLabel,
          options: [
            _Opt('breast', t.onbFBreast),
            _Opt('bottle', t.onbFBottle),
            _Opt('mixed', t.onbFMixed),
            _Opt('pumping', t.onbFPump),
            _Opt('other', t.onbOther),
          ],
          values: _feedingStyle,
          other: _feedingOther,
          otherPh: t.onbOtherPh,
        ),
      ],
    );
  }

  Widget _chipBlock({
    required String title,
    required List<_Opt> options,
    required Set<String> values,
    required TextEditingController other,
    required String otherPh,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final showOther = values.contains('other');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final active = values.contains(opt.id);
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => setState(() {
                if (active) {
                  values.remove(opt.id);
                } else {
                  values.add(opt.id);
                }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? scheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: active ? scheme.primary : scheme.outline,
                  ),
                ),
                child: Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (showOther) ...[
          const SizedBox(height: 8),
          TextField(
            controller: other,
            decoration: InputDecoration(hintText: otherPh),
            maxLength: 120,
          ),
        ],
      ],
    );
  }

  Widget _stepThree(AppLocalizations t) {
    final goalOptions = <_GoalOpt>[
      _GoalOpt(Goal.sleep, t.onbGoalSleep, Icons.nightlight_round),
      _GoalOpt(Goal.weight, t.onbGoalWeight, Icons.monitor_weight_outlined),
      _GoalOpt(Goal.move, t.onbGoalMove, Icons.fitness_center_rounded),
      _GoalOpt(Goal.mood, t.onbGoalMood, Icons.sentiment_satisfied_rounded),
      _GoalOpt(Goal.feed, t.onbGoalFeed, Icons.child_friendly_rounded),
    ];
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.onbGoals, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...goalOptions.map((opt) {
          final active = _goals.contains(opt.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() {
                if (active) {
                  _goals.remove(opt.id);
                } else {
                  _goals.add(opt.id);
                }
              }),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active
                        ? scheme.primary
                        : scheme.outline.withValues(alpha: 0.5),
                    width: active ? 2 : 1,
                  ),
                  color: active
                      ? scheme.primary.withValues(alpha: 0.06)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                      ),
                      child: Icon(
                        opt.icon,
                        color: active
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opt.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _Opt {
  const _Opt(this.id, this.label);
  final String id;
  final String label;
}

class _GoalOpt {
  const _GoalOpt(this.id, this.label, this.icon);
  final Goal id;
  final String label;
  final IconData icon;
}
