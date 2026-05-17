import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';

/// FitMama 5-tab shell. Tabs: Ana Sayfa, Programlar, Beslenme, İstatistikler,
/// Profil. Each screen owns its own header (logo / search / actions).
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.repository,
    required this.child,
    required this.location,
  });

  final AppRepository repository;
  final Widget child;
  final String location;

  static const _tabs = <_BottomTab>[
    _BottomTab('/home', Icons.home_outlined, Icons.home_rounded,
        _LabelKey.home),
    _BottomTab(
        '/programs',
        Icons.calendar_today_outlined,
        Icons.calendar_today_rounded,
        _LabelKey.programs),
    _BottomTab(
        '/nutrition',
        Icons.restaurant_outlined,
        Icons.restaurant_rounded,
        _LabelKey.nutrition),
    _BottomTab(
        '/stats',
        Icons.bar_chart_outlined,
        Icons.bar_chart_rounded,
        _LabelKey.stats),
    _BottomTab(
        '/profile',
        Icons.person_outline_rounded,
        Icons.person_rounded,
        _LabelKey.profile),
  ];

  int get _currentIndex {
    final ix = _tabs.indexWhere(
      (tab) => location == tab.path || location.startsWith('${tab.path}/'),
    );
    if (ix == -1) return 0;
    return ix;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final selected = _currentIndex;
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            top: BorderSide(color: scheme.outline, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isSelected = i == selected;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(tab.path),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? tab.iconActive : tab.icon,
                          size: 24,
                          color: isSelected
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _label(tab.label, t),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  static String _label(_LabelKey key, AppLocalizations t) {
    switch (key) {
      case _LabelKey.home:
        return t.tabHome;
      case _LabelKey.programs:
        return t.tabPrograms;
      case _LabelKey.nutrition:
        return t.tabNutrition;
      case _LabelKey.stats:
        return t.tabStats;
      case _LabelKey.profile:
        return t.tabProfile;
    }
  }
}

class _BottomTab {
  const _BottomTab(this.path, this.icon, this.iconActive, this.label);
  final String path;
  final IconData icon;
  final IconData iconActive;
  final _LabelKey label;
}

enum _LabelKey { home, programs, nutrition, stats, profile }
