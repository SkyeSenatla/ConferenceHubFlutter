import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/room_booking_card.dart';

// The full-page view the user sees when the app opens.
// Scaffold gives us the standard app-bar + body layout for free.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  // Not `const` -- Room.underMaintenance() (used by the last booking below)
  // isn't a const constructor, so the list itself can only be `final`.
  static final _bookings = <_Booking>[
    _Booking(
      meetingTitle: 'Engineering Standup',
      room: const Room(
        name: 'Boardroom A',
        capacity: 12,
        floor: 'Floor 3',
        type: RoomType.boardroom,
      ),
      startTime: '09:00',
      endTime: '09:30',
      organiser: 'Skye Dlamini',
      requiredHeadcount: 8, // fits -- green chip
    ),
    _Booking(
      meetingTitle: 'New Hire Onboarding',
      room: const Room(
        name: 'Training Room 1',
        capacity: 20,
        floor: 'Floor 1',
        type: RoomType.trainingRoom,
      ),
      startTime: '10:00',
      endTime: '12:00',
      organiser: 'HR Team',
      requiredHeadcount: 25, // too big -- red chip
    ),
    _Booking(
      meetingTitle: 'Q3 Sprint Planning',
      room: const Room(
        name: 'Boardroom B',
        capacity: 10,
        floor: 'Floor 3',
        type: RoomType.boardroom,
      ),
      startTime: '13:00',
      endTime: '14:00',
      organiser: 'Product Team',
      requiredHeadcount: 10, // fits exactly -- green chip
    ),
    _Booking(
      meetingTitle: 'Deep Work Session',
      room: Room.underMaintenance(
        name: 'Focus Pod 1',
        capacity: 2,
        floor: 'Floor 2',
        type: RoomType.focusPod,
      ),
      startTime: '14:00',
      endTime: '16:00',
      organiser: 'Dev Team',
      requiredHeadcount: 1, // unavailable, so this still reads "Too small"
    ),
  ];

  // Builds one card for the item at `index`. Passed by reference to
  // ListView.builder/GridView.builder below -- both only call this for
  // items currently visible on screen (lazy rendering).
  Widget _buildCard(BuildContext context, int index) {
    final booking = _bookings[index];
    return RoomBookingCard(
      meetingTitle: booking.meetingTitle,
      room: booking.room,
      startTime: booking.startTime,
      endTime: booking.endTime,
      organiser: booking.organiser,
      requiredHeadcount: booking.requiredHeadcount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConferenceHub'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // LayoutBuilder responds to the space actually given to this widget --
      // a two-column grid on medium+ widths (tablets, landscape), a single
      // scrolling list below that (phones in portrait).
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _bookings.length,
              itemBuilder: _buildCard,
            );
          }
          return ListView.builder(
            itemCount: _bookings.length,
            itemBuilder: _buildCard,
          );
        },
      ),
    );
  }
}

// Private to this file (leading underscore) -- not a public model, just a
// holder for the screen's own hardcoded data. The real public model is Room.
class _Booking {
  final String meetingTitle;
  final Room room;
  final String startTime;
  final String endTime;
  final String organiser;
  final int requiredHeadcount;

  const _Booking({
    required this.meetingTitle,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.organiser,
    required this.requiredHeadcount,
  });
}
