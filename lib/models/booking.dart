import 'room.dart';
import '../data/booking_dto.dart';

class Booking {
  // Changed from int to String -- the API uses Guid identifiers.
  // GoRouter path parameters are always String, so this also removes
  // the int.parse call in the router.
  final String id;
  final String meetingTitle;
  final Room room;
  final String startTime;
  final String endTime;
  final String organiserEmail;
  final int requiredHeadcount;
  const Booking({
    required this.id,
    required this.meetingTitle,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.organiserEmail,
    required this.requiredHeadcount,
  });
  factory Booking.fromDto(BookingDto dto, Room room) {
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
