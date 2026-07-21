import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_provider.dart';
import '../screens/bookings_screen.dart';
import '../screens/booking_detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/rooms_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final listenable = ref.watch(authStateListenableProvider);
  return GoRouter(
    initialLocation: '/bookings',
    refreshListenable: listenable,
    redirect: (context, state) {
      // ref.read, not ref.watch: refreshListenable already makes GoRouter
      // re-evaluate this callback whenever auth state changes. Watching here
      // too would make appRouterProvider itself rebuild on every auth
      // change, recreating the GoRouter instance and destroying navigation
      // history.
      final auth = ref.read(authProvider);
      if (auth.isLoading) return null;
      final isAuthenticated = auth.value is Authenticated;
      final isOnLogin = state.matchedLocation == '/login';
      if (!isAuthenticated && !isOnLogin) return '/login';
      if (isAuthenticated && isOnLogin) return '/bookings';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          // BRANCH 0 -- Bookings tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                builder: (context, state) => const BookingsScreen(),
                routes: [
                  // Child route: booking detail -- /bookings/:id
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      // Booking ids are Guids from the API -- always String.
                      final id = state.pathParameters['id']!;
                      return BookingDetailScreen(bookingId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // BRANCH 1 -- Rooms tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rooms',
                builder: (context, state) => const RoomsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
