import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'package:conferencebookingsystemflutter/main.dart' as app;

void main() {
  patrolTest(
    'user logs in, creates a booking, and sees confirmation',
    config: const PatrolTesterConfig(settleTimeout: Duration(seconds: 10)),
    ($) async {
      // Launch the app. GoRouter will redirect to /login because no token exists.
      app.main();
      await $.pumpAndSettle();

      // Step 1 -- Login screen is visible.
      expect($('ConferenceHub'), findsOneWidget);
      expect($('Sign in'), findsOneWidget);

      // Step 2 -- Enter credentials.
      // This API's seed data (AuthService._users) has no "employee1" account --
      // its hardcoded users are admin, receptionist, facilities, and alice, all
      // with password "password123". alice carries the Employee role.
      await $(find.byType(TextField)).first.enterText('alice');
      await $(find.byType(TextField)).last.enterText('password123');
      await $('Sign in').tap();
      await $.pumpAndSettle();

      // Step 3 -- Handle any OS-level permission dialog before asserting navigation.
      // On first launch, Android may show a notifications permission dialog.
      // NOTE: the guide's tapOnPermissionDialogButton(PermissionDialogButton.allow)
      // does not exist on patrol 3.20.0's NativeAutomator (that API surfaced in a
      // later major) -- grantPermissionWhenInUse() is the 3.x equivalent.
      if (await $.native.isPermissionDialogVisible()) {
        await $.native.grantPermissionWhenInUse();
        await $.pumpAndSettle();
      }

      // Step 4 -- Bookings screen is visible after authentication.
      expect($('ConferenceHub'), findsOneWidget);
      expect($(Icons.logout), findsOneWidget);

      // Step 5 -- Navigate to the create booking form.
      await $(Icons.add).tap();
      await $.pumpAndSettle();

      expect($('New Booking'), findsOneWidget);

      // Step 6 -- Fill the meeting title.
      await $('Meeting title').tap();
      await $('Meeting title').enterText('Patrol Demo Meeting');
      await $.pumpAndSettle();

      // Step 7 -- Select a room from the dropdown.
      await $('Room').tap();
      await $.pumpAndSettle();
      // Tap the first room option that appears in the dropdown menu.
      await $(find.byType(DropdownMenuItem)).first.tap();
      await $.pumpAndSettle();

      // Step 8 -- Set the start time.
      await $('Start time').tap();
      await $.pumpAndSettle();
      // The Material date+time picker is a Flutter widget -- use $() finders.
      // Tap OK to accept the pre-selected current time.
      await $('OK').tap();
      await $.pumpAndSettle();
      // Time picker follows immediately -- tap OK again.
      await $('OK').tap();
      await $.pumpAndSettle();

      // Step 9 -- Set the end time to one hour later.
      await $('End time').tap();
      await $.pumpAndSettle();
      await $('OK').tap();
      await $.pumpAndSettle();
      await $('OK').tap();
      await $.pumpAndSettle();

      // Step 10 -- Set attendee count.
      await $('Number of attendees').tap();
      await $('Number of attendees').enterText('3');
      await $.pumpAndSettle();

      // Step 11 -- Submit the form.
      await $('Create booking').tap();
      await $.pumpAndSettle();

      // Step 12 -- Assert the confirmation SnackBar appeared.
      expect($('Booking "Patrol Demo Meeting" created!'), findsOneWidget);
    },
  );
}
