// NOTE: this project pins flutter_riverpod to the 2.x line, where
// StateProvider and Provider both live in the main flutter_riverpod.dart
// barrel -- no separate "legacy" import needed (that split is a Riverpod
// 3.0+ thing).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';
import '../models/room.dart';
import 'bookings_notifier.dart';

// -- PROVIDER 1: selectedFilterProvider --------------------------------------
final selectedFilterProvider = StateProvider<String>((ref) => 'All');

// -- PROVIDER 2: filteredBookingsProvider ------------------------------------
// Watches the raw bookings from the notifier and the selected filter chip.
// When either changes, this provider recomputes automatically.
//
// NOTE: with riverpod_generator's 2.x line (pinned in this project), the
// generated provider keeps the full class name -- @riverpod class
// BookingsNotifier produces `bookingsNotifierProvider`. (Generator 4.x
// strips a trailing "Notifier" instead; always check the actual .g.dart
// file rather than assume a naming convention.)
final filteredBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final asyncBookings = ref.watch(bookingsNotifierProvider);
  final filter = ref.watch(selectedFilterProvider);
  return asyncBookings.whenData((bookings) {
    if (filter == 'All') return bookings;
    return bookings.where((b) => b.room.type.displayName == filter).toList();
  });
});
