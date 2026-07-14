import 'package:flutter_riverpod/flutter_riverpod.dart';
// StateProvider was moved out of the main flutter_riverpod.dart barrel in
// Riverpod 3.0 -- it now lives in this "legacy" import alongside Provider's
// other classic (non-code-gen) provider types.
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
// NOTE: riverpod_generator strips a trailing "Notifier" from the class name
// when it generates the provider variable, so @riverpod class
// BookingsNotifier produces `bookingsProvider`, not `bookingsNotifierProvider`.
// See lib/providers/bookings_notifier.g.dart.
final filteredBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final asyncBookings = ref.watch(bookingsProvider);
  final filter = ref.watch(selectedFilterProvider);
  return asyncBookings.whenData((bookings) {
    if (filter == 'All') return bookings;
    return bookings.where((b) => b.room.type.displayName == filter).toList();
  });
});
