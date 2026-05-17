enum FeedingSide { left, right, bottle }

FeedingSide feedingSideFromString(String? s) {
  return FeedingSide.values.firstWhere(
    (e) => e.name == s,
    orElse: () => FeedingSide.left,
  );
}

class FeedingEntry {
  final String id;
  final String startedAt;
  final int durationSec;
  final FeedingSide side;
  final int? amountMl;

  const FeedingEntry({
    required this.id,
    required this.startedAt,
    required this.durationSec,
    required this.side,
    this.amountMl,
  });

  factory FeedingEntry.fromJson(Map<String, dynamic> json) {
    return FeedingEntry(
      id: json['id'] as String,
      startedAt: json['startedAt'] as String,
      durationSec: (json['durationSec'] as num?)?.toInt() ?? 0,
      side: feedingSideFromString(json['side'] as String?),
      amountMl: (json['amountMl'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startedAt': startedAt,
        'durationSec': durationSec,
        'side': side.name,
        if (amountMl != null) 'amountMl': amountMl,
      };
}
