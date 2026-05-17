import 'package:flutter/material.dart';

/// Standard section header — bold title on the left, optional small icon, and
/// an optional "see all" link on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.trailingLabel,
    this.onTrailingTap,
    this.upper = false,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 12),
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  final bool upper;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textStyle = upper
        ? theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            fontSize: 13,
          )
        : theme.textTheme.titleLarge;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor ?? scheme.primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              upper ? title.toUpperCase() : title,
              style: textStyle,
            ),
          ),
          if (trailingLabel != null && onTrailingTap != null)
            InkWell(
              onTap: onTrailingTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      trailingLabel!,
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        size: 14, color: scheme.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
