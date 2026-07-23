import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conferencebookingsystemflutter/models/room.dart';
import 'package:conferencebookingsystemflutter/widgets/room_booking_card.dart';

void main() {
  const testRoom = Room(
    name: 'Boardroom A',
    capacity: 10,
    floor: '3',
    type: RoomType.boardroom,
  );

  Widget buildCard({required int requiredHeadcount}) {
    return MaterialApp(
      home: Scaffold(
        body: RoomBookingCard(
          meetingTitle: 'Sprint Planning',
          room: testRoom,
          startTime: '09:00',
          endTime: '10:00',
          organiser: 'alice@test.com',
          requiredHeadcount: requiredHeadcount,
        ),
      ),
    );
  }

  testWidgets('displays meeting title, room name, and organiser email', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard(requiredHeadcount: 5));

    expect(find.text('Sprint Planning'), findsOneWidget);
    // room.name and organiser are embedded in prefixed strings ("Room: ... --
    // ...", "Organiser: ...") rather than rendered standalone, so an exact
    // find.text() match would fail here -- textContaining is the correct finder.
    expect(find.textContaining('Boardroom A'), findsOneWidget);
    expect(find.textContaining('alice@test.com'), findsOneWidget);
  });

  testWidgets('shows fit chip when headcount is within room capacity', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard(requiredHeadcount: 5));

    expect(find.text('Fits 5 people'), findsOneWidget);
    expect(find.text('Too small'), findsNothing);
  });

  testWidgets('shows too small chip when headcount exceeds room capacity', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard(requiredHeadcount: 15));

    expect(find.text('Too small'), findsOneWidget);
    expect(find.textContaining('Fits'), findsNothing);
  });
}
