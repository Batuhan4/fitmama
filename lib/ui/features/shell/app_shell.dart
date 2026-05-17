import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/chatbot_bubble.dart';
import 'top_bar.dart';

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
    _BottomTab('/dashboard', Icons.home_rounded, _LabelKey.dashboard),
    _BottomTab('/feeding', Icons.child_friendly_rounded, _LabelKey.feeding),
    _BottomTab('/mood', Icons.sentiment_satisfied_rounded, _LabelKey.mood),
    _BottomTab('/progress', Icons.bar_chart_rounded, _LabelKey.progress),
    _BottomTab('/exercise', Icons.fitness_center_rounded, _LabelKey.exercise),
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
    final showSettings = location == '/dashboard';
    return Scaffold(
      appBar: MomriseTopBar(
        repository: repository,
        title: _titleFor(location, t),
        showSettings: showSettings,
      ),
      body: ChatbotOverlay(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          context.go(_tabs[i].path);
        },
        destinations: _tabs
            .map((tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  label: _label(tab.label, t),
                ))
            .toList(),
      ),
    );
  }

  static String _label(_LabelKey key, AppLocalizations t) {
    switch (key) {
      case _LabelKey.dashboard:
        return t.navDashboard;
      case _LabelKey.feeding:
        return t.navFeeding;
      case _LabelKey.mood:
        return t.navMood;
      case _LabelKey.progress:
        return t.navProgress;
      case _LabelKey.exercise:
        return t.navExercise;
    }
  }

  static String? _titleFor(String location, AppLocalizations t) {
    switch (location) {
      case '/dashboard':
        return null;
      case '/feeding':
        return t.feedTitle;
      case '/mood':
        return t.moodTitle;
      case '/sleep':
        return t.sleepTitle;
      case '/exercise':
        return t.exTitle;
      case '/breathing':
        return t.breathTitle;
      case '/nutrition':
        return t.nutTitle;
      case '/videos':
        return t.vidTitle;
      case '/community':
        return t.comTitle;
      case '/progress':
        return t.progTitle;
      case '/reminders':
        return t.remTitle;
      case '/settings':
        return t.setTitle;
      case '/more':
        return t.navMore;
      case '/recovery':
        return t.recoveryTitle;
      case '/milestones':
        return t.milestoneTitle;
      case '/kegel':
        return t.kegelTitle;
      default:
        return null;
    }
  }
}

class _BottomTab {
  const _BottomTab(this.path, this.icon, this.label);
  final String path;
  final IconData icon;
  final _LabelKey label;
}

enum _LabelKey { dashboard, feeding, mood, progress, exercise }
