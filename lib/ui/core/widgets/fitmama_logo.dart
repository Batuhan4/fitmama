import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// FitMama brand mark — heart silhouette split into a dark grey (left) and
/// hot-pink (right) half, with a matching dumbbell extending from each side.
///
/// The mark is rendered from `assets/branding/fitmama_logo.png` so the visual
/// matches the brand asset exactly. Pair with the two-tone "FitMama" wordmark
/// (default), or use [FitmamaLogo.mark] for the glyph alone.
class FitmamaLogo extends StatelessWidget {
  const FitmamaLogo({
    super.key,
    this.size = FitmamaLogoSize.medium,
    this.markOnly = false,
    this.wordmarkColor,
  });

  const FitmamaLogo.mark({super.key, this.size = FitmamaLogoSize.medium})
      : markOnly = true,
        wordmarkColor = null;

  final FitmamaLogoSize size;
  final bool markOnly;
  final Color? wordmarkColor;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(size);
    final mark = SizedBox(
      height: spec.markHeight,
      child: Image.asset(
        'assets/branding/fitmama_logo.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
    if (markOnly) return mark;

    final scheme = Theme.of(context).colorScheme;
    final wordColor = wordmarkColor ?? scheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mark,
        SizedBox(width: spec.gap),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: spec.fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1,
            ),
            children: [
              const TextSpan(
                text: 'Fit',
                style: TextStyle(color: AppPalette.primary),
              ),
              TextSpan(
                text: 'Mama',
                style: TextStyle(color: wordColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum FitmamaLogoSize { small, medium, large }

class _LogoSpec {
  const _LogoSpec({
    required this.markHeight,
    required this.gap,
    required this.fontSize,
  });
  final double markHeight;
  final double gap;
  final double fontSize;
}

_LogoSpec _spec(FitmamaLogoSize s) {
  switch (s) {
    case FitmamaLogoSize.small:
      return const _LogoSpec(markHeight: 22, gap: 6, fontSize: 16);
    case FitmamaLogoSize.medium:
      return const _LogoSpec(markHeight: 28, gap: 8, fontSize: 20);
    case FitmamaLogoSize.large:
      return const _LogoSpec(markHeight: 56, gap: 12, fontSize: 32);
  }
}
