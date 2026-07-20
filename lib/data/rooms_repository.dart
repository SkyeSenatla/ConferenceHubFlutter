import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/room.dart';
import '../core/isar_provider.dart';
import 'api_result.dart';
import 'bookings_repository.dart';
import 'room_cache.dart';

part 'rooms_repository.g.dart';

@riverpod
RoomsRepository roomsRepository(Ref ref) {
  return RoomsRepository(
    dio: ref.watch(dioProvider),
    isar: ref.watch(isarProvider),
  );
}

class RoomsRepository {
  final Dio _dio;
  final Isar _isar;

  const RoomsRepository({required Dio dio, required Isar isar})
    : _dio = dio,
      _isar = isar;

  Future<List<Room>> getCachedRooms() async {
    final cached = await _isar.roomCaches.where().findAll();
    return cached.map(_toRoom).toList();
  }

  Future<ApiResult<List<Room>>> fetchAndCacheRooms() async {
    try {
      final response = await _dio.get<dynamic>('/api/rooms');
      final rooms = (response.data as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Room.fromJson)
          .toList();

      await _isar.writeTxn(() async {
        await _isar.roomCaches.clear();
        await _isar.roomCaches.putAll(rooms.map(_fromRoom).toList());
      });

      return Success(rooms);
    } on DioException catch (e) {
      return Failure(_dioMessage(e), statusCode: e.response?.statusCode);
    } catch (_) {
      return Failure('An unexpected error occurred.');
    }
  }

  Room _toRoom(RoomCache cache) {
    return Room(
      name: cache.name,
      capacity: cache.capacity,
      floor: cache.floor,
      type: RoomType.values.firstWhere(
        (t) => t.name == cache.typeName,
        orElse: () => RoomType.boardroom,
      ),
      isAvailable: cache.isAvailable,
    );
  }

  RoomCache _fromRoom(Room room) => RoomCache()
    ..name = room.name
    ..capacity = room.capacity
    ..floor = room.floor
    ..typeName = room.type.name
    ..isAvailable = room.isAvailable;

  String _dioMessage(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out.',
      DioExceptionType.receiveTimeout => 'The server took too long to respond.',
      DioExceptionType.connectionError => 'Could not reach the server.',
      DioExceptionType.badResponse => 'Server error ${e.response?.statusCode}.',
      _ => 'Network error. Please try again.',
    };
  }
}
