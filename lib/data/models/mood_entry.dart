enum MoodKind { happy, tired, stressed, anxious, energetic }

MoodKind moodFromString(String? s) {
  return MoodKind.values.firstWhere(
    (e) => e.name == s,
    orElse: () => MoodKind.happy,
  );
}

const Set<MoodKind> negativeMoods = {
  MoodKind.stressed,
  MoodKind.anxious,
  MoodKind.tired,
};

class MoodEntry {
  final String id;
  final String date;
  final MoodKind mood;
  final String? note;
  final String createdAt;

  const MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.note,
    required this.createdAt,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      date: json['date'] as String,
      mood: moodFromString(json['mood'] as String?),
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'mood': mood.name,
        if (note != null) 'note': note,
        'createdAt': createdAt,
      };
}
