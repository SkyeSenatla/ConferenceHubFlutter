import 'package:flutter/material.dart';
import '../models/room.dart';

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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meetingTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Room: ${room.name} -- ${room.floor}'),
            Text('Time: $startTime - $endTime'),
            Text('Organiser: $organiser'),
            const SizedBox(height: 8),
            // Wrap (rather than Row) lets chips flow onto a second line
            // instead of overflowing the card on narrow screens.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Shows the room type (e.g. Boardroom, Training, Focus Pod).
                Chip(
                  label: Text(room.type.displayName),
                  backgroundColor: Colors.blue[50],
                ),
                // Shows how many people the room seats.
                Chip(
                  label: Text('Seats ${room.capacity}'),
                  backgroundColor: Colors.grey[100],
                ),
                // Collection-if: only show this chip when the room is
                // actually out of service (Room.underMaintenance rooms).
                if (!room.isAvailable)
                  Chip(
                    label: const Text('Unavailable'),
                    backgroundColor: Colors.orange[100],
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
