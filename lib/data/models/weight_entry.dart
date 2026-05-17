class WeightEntry {
  final String id;
  final String date;
  final double kg;

  const WeightEntry({
    required this.id,
    required this.date,
    required this.kg,
  });

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      id: json['id'] as String,
      date: json['date'] as String,
      kg: (json['kg'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'kg': kg,
      };
}
