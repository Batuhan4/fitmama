enum SleeperType { mom, baby }

SleeperType sleeperFromString(String? s) {
  return SleeperType.values.firstWhere(
    (e) => e.name == s,
    orElse: () => SleeperType.mom,
  );
}

class SleepEntry {
  final String id;
  final SleeperType who;
  final String start;
  final String end;
  final int quality;

  const SleepEntry({
    required this.id,
    required this.who,
    required this.start,
    required this.end,
    required this.quality,
  });

  int get durationMinutes {
    final s = DateTime.parse(start);
    final e = DateTime.parse(end);
    return e.difference(s).inMinutes;
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'] as String,
      who: sleeperFromString(json['who'] as String?),
      start: json['start'] as String,
      end: json['end'] as String,
      quality: (json['quality'] as num?)?.toInt() ?? 3,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'who': who.name,
        'start': start,
        'end': end,
        'quality': quality,
      };
}
