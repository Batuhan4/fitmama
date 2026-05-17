import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/fitness_quiz.dart';
import '../../../data/repositories/app_repository.dart';
import '../../core/theme/app_theme.dart';

class FitnessQuizScreen extends StatefulWidget {
  const FitnessQuizScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<FitnessQuizScreen> createState() => _FitnessQuizScreenState();
}

class _FitnessQuizScreenState extends State<FitnessQuizScreen> {
  late final PageController _ctrl = PageController();
  int _page = 0;
  FitnessQuiz _draft = const FitnessQuiz();

  static const _totalSteps = 5;

  @override
  void initState() {
    super.initState();
    final existing = widget.repository.fitnessQuiz;
    if (existing != null) _draft = existing;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return _draft.primaryGoal != null;
      case 1:
        return _draft.phase != null;
      case 2:
        return _draft.focusAreas.isNotEmpty;
      case 3:
        return _draft.weeklyDays != null;
      case 4:
        return _draft.location != null;
    }
    return false;
  }

  void _next() async {
    if (!_isStepValid(_page)) return;
    if (_page == _totalSteps - 1) {
      await widget.repository.saveFitnessQuiz(_draft.copyWith(completed: true));
      if (!mounted) return;
      context.go('/onboarding');
      return;
    }
    _ctrl.nextPage(
        duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  void _back() {
    if (_page == 0) {
      context.pop();
      return;
    }
    _ctrl.previousPage(
        duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_page + 1) / _totalSteps;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: _back,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor:
                            AppPalette.primary.withValues(alpha: 0.16),
                        valueColor: const AlwaysStoppedAnimation(
                            AppPalette.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_page + 1}/$_totalSteps',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: PageView(
                  controller: _ctrl,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    _QuestionPage(
                      title: 'İlk hedefin nedir?',
                      subtitle: 'Sana en uygun planı kurmamız için.',
                      options: kPrimaryGoalOptions,
                      multi: false,
                      selected: _draft.primaryGoal == null
                          ? const <String>{}
                          : {_draft.primaryGoal!},
                      onChanged: (sel) => setState(() {
                        _draft = _draft.copyWith(
                            primaryGoal: sel.isEmpty ? null : sel.first);
                      }),
                    ),
                    _QuestionPage(
                      title: 'Şu an hangi dönemdesin?',
                      subtitle: 'Programları doğru zorlukta sunalım.',
                      options: kPhaseOptions,
                      multi: false,
                      selected: _draft.phase == null
                          ? const <String>{}
                          : {_draft.phase!},
                      onChanged: (sel) => setState(() {
                        _draft = _draft.copyWith(
                            phase: sel.isEmpty ? null : sel.first);
                      }),
                    ),
                    _QuestionPage(
                      title: 'Hangi alanlara odaklanalım?',
                      subtitle: 'Birden fazla seçebilirsin.',
                      options: kFocusAreaOptions,
                      multi: true,
                      selected: _draft.focusAreas,
                      onChanged: (sel) => setState(() {
                        _draft = _draft.copyWith(focusAreas: sel);
                      }),
                    ),
                    _QuestionPage(
                      title: 'Haftada kaç gün antrenman?',
                      subtitle: 'Yapabileceğin kadarı seç, dilediğinde değişir.',
                      options: kWeeklyDaysOptions,
                      multi: false,
                      selected: _draft.weeklyDays == null
                          ? const <String>{}
                          : {_draft.weeklyDays!},
                      onChanged: (sel) => setState(() {
                        _draft = _draft.copyWith(
                            weeklyDays: sel.isEmpty ? null : sel.first);
                      }),
                    ),
                    _QuestionPage(
                      title: 'Antrenmanlarını nerede yapıyorsun?',
                      subtitle: 'Sana uygun programları öne çıkaralım.',
                      options: kLocationOptions,
                      multi: false,
                      selected: _draft.location == null
                          ? const <String>{}
                          : {_draft.location!},
                      onChanged: (sel) => setState(() {
                        _draft = _draft.copyWith(
                            location: sel.isEmpty ? null : sel.first);
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _isStepValid(_page) ? _next : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
                child: Text(
                  _page == _totalSteps - 1 ? 'Bitir' : 'Devam',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.multi,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final List<QuizOption> options;
  final bool multi;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  void _toggle(String slug) {
    if (multi) {
      final next = Set<String>.from(selected);
      if (!next.add(slug)) next.remove(slug);
      onChanged(next);
    } else {
      onChanged({slug});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final opt = options[i];
              final isSelected = selected.contains(opt.slug);
              return _QuizOptionTile(
                option: opt,
                multi: multi,
                isSelected: isSelected,
                onTap: () => _toggle(opt.slug),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuizOptionTile extends StatelessWidget {
  const _QuizOptionTile({
    required this.option,
    required this.multi,
    required this.isSelected,
    required this.onTap,
  });
  final QuizOption option;
  final bool multi;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? AppPalette.primary.withValues(alpha: 0.10)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          border: Border.all(
            color: isSelected
                ? AppPalette.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(option.icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: multi ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: multi ? BorderRadius.circular(7) : null,
                color: isSelected
                    ? AppPalette.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppPalette.primary
                      : scheme.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
