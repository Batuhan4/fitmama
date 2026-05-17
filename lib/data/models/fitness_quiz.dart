/// User's fitness profile answers collected at first app launch.
/// All fields use stable string slugs so they can be persisted + matched
/// in program recommendations.
class FitnessQuiz {
  const FitnessQuiz({
    this.primaryGoal,
    this.phase,
    this.focusAreas = const <String>{},
    this.weeklyDays,
    this.location,
    this.completed = false,
  });

  final String? primaryGoal;
  final String? phase;
  final Set<String> focusAreas;
  final String? weeklyDays;
  final String? location;
  final bool completed;

  FitnessQuiz copyWith({
    String? primaryGoal,
    String? phase,
    Set<String>? focusAreas,
    String? weeklyDays,
    String? location,
    bool? completed,
  }) {
    return FitnessQuiz(
      primaryGoal: primaryGoal ?? this.primaryGoal,
      phase: phase ?? this.phase,
      focusAreas: focusAreas ?? this.focusAreas,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      location: location ?? this.location,
      completed: completed ?? this.completed,
    );
  }

  factory FitnessQuiz.fromJson(Map<String, dynamic> json) {
    return FitnessQuiz(
      primaryGoal: json['primaryGoal'] as String?,
      phase: json['phase'] as String?,
      focusAreas: ((json['focusAreas'] as List?) ?? const [])
          .cast<String>()
          .toSet(),
      weeklyDays: json['weeklyDays'] as String?,
      location: json['location'] as String?,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        if (primaryGoal != null) 'primaryGoal': primaryGoal,
        if (phase != null) 'phase': phase,
        'focusAreas': focusAreas.toList(),
        if (weeklyDays != null) 'weeklyDays': weeklyDays,
        if (location != null) 'location': location,
        'completed': completed,
      };
}

/// Canonical option lists — keep slugs stable, labels are human-facing.
class QuizOption {
  const QuizOption({required this.slug, required this.label, required this.icon});
  final String slug;
  final String label;
  final String icon; // emoji
}

const kPrimaryGoalOptions = <QuizOption>[
  QuizOption(slug: 'lose_weight', label: 'Zayıflama', icon: '🔥'),
  QuizOption(slug: 'tone', label: 'Sıkılaşma & form', icon: '💪'),
  QuizOption(slug: 'recovery', label: 'Doğum sonrası toparlanma', icon: '🌸'),
  QuizOption(slug: 'ease_delivery', label: 'Doğumu kolaylaştırma', icon: '🤰'),
  QuizOption(slug: 'general_fitness', label: 'Genel fitness', icon: '✨'),
];

const kPhaseOptions = <QuizOption>[
  QuizOption(slug: 'pregnant', label: 'Hamilelik dönemi', icon: '🤰'),
  QuizOption(slug: 'postpartum_0_3', label: 'Postpartum 0-3 ay', icon: '👶'),
  QuizOption(slug: 'postpartum_3_6', label: 'Postpartum 3-6 ay', icon: '🍼'),
  QuizOption(slug: 'postpartum_6_plus', label: 'Postpartum 6 ay+', icon: '🎈'),
];

const kFocusAreaOptions = <QuizOption>[
  QuizOption(slug: 'core', label: 'Core & karın', icon: '🎯'),
  QuizOption(slug: 'glute', label: 'Glute & kalça', icon: '🍑'),
  QuizOption(slug: 'pelvic', label: 'Pelvik taban', icon: '🌷'),
  QuizOption(slug: 'waist', label: 'Bel inceltme', icon: '⏳'),
  QuizOption(slug: 'full_body', label: 'Tüm vücut', icon: '🌟'),
  QuizOption(slug: 'back_posture', label: 'Sırt & postür', icon: '🧘'),
];

const kWeeklyDaysOptions = <QuizOption>[
  QuizOption(slug: '1_2', label: 'Haftada 1-2 gün', icon: '🐢'),
  QuizOption(slug: '3_4', label: 'Haftada 3-4 gün', icon: '🚀'),
  QuizOption(slug: '5_plus', label: 'Haftada 5+ gün', icon: '🔥'),
];

const kLocationOptions = <QuizOption>[
  QuizOption(slug: 'home', label: 'Evde', icon: '🏠'),
  QuizOption(slug: 'gym', label: 'Salonda', icon: '🏋️'),
  QuizOption(slug: 'outdoor', label: 'Dışarıda', icon: '🌳'),
];
