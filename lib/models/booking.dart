import 'package:freezed_annotation/freezed_annotation.dart';
import 'room.dart';
import '../data/booking_dto.dart';

part 'booking.freezed.dart';

@freezed
abstract class Booking with _$Booking {
  const Booking._();

  // Changed from int to String -- the API uses Guid identifiers.
  // GoRouter path parameters are always String, so this also removes
  // the int.parse call in the router.
  const factory Booking({
    required String id,
    required String meetingTitle,
    required Room room,
    required String startTime,
    required String endTime,
    required String organiserEmail,
    required int requiredHeadcount,
  }) = _Booking;

  static Booking fromDto(BookingDto dto, Room room) {
    return Booking(
      id: dto.id,
      meetingTitle: dto.title,
      room: room,
      startTime: _formatTime(dto.startTime),
      endTime: _formatTime(dto.endTime),
      organiserEmail: dto.organizerEmail,
      requiredHeadcount: dto.attendeeCount,
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
