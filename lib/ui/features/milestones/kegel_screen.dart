import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';

class KegelScreen extends StatefulWidget {
  const KegelScreen({super.key});

  @override
  State<KegelScreen> createState() => _KegelScreenState();
}

class _KegelScreenState extends State<KegelScreen> {
  bool _running = false;
  bool _squeezing = true;
  int _count = 5;
  int _cyclesDone = 0;
  Timer? _timer;
  static const _totalCycles = 10;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _running = !_running;
      _squeezing = true;
      _count = 5;
      _cyclesDone = 0;
    });
    _timer?.cancel();
    if (_running) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (_count <= 1) {
            if (!_squeezing) {
              _cyclesDone += 1;
              if (_cyclesDone >= _totalCycles) {
                _timer?.cancel();
                _running = false;
                _cyclesDone = 0;
                _squeezing = true;
                _count = 5;
                return;
              }
            }
            _squeezing = !_squeezing;
            _count = 5;
          } else {
            _count -= 1;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final progress = _running ? _cyclesDone / _totalCycles : 0.0;
    final label = _squeezing ? t.kegelSqueeze : t.kegelRelease;
    final color = _squeezing
        ? scheme.primary
        : scheme.primary.withValues(alpha: 0.6);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 18),
      children: [
        Text(t.kegelDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 24),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            width: _squeezing && _running ? 220 : 170,
            height: _squeezing && _running ? 220 : 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.18),
              border: Border.all(color: color, width: 3),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_rounded,
                    size: 48, color: color),
                const SizedBox(height: 8),
                Text(
                  _running ? label : '—',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  _running ? '$_count' : '',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_running)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Text('$_cyclesDone / $_totalCycles',
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                    )),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: _toggle,
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(_running ? t.breathStop : t.breathStart),
          ),
        ),
        const SizedBox(height: 24),
        MomriseCard(
          child: Text(
            '💡 Önerilen: günde 3 set, her sette 10 kasılma.',
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
