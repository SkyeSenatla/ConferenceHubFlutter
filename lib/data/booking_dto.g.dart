// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDtoImpl _$$BookingDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      roomName: json['roomName'] as String,
      floor: json['floor'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      organizerEmail: json['organizerEmail'] as String,
      attendeeCount: (json['attendeeCount'] as num).toInt(),
    );

Map<String, dynamic> _$$BookingDtoImplToJson(_$BookingDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'roomName': instance.roomName,
      'floor': instance.floor,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'organizerEmail': instance.organizerEmail,
      'attendeeCount': instance.attendeeCount,
    };
