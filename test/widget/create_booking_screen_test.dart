import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conferencebookingsystemflutter/models/room.dart';
import 'package:conferencebookingsystemflutter/providers/rooms_notifier.dart';
import 'package:conferencebookingsystemflutter/screens/create_booking_screen.dart';

class _FakeRoomsNotifier extends RoomsNotifier {
  @override
  Future<List<Room>> build() async {
    return const [
      Room(name: 'Boardroom A', capacity: 10, floor: '3', type: RoomType.boardroom),
      Room(name: 'Focus Pod 1', capacity: 2, floor: '1', type: RoomType.focusPod),
    ];
  }
}

Widget _buildSubject() {
  return ProviderScope(
    overrides: [roomsProvider.overrideWith(_FakeRoomsNotifier.new)],
    child: const MaterialApp(home: CreateBookingScreen()),
  );
}

void main() {
  testWidgets('shows required validation errors when form is submitted empty', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create booking'));
    await tester.pumpAndSettle();

    // required() fires for every unfilled field simultaneously. Its default
    // message (form_builder_validators 11.x, package:l10n/intl_en.arb) is
    // "This field cannot be empty." -- there is no literal word "required"
    // to search for, unlike in some other validation libraries.
    expect(find.textContaining('cannot be empty'), findsWidgets);
  });

  testWidgets('shows minLength error when title is too short', (tester) async {
    await tester.pumpWidget(_buildSubject());
    await tester.pumpAndSettle();

    // Enter a title that passes required() but fails minLength(3).
    // FormBuilderTextField renders a plain TextField internally (not a
    // TextFormField) in flutter_form_builder 10.x -- find.widgetWithText
    // must target TextField or this finder matches nothing.
    await tester.enterText(
      find.widgetWithText(TextField, 'Meeting title'),
      'AB',
    );
    await tester.tap(find.text('Create booking'));
    await tester.pumpAndSettle();

    expect(find.textContaining('3'), findsWidgets);
  });
}
