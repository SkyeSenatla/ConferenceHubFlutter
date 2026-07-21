// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingDto {

 String get id; String get title; String get type; String get roomName; String get floor; DateTime get startTime; DateTime get endTime; String get organizerEmail; int get attendeeCount;
/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDtoCopyWith<BookingDto> get copyWith => _$BookingDtoCopyWithImpl<BookingDto>(this as BookingDto, _$identity);

  /// Serializes this BookingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.organizerEmail, organizerEmail) || other.organizerEmail == organizerEmail)&&(identical(other.attendeeCount, attendeeCount) || other.attendeeCount == attendeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,roomName,floor,startTime,endTime,organizerEmail,attendeeCount);

@override
String toString() {
  return 'BookingDto(id: $id, title: $title, type: $type, roomName: $roomName, floor: $floor, startTime: $startTime, endTime: $endTime, organizerEmail: $organizerEmail, attendeeCount: $attendeeCount)';
}


}

/// @nodoc
abstract mixin class $BookingDtoCopyWith<$Res>  {
  factory $BookingDtoCopyWith(BookingDto value, $Res Function(BookingDto) _then) = _$BookingDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String type, String roomName, String floor, DateTime startTime, DateTime endTime, String organizerEmail, int attendeeCount
});




}
/// @nodoc
class _$BookingDtoCopyWithImpl<$Res>
    implements $BookingDtoCopyWith<$Res> {
  _$BookingDtoCopyWithImpl(this._self, this._then);

  final BookingDto _self;
  final $Res Function(BookingDto) _then;

/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? roomName = null,Object? floor = null,Object? startTime = null,Object? endTime = null,Object? organizerEmail = null,Object? attendeeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,organizerEmail: null == organizerEmail ? _self.organizerEmail : organizerEmail // ignore: cast_nullable_to_non_nullable
as String,attendeeCount: null == attendeeCount ? _self.attendeeCount : attendeeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingDto].
extension BookingDtoPatterns on BookingDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDto value)  $default,){
final _that = this;
switch (_that) {
case _BookingDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String roomName,  String floor,  DateTime startTime,  DateTime endTime,  String organizerEmail,  int attendeeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.roomName,_that.floor,_that.startTime,_that.endTime,_that.organizerEmail,_that.attendeeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String roomName,  String floor,  DateTime startTime,  DateTime endTime,  String organizerEmail,  int attendeeCount)  $default,) {final _that = this;
switch (_that) {
case _BookingDto():
return $default(_that.id,_that.title,_that.type,_that.roomName,_that.floor,_that.startTime,_that.endTime,_that.organizerEmail,_that.attendeeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String type,  String roomName,  String floor,  DateTime startTime,  DateTime endTime,  String organizerEmail,  int attendeeCount)?  $default,) {final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.roomName,_that.floor,_that.startTime,_that.endTime,_that.organizerEmail,_that.attendeeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingDto implements BookingDto {
  const _BookingDto({required this.id, required this.title, required this.type, required this.roomName, required this.floor, required this.startTime, required this.endTime, required this.organizerEmail, required this.attendeeCount});
  factory _BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String type;
@override final  String roomName;
@override final  String floor;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  String organizerEmail;
@override final  int attendeeCount;

/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDtoCopyWith<_BookingDto> get copyWith => __$BookingDtoCopyWithImpl<_BookingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.organizerEmail, organizerEmail) || other.organizerEmail == organizerEmail)&&(identical(other.attendeeCount, attendeeCount) || other.attendeeCount == attendeeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,roomName,floor,startTime,endTime,organizerEmail,attendeeCount);

@override
String toString() {
  return 'BookingDto(id: $id, title: $title, type: $type, roomName: $roomName, floor: $floor, startTime: $startTime, endTime: $endTime, organizerEmail: $organizerEmail, attendeeCount: $attendeeCount)';
}


}

/// @nodoc
abstract mixin class _$BookingDtoCopyWith<$Res> implements $BookingDtoCopyWith<$Res> {
  factory _$BookingDtoCopyWith(_BookingDto value, $Res Function(_BookingDto) _then) = __$BookingDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String type, String roomName, String floor, DateTime startTime, DateTime endTime, String organizerEmail, int attendeeCount
});




}
/// @nodoc
class __$BookingDtoCopyWithImpl<$Res>
    implements _$BookingDtoCopyWith<$Res> {
  __$BookingDtoCopyWithImpl(this._self, this._then);

  final _BookingDto _self;
  final $Res Function(_BookingDto) _then;

/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? roomName = null,Object? floor = null,Object? startTime = null,Object? endTime = null,Object? organizerEmail = null,Object? attendeeCount = null,}) {
  return _then(_BookingDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,organizerEmail: null == organizerEmail ? _self.organizerEmail : organizerEmail // ignore: cast_nullable_to_non_nullable
as String,attendeeCount: null == attendeeCount ? _self.attendeeCount : attendeeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
