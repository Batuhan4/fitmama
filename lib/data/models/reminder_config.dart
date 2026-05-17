enum ReminderKind { feeding, water, sleep, exercise, mood, doctor }

ReminderKind reminderKindFromString(String? s) {
  return ReminderKind.values.firstWhere(
    (e) => e.name == s,
    orElse: () => ReminderKind.feeding,
  );
}

class ReminderConfig {
  final String id;
  final ReminderKind kind;
  final bool enabled;
  final int intervalMin;

  const ReminderConfig({
    required this.id,
    required this.kind,
    required this.enabled,
    required this.intervalMin,
  });

  factory ReminderConfig.fromJson(Map<String, dynamic> json) {
    return ReminderConfig(
      id: json['id'] as String,
      kind: reminderKindFromString(json['kind'] as String?),
      enabled: json['enabled'] as bool? ?? false,
      intervalMin: (json['intervalMin'] as num?)?.toInt() ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'enabled': enabled,
        'intervalMin': intervalMin,
      };

  ReminderConfig copyWith({bool? enabled, int? intervalMin}) {
    return ReminderConfig(
      id: id,
      kind: kind,
      enabled: enabled ?? this.enabled,
      intervalMin: intervalMin ?? this.intervalMin,
    );
  }
}
