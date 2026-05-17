import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

enum _Phase { inhale, hold, exhale }

class _BreathingScreenState extends State<BreathingScreen> {
  bool _running = false;
  _Phase _phase = _Phase.inhale;
  int _count = 4;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _running = !_running;
      _phase = _Phase.inhale;
      _count = 4;
    });
    _timer?.cancel();
    if (_running) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (_count <= 1) {
            _phase = _Phase.values[(_phase.index + 1) % _Phase.values.length];
            _count = 4;
          } else {
            _count -= 1;
          }
        });
      });
    }
  }

  String _phaseLabel(_Phase p, AppLocalizations t) {
    switch (p) {
      case _Phase.inhale:
        return t.breathInhale;
      case _Phase.hold:
        return t.breathHold;
      case _Phase.exhale:
        return t.breathExhale;
    }
  }

  double _scale() {
    if (!_running) return 1;
    switch (_phase) {
      case _Phase.inhale:
        return 1.1;
      case _Phase.hold:
        return 1;
      case _Phase.exhale:
        return 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 18),
      children: [
        Text(t.breathDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 40),
        Center(
          child: AnimatedScale(
            duration: const Duration(seconds: 1),
            scale: _scale(),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _phaseLabel(_phase, t),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: scheme.onPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _running ? '$_count' : '—',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(
                          color: scheme.onPrimary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
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
            t.breathCalmHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
