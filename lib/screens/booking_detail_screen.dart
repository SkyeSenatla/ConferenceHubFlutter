import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room.dart';
import '../providers/bookings_provider.dart';

class BookingDetailScreen extends ConsumerWidget {
  final int bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the raw (unfiltered) bookings list.
    // The filtered list changes with the selected chip -- if the user
    // had filtered to 'Boardroom' and navigated to a Focus Pod booking,
    // that booking would not exist in the filtered list. Always use the
    // source provider in a detail screen.
    final asyncBookings = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: asyncBookings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Could not load booking.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        data: (bookings) {
          final matches = bookings.where((b) => b.id == bookingId);
          if (matches.isEmpty) {
            return const Center(child: Text('Booking not found.'));
          }
          final booking = matches.first;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                booking.meetingTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _DetailRow(
                icon: Icons.meeting_room_outlined,
                label: 'Room',
                value: '${booking.room.name} · ${booking.room.floor}',
              ),
              _DetailRow(
                icon: Icons.category_outlined,
                label: 'Type',
                value: booking.room.type.displayName,
              ),
              _DetailRow(
                icon: Icons.chair_outlined,
                label: 'Capacity',
                value: '${booking.room.capacity} seats',
              ),
              _DetailRow(
                icon: Icons.schedule_outlined,
                label: 'Time',
                value: '${booking.startTime} – ${booking.endTime}',
              ),
              _DetailRow(
                icon: Icons.person_outline,
                label: 'Organiser',
                value: booking.organiserEmail,
              ),
              _DetailRow(
                icon: Icons.group_outlined,
                label: 'Attendees',
                value: '${booking.requiredHeadcount} people',
              ),
              const SizedBox(height: 24),
              Chip(
                label: Text(
                  booking.room.isAvailable
                      ? 'Room Available'
                      : 'Room Unavailable',
                ),
                backgroundColor: booking.room.isAvailable
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.errorContainer,
                labelStyle: TextStyle(
                  color: booking.room.isAvailable
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
