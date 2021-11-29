// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'firebase_api_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirebaseApiError _$FirebaseApiErrorFromJson(Map<String, dynamic> json) {
  return _FirebaseApiError.fromJson(json);
}

/// @nodoc
class _$FirebaseApiErrorTearOff {
  const _$FirebaseApiErrorTearOff();

  _FirebaseApiError call([String? message]) {
    return _FirebaseApiError(
      message,
    );
  }

  FirebaseApiError fromJson(Map<String, Object> json) {
    return FirebaseApiError.fromJson(json);
  }
}

/// @nodoc
const $FirebaseApiError = _$FirebaseApiErrorTearOff();

/// @nodoc
mixin _$FirebaseApiError {
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirebaseApiErrorCopyWith<FirebaseApiError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseApiErrorCopyWith<$Res> {
  factory $FirebaseApiErrorCopyWith(
          FirebaseApiError value, $Res Function(FirebaseApiError) then) =
      _$FirebaseApiErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class _$FirebaseApiErrorCopyWithImpl<$Res>
    implements $FirebaseApiErrorCopyWith<$Res> {
  _$FirebaseApiErrorCopyWithImpl(this._value, this._then);

  final FirebaseApiError _value;
  // ignore: unused_field
  final $Res Function(FirebaseApiError) _then;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$FirebaseApiErrorCopyWith<$Res>
    implements $FirebaseApiErrorCopyWith<$Res> {
  factory _$FirebaseApiErrorCopyWith(
          _FirebaseApiError value, $Res Function(_FirebaseApiError) then) =
      __$FirebaseApiErrorCopyWithImpl<$Res>;
  @override
  $Res call({String? message});
}

/// @nodoc
class __$FirebaseApiErrorCopyWithImpl<$Res>
    extends _$FirebaseApiErrorCopyWithImpl<$Res>
    implements _$FirebaseApiErrorCopyWith<$Res> {
  __$FirebaseApiErrorCopyWithImpl(
      _FirebaseApiError _value, $Res Function(_FirebaseApiError) _then)
      : super(_value, (v) => _then(v as _FirebaseApiError));

  @override
  _FirebaseApiError get _value => super._value as _FirebaseApiError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_FirebaseApiError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirebaseApiError implements _FirebaseApiError {
  const _$_FirebaseApiError([this.message]);

  factory _$_FirebaseApiError.fromJson(Map<String, dynamic> json) =>
      _$_$_FirebaseApiErrorFromJson(json);

  @override
  final String? message;

  @override
  String toString() {
    return 'FirebaseApiError(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FirebaseApiError &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(message);

  @JsonKey(ignore: true)
  @override
  _$FirebaseApiErrorCopyWith<_FirebaseApiError> get copyWith =>
      __$FirebaseApiErrorCopyWithImpl<_FirebaseApiError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_FirebaseApiErrorToJson(this);
  }
}

abstract class _FirebaseApiError implements FirebaseApiError {
  const factory _FirebaseApiError([String? message]) = _$_FirebaseApiError;

  factory _FirebaseApiError.fromJson(Map<String, dynamic> json) =
      _$_FirebaseApiError.fromJson;

  @override
  String? get message => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FirebaseApiErrorCopyWith<_FirebaseApiError> get copyWith =>
      throw _privateConstructorUsedError;
}
