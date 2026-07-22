import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/booking.dart';
import '../providers/auth_notifier.dart';
import '../providers/bookings_notifier.dart';
import '../providers/bookings_provider.dart';
import '../providers/rooms_notifier.dart';
import '../widgets/bookings_shimmer.dart';
import '../widgets/room_booking_card.dart';

// BookingsScreen no longer watches any provider -- it owns the Scaffold,
// AppBar and FAB and nothing else, so it builds once and never rebuilds.
// State subscriptions live in _FilterRow and _BookingList below, each
// watching only the provider it actually needs to render.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConferenceHub'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              // Invalidate data providers before calling logout(). If
              // logout() ran first, auth state would flip to
              // Unauthenticated, GoRouter would redirect, and Riverpod
              // would tear down this widget tree -- disposing these
              // providers incidentally rather than intentionally.
              ref.invalidate(bookingsProvider);
              ref.invalidate(roomsProvider);
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/bookings/new'),
        child: const Icon(Icons.add),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_FilterRow(), Expanded(child: _BookingList())],
      ),
    );
  }
}

class _FilterRow extends ConsumerWidget {
  const _FilterRow();

  // The filter chip labels. They match room.type.displayName exactly
  // so the filter logic in filteredBookingsProvider can compare strings directly.
  static const _options = ['All', 'Boardroom', 'Training', 'Focus Pod'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedFilterProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _options.map((option) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(option),
              selected: selected == option,
              // ref.read inside a callback -- one-time write, not a subscription.
              onSelected: (_) {
                ref.read(selectedFilterProvider.notifier).state = option;
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  const _BookingList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBookings = ref.watch(filteredBookingsProvider);
    return asyncBookings.when(
      loading: () => const BookingsShimmer(),
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
              // invalidate forces bookingsProvider to
              // rebuild from scratch, i.e. re-fetch from the API.
              onPressed: () => ref.invalidate(bookingsProvider),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return const Center(child: Text('No bookings match this filter.'));
        }
        // Isolates the scrolling list's compositor layer from the AppBar
        // and filter row above it -- scrolling no longer asks the GPU to
        // re-rasterise widgets that haven't changed.
        return RepaintBoundary(
          child: LayoutBuilder(
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
          ),
        );
      },
    );
  }

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
