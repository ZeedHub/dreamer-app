import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/dreams/presentation/screens/dream_feed_screen.dart';
import '../../features/dreams/presentation/screens/dream_detail_screen.dart';
import '../../features/dreams/presentation/screens/create_dream_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/astro_setup_screen.dart';
import '../../features/interpretation/presentation/screens/interpretation_screen.dart';
import '../../features/analytics/presentation/screens/analytics_dashboard_screen.dart';
import '../../features/social/presentation/screens/comments_screen.dart';

// Route names
class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String dreamFeed = '/dreams';
  static const String dreamDetail = '/dreams/:id';
  static const String createDream = '/dreams/create';
  static const String editDream = '/dreams/:id/edit';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String astroSetup = '/profile/astro-setup';
  static const String interpretation = '/interpretation/:dreamId';
  static const String analytics = '/analytics';
  static const String comments = '/dreams/:id/comments';
}

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  // You can watch auth state here to redirect
  // final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash/Initial Route
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Dream Routes
      GoRoute(
        path: Routes.dreamFeed,
        builder: (context, state) => const DreamFeedScreen(),
      ),
      GoRoute(
        path: '/dreams/:id',
        builder: (context, state) {
          final dreamId = state.pathParameters['id']!;
          return DreamDetailScreen(dreamId: dreamId);
        },
      ),
      GoRoute(
        path: Routes.createDream,
        builder: (context, state) => const CreateDreamScreen(),
      ),
      GoRoute(
        path: '/dreams/:id/edit',
        builder: (context, state) {
          final dreamId = state.pathParameters['id']!;
          return CreateDreamScreen(dreamId: dreamId);
        },
      ),
      
      // Profile Routes
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.astroSetup,
        builder: (context, state) => const AstroSetupScreen(),
      ),
      
      // Interpretation Route
      GoRoute(
        path: '/interpretation/:dreamId',
        builder: (context, state) {
          final dreamId = state.pathParameters['dreamId']!;
          return InterpretationScreen(dreamId: dreamId);
        },
      ),
      
      // Analytics Route
      GoRoute(
        path: Routes.analytics,
        builder: (context, state) => const AnalyticsDashboardScreen(),
      ),
      
      // Social Routes
      GoRoute(
        path: '/dreams/:id/comments',
        builder: (context, state) {
          final dreamId = state.pathParameters['id']!;
          return CommentsScreen(dreamId: dreamId);
        },
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
