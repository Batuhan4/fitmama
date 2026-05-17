import 'package:flutter/material.dart';

class MomriseCard extends StatelessWidget {
  const MomriseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.gradient,
    this.onTap,
    this.border,
    this.radius = 16,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = color ?? theme.colorScheme.surface;
    final defaultBorder = Border.all(
      color: theme.colorScheme.outline.withValues(alpha: 0.4),
      width: 1,
    );
    final decoration = BoxDecoration(
      color: gradient == null ? bg : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: border ?? (gradient == null ? defaultBorder : null),
    );
    final card = Container(
      decoration: decoration,
      padding: padding,
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: card,
    );
  }
}

class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MomriseCard(
      padding: padding,
      onTap: onTap,
      gradient: LinearGradient(
        colors: [scheme.primary, scheme.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: scheme.onPrimary),
        child: IconTheme.merge(
          data: IconThemeData(color: scheme.onPrimary),
          child: child,
        ),
      ),
    );
  }
}

class AccentCard extends StatelessWidget {
  const AccentCard({
    super.key,
    required this.child,
    required this.color,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MomriseCard(
      padding: padding,
      onTap: onTap,
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: 0.18),
          color.withValues(alpha: 0.03),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: scheme.outline.withValues(alpha: 0.4),
      ),
      child: child,
    );
  }
}
