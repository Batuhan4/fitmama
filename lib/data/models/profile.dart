enum BirthType { normal, csection }

enum Goal { sleep, weight, move, mood, feed }

BirthType birthTypeFromString(String? s) {
  return BirthType.values.firstWhere(
    (e) => e.name == s,
    orElse: () => BirthType.normal,
  );
}

Goal? goalFromString(String? s) {
  if (s == null) return null;
  for (final g in Goal.values) {
    if (g.name == s) return g;
  }
  return null;
}

class Profile {
  final String name;
  final String babyBirthDate;
  final BirthType birthType;
  final List<String> healthTags;
  final String? healthOther;
  final List<String> allergens;
  final String? allergenOther;
  final List<String> dislikes;
  final String? dislikeOther;
  final List<String> feedingStyle;
  final String? feedingOther;
  final List<Goal> goals;
  final String createdAt;

  const Profile({
    required this.name,
    required this.babyBirthDate,
    required this.birthType,
    this.healthTags = const [],
    this.healthOther,
    this.allergens = const [],
    this.allergenOther,
    this.dislikes = const [],
    this.dislikeOther,
    this.feedingStyle = const [],
    this.feedingOther,
    this.goals = const [],
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String? ?? 'Anne',
      babyBirthDate: json['babyBirthDate'] as String? ??
          DateTime.now().toIso8601String().substring(0, 10),
      birthType: birthTypeFromString(json['birthType'] as String?),
      healthTags:
          (json['healthTags'] as List?)?.cast<String>() ?? const <String>[],
      healthOther: json['healthOther'] as String?,
      allergens:
          (json['allergens'] as List?)?.cast<String>() ?? const <String>[],
      allergenOther: json['allergenOther'] as String?,
      dislikes:
          (json['dislikes'] as List?)?.cast<String>() ?? const <String>[],
      dislikeOther: json['dislikeOther'] as String?,
      feedingStyle:
          (json['feedingStyle'] as List?)?.cast<String>() ?? const <String>[],
      feedingOther: json['feedingOther'] as String?,
      goals: ((json['goals'] as List?) ?? const <dynamic>[])
          .map((g) => goalFromString(g as String?))
          .whereType<Goal>()
          .toList(),
      createdAt: json['createdAt'] as String? ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'babyBirthDate': babyBirthDate,
        'birthType': birthType.name,
        'healthTags': healthTags,
        if (healthOther != null) 'healthOther': healthOther,
        'allergens': allergens,
        if (allergenOther != null) 'allergenOther': allergenOther,
        'dislikes': dislikes,
        if (dislikeOther != null) 'dislikeOther': dislikeOther,
        'feedingStyle': feedingStyle,
        if (feedingOther != null) 'feedingOther': feedingOther,
        'goals': goals.map((g) => g.name).toList(),
        'createdAt': createdAt,
      };

  Profile copyWith({
    String? name,
    String? babyBirthDate,
    BirthType? birthType,
    List<String>? healthTags,
    String? healthOther,
    List<String>? allergens,
    String? allergenOther,
    List<String>? dislikes,
    String? dislikeOther,
    List<String>? feedingStyle,
    String? feedingOther,
    List<Goal>? goals,
    String? createdAt,
  }) {
    return Profile(
      name: name ?? this.name,
      babyBirthDate: babyBirthDate ?? this.babyBirthDate,
      birthType: birthType ?? this.birthType,
      healthTags: healthTags ?? this.healthTags,
      healthOther: healthOther ?? this.healthOther,
      allergens: allergens ?? this.allergens,
      allergenOther: allergenOther ?? this.allergenOther,
      dislikes: dislikes ?? this.dislikes,
      dislikeOther: dislikeOther ?? this.dislikeOther,
      feedingStyle: feedingStyle ?? this.feedingStyle,
      feedingOther: feedingOther ?? this.feedingOther,
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
