import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';

class MomriseTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MomriseTopBar({
    super.key,
    required this.repository,
    this.title,
    this.showSettings = false,
    this.showLanguageToggle = true,
  });

  final AppRepository repository;
  final String? title;
  final bool showSettings;
  final bool showLanguageToggle;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final displayTitle = title ?? t.appName;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.92),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: scheme.outline.withValues(alpha: 0.4),
              ),
            ),
          ),
          child: Row(
            children: [
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.push('/settings'),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [scheme.primary, scheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (repository.profile?.name.isNotEmpty == true
                            ? repository.profile!.name[0]
                            : '🌸')
                        .toUpperCase(),
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  displayTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: t.navMore,
                onPressed: () => context.push('/more'),
                icon: const Icon(Icons.more_horiz_rounded, size: 20),
              ),
              if (showSettings)
                IconButton(
                  tooltip: t.navSettings,
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings_outlined, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
