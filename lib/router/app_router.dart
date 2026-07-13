import 'package:go_router/go_router.dart';
import '../screens/bookings_screen.dart';
import '../screens/booking_detail_screen.dart';
import '../screens/rooms_placeholder_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/bookings',
  routes: [
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
                    final id = int.parse(state.pathParameters['id']!);
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
              builder: (context, state) => const RoomsPlaceholderScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
