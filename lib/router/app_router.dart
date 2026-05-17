import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/app_repository.dart';
import '../data/models/user_role.dart';
import '../ui/features/breathing/breathing_screen.dart';
import '../ui/features/community/community_screen.dart';
import '../ui/features/dashboard/dashboard_screen.dart';
import '../ui/features/exercise/exercise_hub_screen.dart';
import '../ui/features/feeding/feeding_screen.dart';
import '../ui/features/milestones/baby_milestones_screen.dart';
import '../ui/features/milestones/kegel_screen.dart';
import '../ui/features/milestones/recovery_timeline_screen.dart';
import '../ui/features/mood/mood_screen.dart';
import '../ui/features/more/more_screen.dart';
import '../ui/features/nutrition/nutrition_screen.dart';
import '../ui/features/onboarding/onboarding_screen.dart';
import '../ui/features/partner/partner_screen.dart';
import '../ui/features/progress/progress_screen.dart';
import '../ui/features/reminders/reminders_screen.dart';
import '../ui/features/settings/settings_screen.dart';
import '../ui/features/shell/app_shell.dart';
import '../ui/features/sleep/sleep_screen.dart';
import '../ui/features/videos/videos_screen.dart';
import '../ui/features/welcome/welcome_screen.dart';

GoRouter buildRouter(AppRepository repository, {String? initialLocation}) {
  final shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  return GoRouter(
    initialLocation: initialLocation ?? '/',
    refreshListenable: repository,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final role = repository.role;
      final hasProfile = repository.profile != null;
      final isAuthRoute = loc == '/welcome' ||
          loc == '/onboarding' ||
          loc == '/partner';
      if (loc == '/') {
        if (role == null) return '/welcome';
        if (role == UserRole.partner) return '/partner';
        return hasProfile ? '/dashboard' : '/onboarding';
      }
      if (role == null && !isAuthRoute) return '/welcome';
      if (role == UserRole.partner &&
          !(loc == '/partner' ||
              loc == '/settings' ||
              loc == '/progress' ||
              loc == '/welcome')) {
        return '/partner';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (_, _) => WelcomeScreen(repository: repository),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => OnboardingScreen(repository: repository),
      ),
      GoRoute(
        path: '/partner',
        builder: (_, _) => PartnerScreen(repository: repository),
      ),
      ShellRoute(
        navigatorKey: shellKey,
        builder: (context, state, child) {
          return AppShellScaffold(
            repository: repository,
            location: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => DashboardScreen(repository: repository),
          ),
          GoRoute(
            path: '/feeding',
            builder: (_, _) => FeedingScreen(repository: repository),
          ),
          GoRoute(
            path: '/mood',
            builder: (_, _) => MoodScreen(repository: repository),
          ),
          GoRoute(
            path: '/sleep',
            builder: (_, _) => SleepScreen(repository: repository),
          ),
          GoRoute(
            path: '/exercise',
            builder: (_, _) => ExerciseHubScreen(repository: repository),
          ),
          GoRoute(
            path: '/breathing',
            builder: (_, _) => const BreathingScreen(),
          ),
          GoRoute(
            path: '/nutrition',
            builder: (_, _) => NutritionScreen(repository: repository),
          ),
          GoRoute(
            path: '/videos',
            builder: (_, _) => VideosScreen(repository: repository),
          ),
          GoRoute(
            path: '/community',
            builder: (_, _) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/progress',
            builder: (_, _) => ProgressScreen(repository: repository),
          ),
          GoRoute(
            path: '/reminders',
            builder: (_, _) => RemindersScreen(repository: repository),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => SettingsScreen(repository: repository),
          ),
          GoRoute(
            path: '/more',
            builder: (_, _) => const MoreScreen(),
          ),
          GoRoute(
            path: '/recovery',
            builder: (_, _) =>
                RecoveryTimelineScreen(repository: repository),
          ),
          GoRoute(
            path: '/milestones',
            builder: (_, _) =>
                BabyMilestonesScreen(repository: repository),
          ),
          GoRoute(
            path: '/kegel',
            builder: (_, _) => const KegelScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('404 — ${state.uri}')),
    ),
  );
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
