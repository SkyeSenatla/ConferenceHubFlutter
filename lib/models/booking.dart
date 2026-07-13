import 'room.dart';

class Booking {
  // Stable identifier used to build URLs like /bookings/1 -- and to look
  // the booking back up from a provider once GoRouter hands us just the id.
  final int id;
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
}
