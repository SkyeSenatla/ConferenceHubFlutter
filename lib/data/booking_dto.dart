// Mirrors the API's BookingResponse shape exactly (see
// ConferenceBookingAPI/API/DTOs/BookingResponse.cs). Keeping this separate
// from the Flutter Booking model means an API shape change only touches
// this file and BookingsRepository -- not the UI.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

@freezed
abstract class BookingDto with _$BookingDto {
  const factory BookingDto({
    required String id,
    required String title,
    required String type,
    required String roomName,
    required String floor,
    required DateTime startTime,
    required DateTime endTime,
    required String organizerEmail,
    required int attendeeCount,
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDtoFromJson(json);
}
