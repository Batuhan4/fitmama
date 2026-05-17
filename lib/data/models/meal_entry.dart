class MealEntry {
  final String id;
  final String date;
  final String name;
  final int? calories;
  final String createdAt;

  const MealEntry({
    required this.id,
    required this.date,
    required this.name,
    this.calories,
    required this.createdAt,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String,
      date: json['date'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'name': name,
        if (calories != null) 'calories': calories,
        'createdAt': createdAt,
      };
}
