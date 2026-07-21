import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room.dart';
import '../providers/connectivity_provider.dart';
import '../providers/rooms_filter_notifier.dart';
import '../providers/rooms_notifier.dart';

class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRooms = ref.watch(roomsProvider);
    final isOffline = ref.watch(isOfflineProvider);
    final showAvailableOnly = ref.watch(roomsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Available only',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Switch(
                  value: showAvailableOnly,
                  onChanged: (_) =>
                      ref.read(roomsFilterProvider.notifier).toggle(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isOffline)
            Container(
              color: Theme.of(context).colorScheme.errorContainer,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 18,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'You are offline — showing cached rooms.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: asyncRooms.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
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
                      'Could not load rooms',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref.invalidate(roomsProvider),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
              data: (rooms) {
                final visible = showAvailableOnly
                    ? rooms.where((r) => r.isAvailable).toList()
                    : rooms;

                if (visible.isEmpty) {
                  return const Center(
                    child: Text('No rooms match this filter.'),
                  );
                }

                return ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final room = visible[index];
                    return ListTile(
                      leading: Icon(
                        room.isAvailable
                            ? Icons.meeting_room
                            : Icons.do_not_disturb_on,
                        color: room.isAvailable
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                      title: Text(room.name),
                      subtitle: Text(
                        '${room.type.displayName} · ${room.floor} · ${room.capacity} seats',
                      ),
                      trailing: Chip(
                        label: Text(
                          room.isAvailable ? 'Available' : 'Unavailable',
                        ),
                        backgroundColor: room.isAvailable
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.errorContainer,
                      ),
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
}
