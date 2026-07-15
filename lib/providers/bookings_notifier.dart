import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/booking.dart';
import '../data/bookings_repository.dart';
import '../data/api_result.dart';

part 'bookings_notifier.g.dart';

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  @override
  Future<List<Booking>> build() async {
    final result = await ref.read(bookingsRepositoryProvider).getBookings();

    return switch (result) {
      Success(:final data) => data,
      Failure(:final message) => throw Exception(message),
    };
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
