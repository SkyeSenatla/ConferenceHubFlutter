import 'room.dart';

class Booking {
  final String meetingTitle;
  final Room room;
  final String startTime;
  final String endTime;
  final String organiserEmail;

  final int requiredHeadcount;

  const Booking({
    required this.meetingTitle,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.organiserEmail,
    required this.requiredHeadcount,
  });
}
