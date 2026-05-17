/// Per-program progress: which levels finished, accumulated time + XP.
/// Persisted as a `Map<String, ProgramProgress>` under `StorageKeys.programProgress`.
class ProgramProgress {
  const ProgramProgress({
    required this.programId,
    required this.completedLevels,
    required this.totalSeconds,
    required this.xp,
    this.lastDoneAt,
  });

  final String programId;
  final Set<int> completedLevels;
  final int totalSeconds;
  final int xp;
  final String? lastDoneAt;

  bool isLevelUnlocked(int index) =>
      index == 0 || completedLevels.contains(index - 1);

  bool isLevelCompleted(int index) => completedLevels.contains(index);

  int get nextLevelIndex {
    if (completedLevels.isEmpty) return 0;
    final maxDone = completedLevels.reduce((a, b) => a > b ? a : b);
    return maxDone + 1;
  }

  static const empty = ProgramProgress(
    programId: '',
    completedLevels: <int>{},
    totalSeconds: 0,
    xp: 0,
  );

  ProgramProgress copyWith({
    Set<int>? completedLevels,
    int? totalSeconds,
    int? xp,
    String? lastDoneAt,
  }) {
    return ProgramProgress(
      programId: programId,
      completedLevels: completedLevels ?? this.completedLevels,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      xp: xp ?? this.xp,
      lastDoneAt: lastDoneAt ?? this.lastDoneAt,
    );
  }

  factory ProgramProgress.fromJson(Map<String, dynamic> json) {
    final levels = (json['completedLevels'] as List<dynamic>? ?? const [])
        .map((e) => (e as num).toInt())
        .toSet();
    return ProgramProgress(
      programId: json['programId'] as String,
      completedLevels: levels,
      totalSeconds: (json['totalSeconds'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      lastDoneAt: json['lastDoneAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'programId': programId,
        'completedLevels': completedLevels.toList()..sort(),
        'totalSeconds': totalSeconds,
        'xp': xp,
        if (lastDoneAt != null) 'lastDoneAt': lastDoneAt,
      };
}
