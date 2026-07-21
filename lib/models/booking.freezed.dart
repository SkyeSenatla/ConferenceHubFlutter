// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Booking {

 String get id; String get meetingTitle; Room get room; String get startTime; String get endTime; String get organiserEmail; int get requiredHeadcount;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingTitle, meetingTitle) || other.meetingTitle == meetingTitle)&&(identical(other.room, room) || other.room == room)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.organiserEmail, organiserEmail) || other.organiserEmail == organiserEmail)&&(identical(other.requiredHeadcount, requiredHeadcount) || other.requiredHeadcount == requiredHeadcount));
}


@override
int get hashCode => Object.hash(runtimeType,id,meetingTitle,room,startTime,endTime,organiserEmail,requiredHeadcount);

@override
String toString() {
  return 'Booking(id: $id, meetingTitle: $meetingTitle, room: $room, startTime: $startTime, endTime: $endTime, organiserEmail: $organiserEmail, requiredHeadcount: $requiredHeadcount)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String meetingTitle, Room room, String startTime, String endTime, String organiserEmail, int requiredHeadcount
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? meetingTitle = null,Object? room = null,Object? startTime = null,Object? endTime = null,Object? organiserEmail = null,Object? requiredHeadcount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingTitle: null == meetingTitle ? _self.meetingTitle : meetingTitle // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as Room,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,organiserEmail: null == organiserEmail ? _self.organiserEmail : organiserEmail // ignore: cast_nullable_to_non_nullable
as String,requiredHeadcount: null == requiredHeadcount ? _self.requiredHeadcount : requiredHeadcount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String meetingTitle,  Room room,  String startTime,  String endTime,  String organiserEmail,  int requiredHeadcount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.meetingTitle,_that.room,_that.startTime,_that.endTime,_that.organiserEmail,_that.requiredHeadcount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String meetingTitle,  Room room,  String startTime,  String endTime,  String organiserEmail,  int requiredHeadcount)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.meetingTitle,_that.room,_that.startTime,_that.endTime,_that.organiserEmail,_that.requiredHeadcount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String meetingTitle,  Room room,  String startTime,  String endTime,  String organiserEmail,  int requiredHeadcount)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.meetingTitle,_that.room,_that.startTime,_that.endTime,_that.organiserEmail,_that.requiredHeadcount);case _:
  return null;

}
}

}

/// @nodoc


class _Booking extends Booking {
  const _Booking({required this.id, required this.meetingTitle, required this.room, required this.startTime, required this.endTime, required this.organiserEmail, required this.requiredHeadcount}): super._();
  

@override final  String id;
@override final  String meetingTitle;
@override final  Room room;
@override final  String startTime;
@override final  String endTime;
@override final  String organiserEmail;
@override final  int requiredHeadcount;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingTitle, meetingTitle) || other.meetingTitle == meetingTitle)&&(identical(other.room, room) || other.room == room)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.organiserEmail, organiserEmail) || other.organiserEmail == organiserEmail)&&(identical(other.requiredHeadcount, requiredHeadcount) || other.requiredHeadcount == requiredHeadcount));
}


@override
int get hashCode => Object.hash(runtimeType,id,meetingTitle,room,startTime,endTime,organiserEmail,requiredHeadcount);

@override
String toString() {
  return 'Booking(id: $id, meetingTitle: $meetingTitle, room: $room, startTime: $startTime, endTime: $endTime, organiserEmail: $organiserEmail, requiredHeadcount: $requiredHeadcount)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String meetingTitle, Room room, String startTime, String endTime, String organiserEmail, int requiredHeadcount
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? meetingTitle = null,Object? room = null,Object? startTime = null,Object? endTime = null,Object? organiserEmail = null,Object? requiredHeadcount = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingTitle: null == meetingTitle ? _self.meetingTitle : meetingTitle // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as Room,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,organiserEmail: null == organiserEmail ? _self.organiserEmail : organiserEmail // ignore: cast_nullable_to_non_nullable
as String,requiredHeadcount: null == requiredHeadcount ? _self.requiredHeadcount : requiredHeadcount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
