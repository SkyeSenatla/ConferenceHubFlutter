import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';
import '../models/room.dart';

// --------------------------------------------------------------------------
// The hardcoded data -- will be replaced by an API call in Week 2.
// Not const because Room.underMaintenance() is not a const constructor.
// --------------------------------------------------------------------------
final _allBookings = <Booking>[
  const Booking(
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
  Booking(
    meetingTitle: 'Deep Work Session',
    room: Room.underMaintenance(
      name: 'Focus Pod 1',
      capacity: 2,
      floor: 'Floor 2',
      type: RoomType.focusPod,
    ),
    startTime: '14:00',
    endTime: '16:00',
    organiserEmail: 'Dev Team',
    requiredHeadcount: 1,
  ),
];

// --------------------------------------------------------------------------
// PROVIDER 1: bookingsProvider
// AsyncNotifier simulates a 1.5-second network round-trip.
// In Week 2 this is where the real HTTP call will go.
// --------------------------------------------------------------------------
class BookingsNotifier extends AsyncNotifier<List<Booking>> {
  @override
  Future<List<Booking>> build() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _allBookings;
  }
}

final bookingsProvider = AsyncNotifierProvider<BookingsNotifier, List<Booking>>(
  BookingsNotifier.new,
);
// --------------------------------------------------------------------------
// PROVIDER 2: selectedFilterProvider
// Holds the currently selected filter chip label as a plain String.
// Default is 'All' -- show every booking.
// --------------------------------------------------------------------------
final selectedFilterProvider = StateProvider<String>((ref) => 'All');
// --------------------------------------------------------------------------
// PROVIDER 3: filteredBookingsProvider
// Derived state. Watches both providers above.
// When either changes, this recomputes automatically.
// The widget never needs to manually synchronise these two values.
// --------------------------------------------------------------------------
final filteredBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final asyncBookings = ref.watch(bookingsProvider);
  final filter = ref.watch(selectedFilterProvider);
  // whenData only runs the transform when bookings are loaded.
  // Loading and error states pass through unchanged.
  return asyncBookings.whenData((bookings) {
    if (filter == 'All') return bookings;
    return bookings.where((b) => b.room.type.displayName == filter).toList();
  });
});
