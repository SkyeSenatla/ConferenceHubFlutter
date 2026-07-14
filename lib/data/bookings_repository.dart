import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/booking.dart';
import '../models/room.dart';
import 'booking_dto.dart';

part 'bookings_repository.g.dart';
// -- Dio provider ------------------------------------------------------------
// Created once per ProviderScope. Every class that needs Dio receives the
// same configured instance via ref.watch(dioProvider).

@riverpod
Dio dio(Ref ref) {
  // Read the base URL from the build environment.
  // Pass it at run time: flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5247
  // The default targets the Android emulator's alias for the host machine's localhost.
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5247',
  );
  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  );
  final client = Dio(options);
  // LogInterceptor prints every request URL and response status to the console.
  // It is added unconditionally here for the demo. In production, gate it on
  // kDebugMode or an environment flag so it is absent from release builds.
  client.interceptors.add(
    LogInterceptor(requestBody: false, responseBody: false),
  );
  return client;
}

// -- Repository provider ------------------------------------------------------
@riverpod
BookingsRepository bookingsRepository(Ref ref) {
  return BookingsRepository(ref.watch(dioProvider));
}

// -- Repository class ----------------------------------------------------------
class BookingsRepository {
  final Dio _dio;
  const BookingsRepository(this._dio);
  Future<List<Booking>> getBookings() async {
    // Fetch bookings and rooms in parallel -- one network round trip, not two.
    final results = await Future.wait([
      _dio.get<dynamic>('/api/bookings'),
      _dio.get<dynamic>('/api/rooms'),
    ]);
    final bookingList = (results[0].data['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(BookingDto.fromJson)
        .toList();
    final roomMap = (results[1].data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Room.fromJson)
        .fold<Map<String, Room>>({}, (map, room) {
          map[room.name] = room;
          return map;
        });
    return bookingList.map((dto) {
      final room =
          roomMap[dto.roomName] ??
          Room(
            name: dto.roomName,
            capacity: dto.attendeeCount,
            floor: dto.floor,
            type: RoomType.boardroom,
          );
      return Booking.fromDto(dto, room);
    }).toList();
  }
}
