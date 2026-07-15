// Throwaway verification script -- not part of the app or test suite.
// Confirms BookingsRepository.getBookings() parses real API responses
// correctly end-to-end (Dio -> JSON -> DTO -> Booking), and pattern-matches
// on the ApiResult it now returns (Week 2, Day 2).
import 'package:dio/dio.dart';
import 'package:conferencebookingsystemflutter/data/api_result.dart';
import 'package:conferencebookingsystemflutter/data/bookings_repository.dart';
import 'package:conferencebookingsystemflutter/models/room.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:5247'));
  final repo = BookingsRepository(dio);
  final result = await repo.getBookings();

  switch (result) {
    case Success(:final data):
      // ignore: avoid_print
      print('Parsed ${data.length} bookings from the live API:');
      for (final b in data) {
        // ignore: avoid_print
        print(
          '${b.id} | ${b.meetingTitle} | ${b.room.name} (${b.room.type.displayName}) '
          '| ${b.startTime}-${b.endTime} | ${b.organiserEmail} | ${b.requiredHeadcount}',
        );
      }
    case Failure(:final message, :final statusCode):
      // ignore: avoid_print
      print('Failure: $message (status: $statusCode)');
  }
}
