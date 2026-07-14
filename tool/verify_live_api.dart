// Throwaway verification script -- not part of the app or test suite.
// Confirms BookingsRepository.getBookings() parses real API responses
// correctly end-to-end (Dio -> JSON -> DTO -> Booking).
import 'package:dio/dio.dart';
import 'package:conferencebookingsystemflutter/data/bookings_repository.dart';
import 'package:conferencebookingsystemflutter/models/room.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:5247'));
  final repo = BookingsRepository(dio);
  final bookings = await repo.getBookings();
  print('Parsed ${bookings.length} bookings from the live API:');
  for (final b in bookings) {
    print(
      '${b.id} | ${b.meetingTitle} | ${b.room.name} (${b.room.type.displayName}) '
      '| ${b.startTime}-${b.endTime} | ${b.organiserEmail} | ${b.requiredHeadcount}',
    );
  }
}
