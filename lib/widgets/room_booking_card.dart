import 'package:flutter/material.dart';
import '../models/room.dart';
import 'room_status_badge.dart';

// A reusable card widget that displays one booking's details.
// StatelessWidget: it has no internal state that changes over time --
// it just renders whatever data is passed into its constructor.
class RoomBookingCard extends StatelessWidget {
  final String meetingTitle;
  final Room room;
  final String startTime;
  final String endTime;
  final String organiser;
  // How many people this specific meeting needs the room to seat.
  // Used to decide whether to show the "Fits" or "Too small" chip below.
  final int requiredHeadcount;

  // `const` constructor lets Flutter cache and reuse this widget instance
  // instead of rebuilding it when nothing has changed.
  const RoomBookingCard({
    super.key,
    required this.meetingTitle,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.organiser,
    required this.requiredHeadcount,
  });

  // Every widget must override build(). It returns the tree of widgets
  // that Flutter actually renders on screen.
  @override
  Widget build(BuildContext context) {
    final bool fits = room.canFit(requiredHeadcount);
    // Theme.of(context) is cheap, but calling it five times in one method
    // is noise -- read it once and reuse it everywhere below.
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meetingTitle,
              // Theme-driven text style instead of a hardcoded TextStyle,
              // so it stays legible in both light and dark mode.
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Room: ${room.name} -- ${room.floor}'),
            Text('Time: $startTime - $endTime'),
            Text('Organiser: $organiser'),
            const SizedBox(height: 8),
            RoomStatusBadge(isAvailable: room.isAvailable),
            const SizedBox(height: 8),
            // Wrap (rather than Row) lets chips flow onto a second line
            // instead of overflowing the card on narrow screens.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Shows the room type (e.g. Boardroom, Training, Focus Pod).
                // secondaryContainer/onSecondaryContainer is the M3 pairing
                // for a labelled chip that needs some visual weight without
                // being as loud as the primary colour -- and it adapts
                // automatically between light and dark theme.
                Chip(
                  label: Text(room.type.displayName),
                  backgroundColor: colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontSize: 12,
                  ),
                ),
                // Shows how many people the room seats.
                Chip(
                  label: Text('Seats ${room.capacity}'),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                // Green when the room can seat requiredHeadcount people,
                // red otherwise (either too small or unavailable).
                Chip(
                  label: Text(
                    fits ? 'Fits $requiredHeadcount people' : 'Too small',
                  ),
                  backgroundColor: fits ? Colors.green[50] : Colors.red[50],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
