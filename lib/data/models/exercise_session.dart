class ExerciseSession {
  final String id;
  final String exerciseId;
  final String category;
  final int durationMin;
  final String doneAt;

  const ExerciseSession({
    required this.id,
    required this.exerciseId,
    required this.category,
    required this.durationMin,
    required this.doneAt,
  });

  factory ExerciseSession.fromJson(Map<String, dynamic> json) {
    return ExerciseSession(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      category: json['category'] as String? ?? 'yoga',
      durationMin: (json['durationMin'] as num?)?.toInt() ?? 0,
      doneAt: json['doneAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'category': category,
        'durationMin': durationMin,
        'doneAt': doneAt,
      };
}
