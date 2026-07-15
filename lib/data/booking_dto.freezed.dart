// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) {
  return _BookingDto.fromJson(json);
}

/// @nodoc
mixin _$BookingDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get roomName => throw _privateConstructorUsedError;
  String get floor => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get organizerEmail => throw _privateConstructorUsedError;
  int get attendeeCount => throw _privateConstructorUsedError;

  /// Serializes this BookingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingDtoCopyWith<BookingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDtoCopyWith<$Res> {
  factory $BookingDtoCopyWith(
    BookingDto value,
    $Res Function(BookingDto) then,
  ) = _$BookingDtoCopyWithImpl<$Res, BookingDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String type,
    String roomName,
    String floor,
    DateTime startTime,
    DateTime endTime,
    String organizerEmail,
    int attendeeCount,
  });
}

/// @nodoc
class _$BookingDtoCopyWithImpl<$Res, $Val extends BookingDto>
    implements $BookingDtoCopyWith<$Res> {
  _$BookingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? roomName = null,
    Object? floor = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? organizerEmail = null,
    Object? attendeeCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            roomName: null == roomName
                ? _value.roomName
                : roomName // ignore: cast_nullable_to_non_nullable
                      as String,
            floor: null == floor
                ? _value.floor
                : floor // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            organizerEmail: null == organizerEmail
                ? _value.organizerEmail
                : organizerEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            attendeeCount: null == attendeeCount
                ? _value.attendeeCount
                : attendeeCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingDtoImplCopyWith<$Res>
    implements $BookingDtoCopyWith<$Res> {
  factory _$$BookingDtoImplCopyWith(
    _$BookingDtoImpl value,
    $Res Function(_$BookingDtoImpl) then,
  ) = __$$BookingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String type,
    String roomName,
    String floor,
    DateTime startTime,
    DateTime endTime,
    String organizerEmail,
    int attendeeCount,
  });
}

/// @nodoc
class __$$BookingDtoImplCopyWithImpl<$Res>
    extends _$BookingDtoCopyWithImpl<$Res, _$BookingDtoImpl>
    implements _$$BookingDtoImplCopyWith<$Res> {
  __$$BookingDtoImplCopyWithImpl(
    _$BookingDtoImpl _value,
    $Res Function(_$BookingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? roomName = null,
    Object? floor = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? organizerEmail = null,
    Object? attendeeCount = null,
  }) {
    return _then(
      _$BookingDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        roomName: null == roomName
            ? _value.roomName
            : roomName // ignore: cast_nullable_to_non_nullable
                  as String,
        floor: null == floor
            ? _value.floor
            : floor // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        organizerEmail: null == organizerEmail
            ? _value.organizerEmail
            : organizerEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        attendeeCount: null == attendeeCount
            ? _value.attendeeCount
            : attendeeCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingDtoImpl implements _BookingDto {
  const _$BookingDtoImpl({
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

  factory _$BookingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String type;
  @override
  final String roomName;
  @override
  final String floor;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String organizerEmail;
  @override
  final int attendeeCount;

  @override
  String toString() {
    return 'BookingDto(id: $id, title: $title, type: $type, roomName: $roomName, floor: $floor, startTime: $startTime, endTime: $endTime, organizerEmail: $organizerEmail, attendeeCount: $attendeeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.roomName, roomName) ||
                other.roomName == roomName) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.organizerEmail, organizerEmail) ||
                other.organizerEmail == organizerEmail) &&
            (identical(other.attendeeCount, attendeeCount) ||
                other.attendeeCount == attendeeCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    type,
    roomName,
    floor,
    startTime,
    endTime,
    organizerEmail,
    attendeeCount,
  );

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      __$$BookingDtoImplCopyWithImpl<_$BookingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingDtoImplToJson(this);
  }
}

abstract class _BookingDto implements BookingDto {
  const factory _BookingDto({
    required final String id,
    required final String title,
    required final String type,
    required final String roomName,
    required final String floor,
    required final DateTime startTime,
    required final DateTime endTime,
    required final String organizerEmail,
    required final int attendeeCount,
  }) = _$BookingDtoImpl;

  factory _BookingDto.fromJson(Map<String, dynamic> json) =
      _$BookingDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get type;
  @override
  String get roomName;
  @override
  String get floor;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get organizerEmail;
  @override
  int get attendeeCount;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
