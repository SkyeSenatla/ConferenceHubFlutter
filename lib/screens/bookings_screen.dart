import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/room_booking_card.dart';

// The full-page view the user sees when the app opens.
// Scaffold gives us the standard app-bar + body layout for free.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Room.underMaintenance() is not const (it delegates to the default
    // constructor via an initializer list), so it's built once here rather
    // than inline, and the card that uses it can't be marked const either.
    final Room focusPod = Room.underMaintenance(
      name: 'Focus Pod 3',
      capacity: 2,
      floor: 'Floor 2',
      type: RoomType.focusPod,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ConferenceHub'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // ListView makes its children scrollable if they overflow the screen.
      // These bookings are hardcoded for Day 1 -- Week 2 replaces this with
      // data fetched from an API.
      body: ListView(
        children: [
          // Room(...) and RoomBookingCard(...) are both marked const here:
          // every argument is a compile-time literal, so Flutter can build
          // this card once and reuse the same instance on every rebuild.
          const RoomBookingCard(
            meetingTitle: 'Engineering Standup',
            room: Room(
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
          const RoomBookingCard(
            meetingTitle: 'New Hire Onboarding',
            room: Room(
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
          const RoomBookingCard(
            meetingTitle: 'Q3 Sprint Planning',
            room: Room(
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
          // Fourth booking: a small Focus Pod that is under maintenance,
          // so it renders as Unavailable regardless of requiredHeadcount.
          RoomBookingCard(
            meetingTitle: 'Focus Time (1:1 Feedback)',
            room: focusPod,
            startTime: '15:00',
            endTime: '15:30',
            organiser: 'Skye Dlamini',
            requiredHeadcount: 1,
          ),
        ],
      ),
    );
  }
}
