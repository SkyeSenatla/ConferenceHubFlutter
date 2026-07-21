// Smoke tests for ConferenceHub's booking list screen after Week 2, Day 1+2
// (real HTTP + code generation + Freezed/ApiResult).
//
// Changes from the Day 4 test:
// 1. bookingsProvider now makes a real Dio call to the API. In a
//    test environment there is no server, so the real notifier is
//    overridden with a fake one that returns the same hardcoded dataset
//    this test has always asserted on. No network call is made, no Dio
//    instance is created, no HTTP permission is needed.
// 2. The fake notifier bypasses ApiResult entirely -- it overrides build()
//    directly with a List<Booking>, the same shape Riverpod expects,
//    without ever calling the repository.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conferencebookingsystemflutter/main.dart';
import 'package:conferencebookingsystemflutter/models/auth_state.dart';
import 'package:conferencebookingsystemflutter/models/booking.dart';
import 'package:conferencebookingsystemflutter/models/room.dart';
import 'package:conferencebookingsystemflutter/models/user.dart';
import 'package:conferencebookingsystemflutter/providers/auth_notifier.dart';
import 'package:conferencebookingsystemflutter/providers/bookings_notifier.dart';

// -- Fake notifier -----------------------------------------------------------
// Returns the same hardcoded dataset the widget test has always asserted on.
// No network call is made. No Dio instance is created. No HTTP permission needed.
class _FakeBookingsNotifier extends BookingsNotifier {
  @override
  Future<List<Booking>> build() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _fakeBookings;
  }
}

// Auth now gates every screen behind /login, so the widget test needs a
// fake AuthNotifier that resolves straight to Authenticated -- otherwise
// GoRouter's redirect sends the test to the login screen instead of
// bookings, and none of the assertions below would find their targets.
class _FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async {
    return const Authenticated(user: User(username: 'testuser', role: 'Employee'));
  }
}

final _fakeBookings = <Booking>[
  const Booking(
    id: '1',
    meetingTitle: 'Engineering Standup',
    room: Room(
      name: 'Boardroom A',
      capacity: 12,
      floor: 'Floor 3',
      type: RoomType.boardroom,
    ),
    startTime: '09:00',
    endTime: '09:30',
    organiserEmail: 'Skye Dlamini',
    requiredHeadcount: 8,
  ),
  const Booking(
    id: '2',
    meetingTitle: 'New Hire Onboarding',
    room: Room(
      name: 'Training Room 1',
      capacity: 20,
      floor: 'Floor 1',
      type: RoomType.trainingRoom,
    ),
    startTime: '10:00',
    endTime: '12:00',
    organiserEmail: 'HR Team',
    requiredHeadcount: 25,
  ),
  const Booking(
    id: '3',
    meetingTitle: 'Q3 Sprint Planning',
    room: Room(
      name: 'Boardroom B',
      capacity: 10,
      floor: 'Floor 3',
      type: RoomType.boardroom,
    ),
    startTime: '13:00',
    endTime: '14:00',
    organiserEmail: 'Product Team',
    requiredHeadcount: 10,
  ),
  const Booking(
    id: '4',
    meetingTitle: 'Deep Work Session',
    room: Room(
      name: 'Focus Pod 1',
      capacity: 2,
      floor: 'Floor 2',
      type: RoomType.focusPod,
      isAvailable: false,
    ),
    startTime: '14:00',
    endTime: '16:00',
    organiserEmail: 'Dev Team',
    requiredHeadcount: 1,
  ),
];

void main() {
  testWidgets(
    'ConferenceHub renders app bar, loading state, booking cards, and nav bar',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(500, 2900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Replace the real notifier (which calls the API) with the fake.
            // The UI code is untouched -- it still calls
            // ref.watch(bookingsProvider). Only the data source changes.
            bookingsProvider.overrideWith(_FakeBookingsNotifier.new),
            authProvider.overrideWith(_FakeAuthNotifier.new),
          ],
          child: const ConferenceHubApp(),
        ),
      );

      // App bar is visible immediately.
      expect(find.text('ConferenceHub'), findsOneWidget);

      // NavigationBar destinations are visible immediately.
      expect(find.text('Bookings'), findsOneWidget);
      expect(find.text('Rooms'), findsOneWidget);

      // During the 1.5-second simulated load, exactly one spinner is visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance the fake timer past the 1500ms delay.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Spinner is gone.
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // All four meetings render.
      expect(find.text('Engineering Standup'), findsOneWidget);
      expect(find.text('New Hire Onboarding'), findsOneWidget);
      expect(find.text('Q3 Sprint Planning'), findsOneWidget);
      expect(find.text('Deep Work Session'), findsOneWidget);

      // Capacity chips.
      expect(find.text('Seats 12'), findsOneWidget);
      expect(find.text('Seats 20'), findsOneWidget);
      expect(find.text('Seats 10'), findsOneWidget);
      expect(find.text('Seats 2'), findsOneWidget);

      // Room type labels: card chips + filter chips.
      expect(find.text('Boardroom'), findsNWidgets(3));
      expect(find.text('Training'), findsNWidgets(2));
      expect(find.text('Focus Pod'), findsNWidgets(2));

      // Status badges.
      expect(find.text('Available'), findsNWidgets(3));
      expect(find.text('Unavailable'), findsOneWidget);

      // Fit chips.
      expect(find.text('Fits 8 people'), findsOneWidget);
      expect(find.text('Fits 10 people'), findsOneWidget);
      expect(find.text('Too small'), findsNWidgets(2));
    },
  );
}
