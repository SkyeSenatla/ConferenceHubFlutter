import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/booking.dart';
import '../models/room.dart';
import 'bookings_notifier.dart';

// -- PROVIDER 1: selectedFilterProvider --------------------------------------
final selectedFilterProvider = StateProvider<String>((ref) => 'All');

// -- PROVIDER 2: filteredBookingsProvider ------------------------------------
// Watches the raw bookings from the notifier and the selected filter chip.
// When either changes, this provider recomputes automatically.
//
// NOTE: riverpod_generator 4.x strips a trailing "Notifier" from the class
// name -- @riverpod class BookingsNotifier now produces `bookingsProvider`,
// not `bookingsNotifierProvider`. Always check the actual .g.dart file
// rather than assume a naming convention.
final filteredBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final asyncBookings = ref.watch(bookingsProvider);
  final filter = ref.watch(selectedFilterProvider);
  return asyncBookings.whenData((bookings) {
    if (filter == 'All') return bookings;
    return bookings.where((b) => b.room.type.displayName == filter).toList();
  });
});
