import 'package:dio/dio.dart';
// Ref comes from plain riverpod, not flutter_riverpod -- this file is data
// layer, not UI, so it shouldn't need Flutter (and importing
// flutter_riverpod here pulls in dart:ui, which breaks plain `dart run`
// scripts and any pure-Dart usage of this repository).
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/booking.dart';
import '../models/room.dart';
import 'api_result.dart';
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

  Future<ApiResult<List<Booking>>> getBookings() async {
    try {
      // Fetch bookings and rooms in parallel -- one network round trip, not two.
      final responses = await Future.wait([
        _dio.get<dynamic>('/api/bookings'),
        _dio.get<dynamic>('/api/rooms'),
      ]);

      final (:bookings, :rooms) = _parseResponses(responses);

      final roomMap = rooms.fold<Map<String, Room>>(
        {},
        (map, room) => map..[room.name] = room,
      );

      final result = bookings.map((dto) {
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

      return Success(result);
    } on DioException catch (e) {
      return Failure(
        _messageFromDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      return Failure('An unexpected error occurred.');
    }
  }

  // Named record: bundles both parsed lists into one lightweight, type-safe
  // return value with no class declaration needed.
  ({List<BookingDto> bookings, List<Room> rooms}) _parseResponses(
    List<Response<dynamic>> results,
  ) {
    return (
      bookings: (results[0].data['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(BookingDto.fromJson)
          .toList(),
      rooms: (results[1].data as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Room.fromJson)
          .toList(),
    );
  }

  String _messageFromDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout =>
        'Connection timed out. Check your network.',
      DioExceptionType.receiveTimeout => 'The server took too long to respond.',
      DioExceptionType.connectionError => 'Could not reach the server.',
      DioExceptionType.badResponse => 'Server error ${e.response?.statusCode}.',
      _ => 'Network error. Please try again.',
    };
  }
}
