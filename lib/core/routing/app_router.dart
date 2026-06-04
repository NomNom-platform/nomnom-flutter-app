import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/recommendation/recommendations_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/notification/notifications_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/health_profile_setup_screen.dart';
import '../../features/order/track_order_screen.dart';
import '../../features/cart/checkout_screen.dart';
import '../../features/restaurant/restaurant_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/health-setup',
      builder: (context, state) => const HealthProfileSetupScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return _ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/for-you',
          builder: (context, state) => const RecommendationsScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
          routes: [
            GoRoute(
              path: 'checkout',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const CheckoutScreen(),
            ),
          ]
        ),
        GoRoute(
          path: '/inbox',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/track-order',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TrackOrderScreen(),
    ),
    GoRoute(
      path: '/restaurant/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RestaurantDetailScreen(),
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/for-you')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/inbox')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/for-you');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/inbox');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Basic navigation shell for bottom nav logic. The actual bottom nav UI
    // imports the shared component.
    return Scaffold(
      body: child,
      // The design specifies a custom bottom nav bar, we'll implement it within
      // each screen for more control or use a shared scaffold here.
      // Since it's a prototype, we can use the shared widget here.
    );
  }
}
