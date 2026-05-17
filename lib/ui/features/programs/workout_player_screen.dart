import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/program_catalog.dart';
import '../../../data/repositories/app_repository.dart';
import '../../core/theme/app_theme.dart';

enum _PhaseKind { prep, active, rest, transition, done }

class _Phase {
  const _Phase({
    required this.kind,
    required this.label,
    required this.seconds,
    this.exerciseIndex,
    this.setIndex,
    this.sub,
  });

  final _PhaseKind kind;
  final String label;
  final int seconds;
  final int? exerciseIndex;
  final int? setIndex;
  final String? sub;
}

class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({
    super.key,
    required this.repository,
    required this.programId,
    required this.levelIndex,
  });

  final AppRepository repository;
  final String programId;
  final int levelIndex;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  late final ProgramDefinition? _program = programById(widget.programId);
  late final ProgramLevelDef? _level =
      _program?.levels.elementAt(widget.levelIndex);

  late final List<_Phase> _phases = _buildPhases();
  int _phaseIndex = 0;
  int _remaining = 0;
  Timer? _timer;
  bool _paused = false;
  int _elapsedActiveSec = 0;

  @override
  void initState() {
    super.initState();
    if (_phases.isNotEmpty) {
      _remaining = _phases.first.seconds;
      _start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<_Phase> _buildPhases() {
    final lvl = _level;
    if (lvl == null) return const [];
    final out = <_Phase>[
      _Phase(kind: _PhaseKind.prep, label: 'Hazırlan', seconds: 5),
    ];
    for (var ei = 0; ei < lvl.exercises.length; ei++) {
      final ex = lvl.exercises[ei];
      for (var si = 0; si < ex.sets; si++) {
        out.add(_Phase(
          kind: _PhaseKind.active,
          label: ex.name,
          seconds: ex.seconds,
          exerciseIndex: ei,
          setIndex: si,
          sub: ex.sub,
        ));
        if (si < ex.sets - 1 && ex.restSec > 0) {
          out.add(_Phase(
            kind: _PhaseKind.rest,
            label: 'Set arası dinlen',
            seconds: ex.restSec,
            exerciseIndex: ei,
            setIndex: si,
          ));
        }
      }
      if (ei < lvl.exercises.length - 1) {
        final next = lvl.exercises[ei + 1];
        out.add(_Phase(
          kind: _PhaseKind.transition,
          label: 'Sıradaki: ${next.name}',
          seconds: 20,
          exerciseIndex: ei + 1,
          sub: next.sub,
        ));
      }
    }
    out.add(const _Phase(
        kind: _PhaseKind.done, label: 'Tamamlandı!', seconds: 0));
    return out;
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_paused) return;
    if (_remaining > 1) {
      setState(() {
        _remaining -= 1;
        final p = _phases[_phaseIndex];
        if (p.kind == _PhaseKind.active) _elapsedActiveSec += 1;
      });
      if (_remaining <= 3) {
        HapticFeedback.lightImpact();
      }
      return;
    }
    HapticFeedback.mediumImpact();
    _advance();
  }

  void _advance() {
    final next = _phaseIndex + 1;
    if (next >= _phases.length || _phases[next].kind == _PhaseKind.done) {
      _timer?.cancel();
      setState(() {
        _phaseIndex = _phases.length - 1;
        _remaining = 0;
      });
      _finish();
      return;
    }
    setState(() {
      _phaseIndex = next;
      _remaining = _phases[next].seconds;
      if (_phases[next].kind == _PhaseKind.active) {
        // count the seconds we're about to do
      }
    });
  }

  void _skip() {
    if (_phaseIndex >= _phases.length - 1) return;
    HapticFeedback.selectionClick();
    _advance();
  }

  void _previous() {
    if (_phaseIndex == 0) return;
    HapticFeedback.selectionClick();
    setState(() {
      _phaseIndex -= 1;
      _remaining = _phases[_phaseIndex].seconds;
    });
  }

  void _togglePause() {
    HapticFeedback.selectionClick();
    setState(() => _paused = !_paused);
  }

  Future<void> _finish() async {
    final lvl = _level;
    final prog = _program;
    if (lvl == null || prog == null) return;
    final xp = lvl.xpReward;
    await widget.repository.recordLevelCompleted(
      programId: prog.id,
      levelIndex: lvl.index,
      durationSec: _elapsedActiveSec,
      xpEarned: xp,
    );
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CompletionDialog(
        program: prog,
        level: lvl,
        durationSec: _elapsedActiveSec,
        xp: xp,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<bool> _confirmExit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Antrenmandan çıkılsın mı?'),
        content: const Text(
            'Çıkarsan bu seans kaydedilmeyecek. Sonra kaldığın yerden başlayabilirsin.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Devam et')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Çık')),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_level == null || _program == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Program bulunamadı')),
        body: const Center(child: Text('Bu program henüz hazır değil.')),
      );
    }
    final phase = _phases[_phaseIndex];
    final theme = Theme.of(context);
    final isActive = phase.kind == _PhaseKind.active;
    final isRest = phase.kind == _PhaseKind.rest;
    final isPrep = phase.kind == _PhaseKind.prep;
    final isTrans = phase.kind == _PhaseKind.transition;
    final gradient = isActive
        ? const LinearGradient(
            colors: [AppPalette.primary, AppPalette.accentPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : isRest
            ? const LinearGradient(
                colors: [AppPalette.accentBlue, AppPalette.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : isTrans
                ? const LinearGradient(
                    colors: [AppPalette.accentOrange, AppPalette.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [AppPalette.accentPurple, AppPalette.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  );

    // Progress to show: position in current level (phase index / total phases)
    final overallProgress =
        _phases.length <= 1 ? 0.0 : _phaseIndex / (_phases.length - 1);
    // Step progress: remaining vs total of phase
    final stepProgress = phase.seconds <= 0
        ? 1.0
        : 1.0 - (_remaining / phase.seconds);

    final activeStepCount = _phases
        .where((p) => p.kind == _PhaseKind.active)
        .length;
    final activeDoneCount = _phases
        .take(_phaseIndex + 1)
        .where((p) => p.kind == _PhaseKind.active)
        .length;

    final exerciseIdx = phase.exerciseIndex;
    final ex = exerciseIdx != null && exerciseIdx < _level.exercises.length
        ? _level.exercises[exerciseIdx]
        : null;
    final setLabel = isActive && ex != null && ex.sets > 1
        ? 'Set ${(phase.setIndex ?? 0) + 1} / ${ex.sets}'
        : null;

    final nav = Navigator.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit()) {
          _timer?.cancel();
          if (mounted) nav.pop();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white),
                        onPressed: () async {
                          if (await _confirmExit()) {
                            _timer?.cancel();
                            if (mounted) nav.pop();
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          _level.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: overallProgress.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hareket $activeDoneCount / $activeStepCount',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (isPrep)
                    const Text('BAŞLIYORUZ',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontSize: 16,
                            fontWeight: FontWeight.w800))
                  else if (isRest)
                    const Text('DİNLEN',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontSize: 16,
                            fontWeight: FontWeight.w800))
                  else if (isTrans)
                    const Text('SIRADAKİ',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  Text(
                    phase.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1),
                  ),
                  if (setLabel != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(setLabel,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                  if (phase.sub != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      phase.sub!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.3),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: stepProgress.clamp(0.0, 1.0),
                            strokeWidth: 12,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.18),
                            valueColor: const AlwaysStoppedAnimation(
                                Colors.white),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _format(_remaining),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 70,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                letterSpacing: -2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'saniye',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CircleButton(
                        icon: Icons.skip_previous_rounded,
                        onTap: _previous,
                        size: 56,
                      ),
                      _CircleButton(
                        icon: _paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        onTap: _togglePause,
                        size: 76,
                        filled: true,
                      ),
                      _CircleButton(
                        icon: Icons.skip_next_rounded,
                        onTap: _skip,
                        size: 56,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Toplam aktif: ${_format(_elapsedActiveSec)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _format(int sec) {
    if (sec < 60) return sec.toString().padLeft(2, '0');
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.size,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: size / 2 + 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? Colors.white : Colors.white.withValues(alpha: 0.2),
        ),
        child: Icon(
          icon,
          color: filled ? AppPalette.primary : Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}

class _CompletionDialog extends StatelessWidget {
  const _CompletionDialog({
    required this.program,
    required this.level,
    required this.durationSec,
    required this.xp,
  });

  final ProgramDefinition program;
  final ProgramLevelDef level;
  final int durationSec;
  final int xp;

  @override
  Widget build(BuildContext context) {
    final mins = math.max(1, (durationSec / 60).ceil());
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppPalette.primary, AppPalette.accentPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events_rounded,
                  color: Colors.white, size: 44),
            ),
            const SizedBox(height: 18),
            Text(
              '${level.name} tamamlandı!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              program.title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.bolt_rounded,
                    color: AppPalette.accentYellow,
                    title: '+$xp XP',
                    sub: 'Kazanılan',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: Icons.schedule_rounded,
                    color: AppPalette.accentBlue,
                    title: '$mins dk',
                    sub: 'Aktif süre',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Harika, kapat'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.sub,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
          Text(sub, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
