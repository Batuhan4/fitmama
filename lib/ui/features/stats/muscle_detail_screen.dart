import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class MuscleDetailScreen extends StatelessWidget {
  const MuscleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final segments = const [
      _MuscleSegment('Kalça', 18, 25, 'Çok İyi', AppPalette.successDark),
      _MuscleSegment('Bacak (Arka)', 14, 20, 'İyi', AppPalette.successDark),
      _MuscleSegment(
          'Bacak (Ön)', 12, 18, 'Orta', AppPalette.accentOrange),
      _MuscleSegment('Karın (Core)', 11, 15, 'İyi', AppPalette.successDark),
      _MuscleSegment('Sırt', 8, 12, 'Orta', AppPalette.accentOrange),
      _MuscleSegment(
          'Omuz', 5, 10, 'Başlangıç', AppPalette.destructiveDark),
      _MuscleSegment(
          'Alt Karın', 3, 12, 'Başlangıç', AppPalette.destructiveDark),
      _MuscleSegment(
          'İç Bacak', 4, 10, 'Başlangıç', AppPalette.destructiveDark),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Kas grubu detay')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: FitmamaCard(
              padding: const EdgeInsets.all(12),
              child: CustomPaint(
                painter: _FullBodyPainter(),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot('Çok İyi', AppPalette.successDark),
              const SizedBox(width: 14),
              _LegendDot('İyi', AppPalette.primary),
              const SizedBox(width: 14),
              _LegendDot('Orta', AppPalette.accentOrange),
              const SizedBox(width: 14),
              _LegendDot('Başlangıç', AppPalette.destructiveDark),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Haftalık döküm',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          FitmamaCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                for (var i = 0; i < segments.length; i++) ...[
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: segments[i].color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(segments[i].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                      Text(
                        '${segments[i].sessions} seans · ${segments[i].minutes} dk',
                        style:
                            TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(segments[i].level,
                          style: TextStyle(
                              color: segments[i].color,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ],
                  ),
                  if (i < segments.length - 1) const Divider(height: 16),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Geliştirmen önerilen alanlar',
            upper: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SuggestionChip(label: 'Shoulder Pre-hab', icon: Icons.spa_rounded),
              _SuggestionChip(
                  label: 'Alt karın izolasyon', icon: Icons.center_focus_strong_rounded),
              _SuggestionChip(label: 'İç bacak adduktor', icon: Icons.directions_walk_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _MuscleSegment {
  const _MuscleSegment(
      this.name, this.sessions, this.minutes, this.level, this.color);
  final String name;
  final int sessions;
  final int minutes;
  final String level;
  final Color color;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 11.5)),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppPalette.primary.withValues(alpha: 0.15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppPalette.primary, size: 14),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class _FullBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Two silhouettes — front (left) and back (right).
    final base = Paint()
      ..color = AppPalette.darkMutedForeground.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final hot = Paint()
      ..color = AppPalette.primary.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    final warm = Paint()
      ..color = AppPalette.accentOrange.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    final cold = Paint()
      ..color = AppPalette.accentBlue.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    void drawBody(double offsetX, {required bool back}) {
      final cx = offsetX + w * 0.22;
      final cy = h * 0.5;
      final scale = w * 0.18;

      // Head
      canvas.drawCircle(Offset(cx, cy - scale * 1.65), scale * 0.32, base);
      // Torso
      final torso = Path()
        ..moveTo(cx - scale * 0.55, cy - scale * 1.1)
        ..lineTo(cx + scale * 0.55, cy - scale * 1.1)
        ..lineTo(cx + scale * 0.65, cy + scale * 0.05)
        ..lineTo(cx + scale * 0.5, cy + scale * 0.2)
        ..lineTo(cx + scale * 0.5, cy + scale * 1.6)
        ..lineTo(cx - scale * 0.5, cy + scale * 1.6)
        ..lineTo(cx - scale * 0.5, cy + scale * 0.2)
        ..lineTo(cx - scale * 0.65, cy + scale * 0.05)
        ..close();
      canvas.drawPath(torso, base);
      // Arms
      canvas.drawRRect(
          RRect.fromLTRBR(cx - scale * 1.2, cy - scale * 1.0,
              cx - scale * 0.7, cy + scale * 0.2, const Radius.circular(10)),
          base);
      canvas.drawRRect(
          RRect.fromLTRBR(cx + scale * 0.7, cy - scale * 1.0,
              cx + scale * 1.2, cy + scale * 0.2, const Radius.circular(10)),
          base);

      // Highlights
      if (back) {
        // Glute & hamstring strong
        canvas.drawRRect(
            RRect.fromLTRBR(cx - scale * 0.4, cy + scale * 0.05,
                cx + scale * 0.4, cy + scale * 0.5, const Radius.circular(14)),
            hot);
        canvas.drawRRect(
            RRect.fromLTRBR(cx - scale * 0.45, cy + scale * 0.6,
                cx + scale * 0.45, cy + scale * 1.2, const Radius.circular(14)),
            warm);
        // Upper back medium
        canvas.drawRRect(
            RRect.fromLTRBR(cx - scale * 0.45, cy - scale * 1.0,
                cx + scale * 0.45, cy - scale * 0.4, const Radius.circular(14)),
            warm);
      } else {
        // Core highlight strong
        canvas.drawRRect(
            RRect.fromLTRBR(cx - scale * 0.3, cy - scale * 0.4,
                cx + scale * 0.3, cy + scale * 0.05, const Radius.circular(10)),
            hot);
        // Chest medium
        canvas.drawRRect(
            RRect.fromLTRBR(cx - scale * 0.4, cy - scale * 0.95,
                cx + scale * 0.4, cy - scale * 0.5, const Radius.circular(14)),
            warm);
        // Quads warm
        canvas.drawRRect(
            RRect.fromLTRBR(cx - scale * 0.45, cy + scale * 0.6,
                cx - scale * 0.06, cy + scale * 1.4, const Radius.circular(14)),
            warm);
        canvas.drawRRect(
            RRect.fromLTRBR(cx + scale * 0.06, cy + scale * 0.6,
                cx + scale * 0.45, cy + scale * 1.4, const Radius.circular(14)),
            warm);
        // Shoulder cold (needs work)
        canvas.drawCircle(
            Offset(cx - scale * 0.7, cy - scale * 0.95), scale * 0.18, cold);
        canvas.drawCircle(
            Offset(cx + scale * 0.7, cy - scale * 0.95), scale * 0.18, cold);
      }

      // Label
      final tp = TextPainter(
        text: TextSpan(
          text: back ? 'Arka' : 'Ön',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy + scale * 1.7));
    }

    drawBody(0, back: false);
    drawBody(w * 0.5, back: true);
  }

  @override
  bool shouldRepaint(_) => false;
}
