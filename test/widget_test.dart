// Basic smoke tests for ConferenceHub's Day 1 booking list screen.
//
// These confirm the app boots, shows the app bar title, and renders the
// hardcoded booking cards defined in BookingsScreen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conferencebookingsystemflutter/main.dart';

void main() {
  testWidgets('ConferenceHub renders the app bar and booking cards', (
    WidgetTester tester,
  ) async {
    // The default test surface is only 600 logical pixels tall, which isn't
    // enough to lay out all four cards inside the ListView -- widgets
    // scrolled out of view aren't built, so find.text() can't see them.
    // Use a taller virtual screen so every card renders without scrolling.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Build the app and let the first frame render.
    await tester.pumpWidget(const ConferenceHubApp());

    // The app bar title should be visible.
    expect(find.text('ConferenceHub'), findsOneWidget);

    // All four hardcoded meetings from BookingsScreen should render.
    expect(find.text('Engineering Standup'), findsOneWidget);
    expect(find.text('New Hire Onboarding'), findsOneWidget);
    expect(find.text('Q3 Sprint Planning'), findsOneWidget);
    expect(find.text('Focus Time (1:1 Feedback)'), findsOneWidget);

    // Each card should show its room's capacity chip.
    expect(find.text('Seats 12'), findsOneWidget);
    expect(find.text('Seats 20'), findsOneWidget);
    expect(find.text('Seats 10'), findsOneWidget);
    expect(find.text('Seats 2'), findsOneWidget);

    // Assignment 1.1, Part B2: canFit chips render both states.
    // Engineering Standup (capacity 12, requiredHeadcount 8) fits.
    expect(find.text('Fits 8 people'), findsOneWidget);
    // New Hire Onboarding (capacity 20, requiredHeadcount 25) does not,
    // and neither does the under-maintenance Focus Pod -- two red chips.
    expect(find.text('Too small'), findsNWidgets(2));

    // Assignment 1.1, Part B1: the Focus Pod booking uses
    // Room.underMaintenance(), so its "Unavailable" chip must be visible.
    expect(find.text('Unavailable'), findsOneWidget);
  });
}
