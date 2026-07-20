import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/api_result.dart';
import '../data/rooms_repository.dart';
import '../models/room.dart';

part 'rooms_notifier.g.dart';

@riverpod
class RoomsNotifier extends _$RoomsNotifier {
  @override
  Future<List<Room>> build() async {
    final repo = ref.read(roomsRepositoryProvider);

    // Serve the cache immediately if it has data. This assignment overrides
    // the initial AsyncLoading state so the UI shows rooms before the
    // network request starts.
    final cached = await repo.getCachedRooms();
    if (cached.isNotEmpty) {
      state = AsyncData(cached);
    }

    // Fetch fresh data from the API. On success, Isar is updated and
    // build() returns the network list. On failure with a warm cache,
    // return the cache so the UI stays usable.
    final result = await repo.fetchAndCacheRooms();
    return switch (result) {
      Success(:final data) => data,
      Failure(:final message) =>
        cached.isNotEmpty ? cached : throw Exception(message),
    };
  }
}
