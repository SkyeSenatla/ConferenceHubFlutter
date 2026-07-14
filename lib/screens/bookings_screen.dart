import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/booking.dart';
import '../providers/bookings_notifier.dart';
import '../providers/bookings_provider.dart';
import '../widgets/room_booking_card.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});
  // The filter chip labels. They match room.type.displayName exactly
  // so the filter logic in filteredBookingsProvider can compare strings directly.
  static const _filterOptions = ['All', 'Boardroom', 'Training', 'Focus Pod'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch subscribes this widget to both providers.
    // When either changes, build() runs again -- only this widget, nothing else.
    final asyncBookings = ref.watch(filteredBookingsProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConferenceHub'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chip row -- horizontally scrollable so it works on narrow phones.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _filterOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(option),
                    selected: selectedFilter == option,
                    // ref.read inside a callback -- one-time write, not a subscription.
                    onSelected: (_) {
                      ref.read(selectedFilterProvider.notifier).state = option;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // The booking list fills whatever space is left after the filter row.
          Expanded(
            child: asyncBookings.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Could not load bookings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      // invalidate forces bookingsProvider (generated from
                      // BookingsNotifier) to rebuild from scratch, i.e.
                      // re-fetch from the API.
                      onPressed: () => ref.invalidate(bookingsProvider),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
              data: (bookings) {
                if (bookings.isEmpty) {
                  return const Center(
                    child: Text('No bookings match this filter.'),
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 600) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) =>
                            _buildCard(context, index, bookings),
                      );
                    }
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) =>
                          _buildCard(context, index, bookings),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // buildCard now accepts the bookings list as a parameter because the list
  // comes from the provider, not a static field on this class.
  Widget _buildCard(BuildContext context, int index, List<Booking> bookings) {
    final booking = bookings[index];
    // Navigate with the booking's stable id, never the list index -- the
    // index shifts whenever the filter changes, but the id never does.
    return GestureDetector(
      onTap: () => context.push('/bookings/${booking.id}'),
      child: RoomBookingCard(
        meetingTitle: booking.meetingTitle,
        room: booking.room,
        startTime: booking.startTime,
        endTime: booking.endTime,
        organiser: booking.organiserEmail,
        requiredHeadcount: booking.requiredHeadcount,
      ),
    );
  }
}
