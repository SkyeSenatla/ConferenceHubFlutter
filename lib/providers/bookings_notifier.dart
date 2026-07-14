import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/booking.dart';
import '../data/bookings_repository.dart';
part 'bookings_notifier.g.dart';

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  @override
  Future<List<Booking>> build() async {
    return ref.read(bookingsRepositoryProvider).getBookings();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
