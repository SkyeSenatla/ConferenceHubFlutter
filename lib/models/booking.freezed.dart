// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get meetingTitle => throw _privateConstructorUsedError;
  Room get room => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get organiserEmail => throw _privateConstructorUsedError;
  int get requiredHeadcount => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    String meetingTitle,
    Room room,
    String startTime,
    String endTime,
    String organiserEmail,
    int requiredHeadcount,
  });
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? meetingTitle = null,
    Object? room = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? organiserEmail = null,
    Object? requiredHeadcount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            meetingTitle: null == meetingTitle
                ? _value.meetingTitle
                : meetingTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            room: null == room
                ? _value.room
                : room // ignore: cast_nullable_to_non_nullable
                      as Room,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            organiserEmail: null == organiserEmail
                ? _value.organiserEmail
                : organiserEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            requiredHeadcount: null == requiredHeadcount
                ? _value.requiredHeadcount
                : requiredHeadcount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String meetingTitle,
    Room room,
    String startTime,
    String endTime,
    String organiserEmail,
    int requiredHeadcount,
  });
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? meetingTitle = null,
    Object? room = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? organiserEmail = null,
    Object? requiredHeadcount = null,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        meetingTitle: null == meetingTitle
            ? _value.meetingTitle
            : meetingTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        room: null == room
            ? _value.room
            : room // ignore: cast_nullable_to_non_nullable
                  as Room,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        organiserEmail: null == organiserEmail
            ? _value.organiserEmail
            : organiserEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        requiredHeadcount: null == requiredHeadcount
            ? _value.requiredHeadcount
            : requiredHeadcount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$BookingImpl extends _Booking {
  const _$BookingImpl({
    required this.id,
    required this.meetingTitle,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.organiserEmail,
    required this.requiredHeadcount,
  }) : super._();

  @override
  final String id;
  @override
  final String meetingTitle;
  @override
  final Room room;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String organiserEmail;
  @override
  final int requiredHeadcount;

  @override
  String toString() {
    return 'Booking(id: $id, meetingTitle: $meetingTitle, room: $room, startTime: $startTime, endTime: $endTime, organiserEmail: $organiserEmail, requiredHeadcount: $requiredHeadcount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.meetingTitle, meetingTitle) ||
                other.meetingTitle == meetingTitle) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.organiserEmail, organiserEmail) ||
                other.organiserEmail == organiserEmail) &&
            (identical(other.requiredHeadcount, requiredHeadcount) ||
                other.requiredHeadcount == requiredHeadcount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    meetingTitle,
    room,
    startTime,
    endTime,
    organiserEmail,
    requiredHeadcount,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);
}

abstract class _Booking extends Booking {
  const factory _Booking({
    required final String id,
    required final String meetingTitle,
    required final Room room,
    required final String startTime,
    required final String endTime,
    required final String organiserEmail,
    required final int requiredHeadcount,
  }) = _$BookingImpl;
  const _Booking._() : super._();

  @override
  String get id;
  @override
  String get meetingTitle;
  @override
  Room get room;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String get organiserEmail;
  @override
  int get requiredHeadcount;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
