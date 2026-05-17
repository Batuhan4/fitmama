class WaterEntry {
  final String id;
  final String date;
  final int cups;

  const WaterEntry({
    required this.id,
    required this.date,
    required this.cups,
  });

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      id: json['id'] as String,
      date: json['date'] as String,
      cups: (json['cups'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'cups': cups,
      };
}
