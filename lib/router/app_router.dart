import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/user_role.dart';
import '../data/repositories/app_repository.dart';
import '../ui/core/widgets/fitmama_logo.dart';
import '../ui/features/breathing/breathing_screen.dart';
import '../ui/features/community/community_screen.dart';
import '../ui/features/dashboard/dashboard_screen.dart';
import '../ui/features/exercise/exercise_hub_screen.dart';
import '../ui/features/feeding/feeding_screen.dart';
import '../ui/features/home/home_screen.dart';
import '../ui/features/milestones/baby_milestones_screen.dart';
import '../ui/features/milestones/kegel_screen.dart';
import '../ui/features/milestones/recovery_timeline_screen.dart';
import '../ui/features/mood/mood_screen.dart';
import '../ui/features/more/more_screen.dart';
import '../ui/features/nutrition/nutrition_screen.dart';
import '../ui/features/activity/activity_screen.dart';
import '../ui/features/challenges/challenges_screen.dart';
import '../ui/features/notifications/notifications_screen.dart';
import '../ui/features/nutrition/ai_food_analyzer_screen.dart';
import '../ui/features/nutrition/blog_screen.dart';
import '../ui/features/nutrition/recipe_detail_screen.dart';
import '../ui/features/nutrition/recipes_list_screen.dart';
import '../ui/features/nutrition/shopping_list_screen.dart';
import '../ui/features/onboarding/fitness_quiz_screen.dart';
import '../ui/features/onboarding/onboarding_screen.dart';
import '../ui/features/partner/partner_screen.dart';
import '../ui/features/profile/goals_screen.dart';
import '../ui/features/profile/profile_screen.dart';
import '../ui/features/programs/programs_list_screen.dart';
import '../ui/features/programs/programs_screen.dart';
import '../ui/features/programs/workout_detail_screen.dart';
import '../ui/features/programs/workout_player_screen.dart';
import '../ui/features/search/search_screen.dart';
import '../ui/features/stats/muscle_detail_screen.dart';
import '../ui/features/progress/progress_screen.dart';
import '../ui/features/reminders/reminders_screen.dart';
import '../ui/features/settings/settings_screen.dart';
import '../ui/features/shell/app_shell.dart';
import '../ui/features/sleep/sleep_screen.dart';
import '../ui/features/stats/stats_screen.dart';
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
      final quizDone = repository.fitnessQuiz?.completed == true;
      final isAuthRoute = loc == '/welcome' ||
          loc == '/onboarding' ||
          loc == '/fitness-quiz' ||
          loc == '/partner';
      if (loc == '/') {
        if (role == null) return '/welcome';
        if (role == UserRole.partner) return '/partner';
        if (!quizDone) return '/fitness-quiz';
        return hasProfile ? '/home' : '/onboarding';
      }
      // Backwards compat — old `/dashboard` deep links land on the new Home.
      if (loc == '/dashboard') return '/home';
      if (role == null && !isAuthRoute) return '/welcome';
      if (role == UserRole.partner &&
          !(loc == '/partner' ||
              loc == '/settings' ||
              loc == '/stats' ||
              loc == '/progress' ||
              loc == '/welcome')) {
        return '/partner';
      }
      // Yeni mom kayıtları önce quiz görsün.
      if (role == UserRole.mom &&
          !quizDone &&
          loc != '/fitness-quiz' &&
          loc != '/welcome') {
        return '/fitness-quiz';
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
        path: '/fitness-quiz',
        builder: (_, _) => FitnessQuizScreen(repository: repository),
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
            path: '/home',
            builder: (_, _) => HomeScreen(repository: repository),
          ),
          GoRoute(
            path: '/programs',
            builder: (_, _) => ProgramsScreen(repository: repository),
          ),
          GoRoute(
            path: '/nutrition',
            builder: (_, _) => NutritionScreen(repository: repository),
          ),
          GoRoute(
            path: '/stats',
            builder: (_, _) => StatsScreen(repository: repository),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => ProfileScreen(repository: repository),
          ),
        ],
      ),
      // Legacy mama-baby tools — pushed from Profile > Mama Araçları or
      // launched from notifications / widgets. Each has its own AppBar.
      GoRoute(
        path: '/dashboard',
        builder: (_, _) => DashboardScreen(repository: repository),
      ),
      GoRoute(
        path: '/feeding',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Beslenme logları')),
          body: FeedingScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/mood',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Mood günlüğü')),
          body: MoodScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/sleep',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Uyku takibi')),
          body: SleepScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/exercise',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Egzersiz')),
          body: ExerciseHubScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/breathing',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Nefes egzersizi')),
          body: const BreathingScreen(),
        ),
      ),
      GoRoute(
        path: '/videos',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Videolar')),
          body: VideosScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/community',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Topluluk')),
          body: const CommunityScreen(),
        ),
      ),
      GoRoute(
        path: '/progress',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('İlerleme (klasik)')),
          body: ProgressScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/reminders',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Hatırlatıcılar')),
          body: RemindersScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Ayarlar')),
          body: SettingsScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/more',
        builder: (_, _) => const Scaffold(
          body: MoreScreen(),
        ),
      ),
      GoRoute(
        path: '/recovery',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Recovery zaman çizelgesi')),
          body: RecoveryTimelineScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/milestones',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Bebek gelişim adımları')),
          body: BabyMilestonesScreen(repository: repository),
        ),
      ),
      GoRoute(
        path: '/kegel',
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('Kegel egzersizleri')),
          body: const KegelScreen(),
        ),
      ),
      // FitMama yeni mockup ekranları
      GoRoute(
        path: '/programs/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? 'core-recovery';
          final title = state.uri.queryParameters['title'] ?? 'Program detay';
          return WorkoutDetailScreen(
            programId: id,
            title: title,
            repository: repository,
          );
        },
      ),
      GoRoute(
        path: '/programs/:id/play/:level',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? 'core-recovery';
          final lvl = int.tryParse(state.pathParameters['level'] ?? '0') ?? 0;
          return WorkoutPlayerScreen(
            repository: repository,
            programId: id,
            levelIndex: lvl,
          );
        },
      ),
      GoRoute(
        path: '/nutrition/ai',
        builder: (_, _) => const AiFoodAnalyzerScreen(),
      ),
      GoRoute(
        path: '/stats/muscles',
        builder: (_, _) => const MuscleDetailScreen(),
      ),
      GoRoute(
        path: '/challenges',
        builder: (_, _) => const ChallengesScreen(),
      ),
      GoRoute(
        path: '/activity',
        builder: (_, _) => const ActivityScreen(),
      ),
      GoRoute(
        path: '/profile/goals',
        builder: (_, _) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (_, state) =>
            SearchScreen(initialQuery: state.uri.queryParameters['q'] ?? ''),
      ),
      GoRoute(
        path: '/nutrition/recipes',
        builder: (_, state) => RecipesListScreen(
          title: state.uri.queryParameters['title'] ?? 'Tüm tarifler',
        ),
      ),
      GoRoute(
        path: '/nutrition/favorites',
        builder: (_, _) => const FavoriteRecipesScreen(),
      ),
      GoRoute(
        path: '/nutrition/recipe',
        builder: (_, state) => RecipeDetailScreen(
          title: state.uri.queryParameters['title'] ?? 'Tarif',
        ),
      ),
      GoRoute(
        path: '/nutrition/blog',
        builder: (_, _) => const BlogListScreen(),
      ),
      GoRoute(
        path: '/nutrition/blog/:slug',
        builder: (_, state) =>
            BlogPostScreen(slug: state.pathParameters['slug'] ?? ''),
      ),
      GoRoute(
        path: '/nutrition/shopping',
        builder: (_, _) => const ShoppingListScreen(),
      ),
      GoRoute(
        path: '/programs/list',
        builder: (_, state) => ProgramsListScreen(
          title: state.uri.queryParameters['title'] ?? 'Tüm programlar',
          repository: repository,
        ),
      ),
      GoRoute(
        path: '/programs/favorites',
        builder: (_, _) => FavoriteWorkoutsScreen(repository: repository),
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
      backgroundColor: scheme.surface,
      body: const Center(
        child: FitmamaLogo(size: FitmamaLogoSize.large),
      ),
    );
  }
}
