// Smoke tests for ConferenceHub's booking list screen (Day 1 + Day 2
// theming/layout work + Assignment 1.1's canFit chips).
//
// These confirm the app boots, shows the app bar title, and renders the
// hardcoded booking cards defined in BookingsScreen with the right content.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conferencebookingsystemflutter/main.dart';

void main() {
  testWidgets('ConferenceHub renders the app bar and booking cards', (
    WidgetTester tester,
  ) async {
    // The default test surface is only 600 logical pixels tall, which isn't
    // enough to lay out all four cards inside the list -- widgets scrolled
    // out of view aren't built, so find.text() can't see them. Use a taller
    // virtual screen so every card renders without scrolling. Staying under
    // 600 logical pixels wide keeps LayoutBuilder on the ListView.builder
    // branch rather than switching to the two-column GridView.
    tester.view.physicalSize = const Size(500, 2600);
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
    expect(find.text('Deep Work Session'), findsOneWidget);

    // Each card should show its room's capacity chip.
    expect(find.text('Seats 12'), findsOneWidget);
    expect(find.text('Seats 20'), findsOneWidget);
    expect(find.text('Seats 10'), findsOneWidget);
    expect(find.text('Seats 2'), findsOneWidget);

    // Each card should show its room type chip with the human-readable
    // RoomType label -- two Boardrooms, one Training, one Focus Pod.
    expect(find.text('Boardroom'), findsNWidgets(2));
    expect(find.text('Training'), findsOneWidget);
    expect(find.text('Focus Pod'), findsOneWidget);

    // Part 4: RoomStatusBadge shows "Available" for the first three rooms
    // and "Unavailable" for the Focus Pod, which uses Room.underMaintenance.
    expect(find.text('Available'), findsNWidgets(3));
    expect(find.text('Unavailable'), findsOneWidget);

    // Assignment 1.1, Part B2: canFit chips render both states.
    // Engineering Standup (capacity 12, requiredHeadcount 8) fits, and so
    // does Q3 Sprint Planning (capacity 10, requiredHeadcount 10, exact fit).
    expect(find.text('Fits 8 people'), findsOneWidget);
    expect(find.text('Fits 10 people'), findsOneWidget);
    // New Hire Onboarding (capacity 20, requiredHeadcount 25) does not,
    // and neither does the under-maintenance Focus Pod -- two red chips.
    expect(find.text('Too small'), findsNWidgets(2));
  });
}
