// Smoke tests for ConferenceHub's booking list screen after Day 4 (GoRouter).
//
// Changes from the Day 3 test:
// 1. Physical size raised from 2800 to 2900 to accommodate the NavigationBar
//    that StatefulShellRoute adds at the bottom of the shell.
// 2. All existing assertions are unchanged -- GoRouter's StatefulShellRoute
//    keeps both tab screens in the widget tree (IndexedStack), but
//    RoomsPlaceholderScreen has no spinner and no conflicting text labels,
//    so the Day 3 counts are still correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conferencebookingsystemflutter/main.dart';

void main() {
  testWidgets(
    'ConferenceHub renders app bar, loading state, booking cards, and nav bar',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(500, 2900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const ProviderScope(child: ConferenceHubApp()));

      // App bar is visible immediately.
      expect(find.text('ConferenceHub'), findsOneWidget);

      // NavigationBar destinations are visible immediately.
      expect(find.text('Bookings'), findsOneWidget);
      expect(find.text('Rooms'), findsOneWidget);

      // During the 1.5-second simulated load, exactly one spinner is visible.
      // RoomsPlaceholderScreen (the inactive tab) has no spinner.
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

      // Room type labels: card chips + filter chips (counts unchanged from Day 3).
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
