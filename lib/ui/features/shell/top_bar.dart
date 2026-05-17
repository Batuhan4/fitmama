import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_logo.dart';

/// FitMama unified top bar. Used inside each tab screen so individual pages
/// can supply their own trailing actions (search / notification / settings).
class FitmamaTopBar extends StatelessWidget {
  const FitmamaTopBar({
    super.key,
    required this.repository,
    this.actions = const [],
    this.showAvatar = false,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 12),
  });

  final AppRepository repository;
  final List<Widget> actions;
  final bool showAvatar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const FitmamaLogo(size: FitmamaLogoSize.medium),
      const Spacer(),
      ...actions.map(
        (w) => Padding(padding: const EdgeInsets.only(left: 8), child: w),
      ),
      if (showAvatar) ...[
        const SizedBox(width: 8),
        InkWell(
          onTap: () => context.go('/profile'),
          customBorder: const CircleBorder(),
          child: _Avatar(repository: repository),
        ),
      ],
    ];
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: padding,
        child: Row(children: children),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.repository});
  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = repository.profile?.name ?? '';
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'F';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppPalette.primary, AppPalette.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: scheme.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Pill-shaped icon button used in headers. Pink-fill variant for primary
/// search / filter; tonal variant for notification etc.
class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.badge = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool badge;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = filled
        ? scheme.primary
        : Theme.of(context).brightness == Brightness.dark
            ? AppPalette.darkSurfaceRaised
            : AppPalette.lightSurfaceRaised;
    final fg = filled ? Colors.white : scheme.onSurface;
    final btn = InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
        child: Stack(
          children: [
            Center(child: Icon(icon, size: 20, color: fg)),
            if (badge)
              Positioned(
                top: 8,
                right: 9,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary,
                    border: Border.all(color: bg, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}
