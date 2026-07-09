// Smoke tests for ConferenceHub's booking list screen after Day 3 (Riverpod).
//
// Changes from the Day 2 test:
// 1. ConferenceHubApp is wrapped in ProviderScope -- required because
//    BookingsScreen is now a ConsumerWidget.
// 2. The async load (1.5s simulated delay) is stepped through with pump().
// 3. Room type chip counts are updated to account for the filter chips that
//    now appear above the list with matching labels.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conferencebookingsystemflutter/main.dart';

void main() {
  testWidgets('ConferenceHub renders app bar, loading state, and booking cards', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(500, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    // ProviderScope is required -- BookingsScreen is a ConsumerWidget.
    await tester.pumpWidget(const ProviderScope(child: ConferenceHubApp()));
    // App bar is visible immediately -- no async needed.
    expect(find.text('ConferenceHub'), findsOneWidget);
    // During the 1.5-second simulated load, a spinner should be visible.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Advance the fake timer past the 1500ms delay in BookingsNotifier.build().
    await tester.pump(const Duration(seconds: 2));
    // Process the widget rebuild triggered by the provider moving to AsyncData.
    await tester.pumpAndSettle();
    // Spinner is gone -- data is loaded.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // All four meetings from the provider should render.
    expect(find.text('Engineering Standup'), findsOneWidget);
    expect(find.text('New Hire Onboarding'), findsOneWidget);
    expect(find.text('Q3 Sprint Planning'), findsOneWidget);
    expect(find.text('Deep Work Session'), findsOneWidget);
    // Capacity chips remain unchanged.
    expect(find.text('Seats 12'), findsOneWidget);
    expect(find.text('Seats 20'), findsOneWidget);
    expect(find.text('Seats 10'), findsOneWidget);
    expect(find.text('Seats 2'), findsOneWidget);
    // Room type labels now appear in BOTH card chips and filter chips:
    // 'Boardroom' appears 2x in cards + 1x in the filter chip row = 3
    // 'Training'  appears 1x in cards + 1x in the filter chip row = 2
    // 'Focus Pod' appears 1x in cards + 1x in the filter chip row = 2
    expect(find.text('Boardroom'), findsNWidgets(3));
    expect(find.text('Training'), findsNWidgets(2));
    expect(find.text('Focus Pod'), findsNWidgets(2));
    // Status badges are unchanged.
    expect(find.text('Available'), findsNWidgets(3));
    expect(find.text('Unavailable'), findsOneWidget);
    // Fit chips are unchanged.
    expect(find.text('Fits 8 people'), findsOneWidget);
    expect(find.text('Fits 10 people'), findsOneWidget);
    expect(find.text('Too small'), findsNWidgets(2));
  });
}
