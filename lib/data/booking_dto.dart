class BookingDto {
  final String id;
  final String title;
  final String type;
  final String roomName;
  final String floor;
  final DateTime startTime;
  final DateTime endTime;
  final String organizerEmail;
  final int attendeeCount;
  const BookingDto({
    required this.id,
    required this.title,
    required this.type,
    required this.roomName,
    required this.floor,
    required this.startTime,
    required this.endTime,
    required this.organizerEmail,
    required this.attendeeCount,
  });
  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      roomName: json['roomName'] as String,
      floor: json['floor'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      organizerEmail: json['organizerEmail'] as String,
      attendeeCount: json['attendeeCount'] as int,
    );
  }
}
