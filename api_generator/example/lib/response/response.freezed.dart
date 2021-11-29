// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Response<T, Error> _$ResponseFromJson<T, Error>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    Error Function(Object? json) fromJsonError) {
  switch (json['runtimeType'] as String) {
    case 'default':
      return _ResponseData<T, Error>.fromJson(json, fromJsonT, fromJsonError);
    case 'error':
      return _ResponseError<T, Error>.fromJson(json, fromJsonT, fromJsonError);

    default:
      throw FallThroughError();
  }
}

/// @nodoc
class _$ResponseTearOff {
  const _$ResponseTearOff();

  _ResponseData<T, Error> call<T, Error>(T data) {
    return _ResponseData<T, Error>(
      data,
    );
  }

  _ResponseError<T, Error> error<T, Error>(Error error) {
    return _ResponseError<T, Error>(
      error,
    );
  }

  Response<T, Error> fromJson<T, Error>(
      Map<String, Object> json,
      T Function(Object? json) fromJsonT,
      Error Function(Object? json) fromJsonError) {
    return Response<T, Error>.fromJson(json, fromJsonT, fromJsonError);
  }
}

/// @nodoc
const $Response = _$ResponseTearOff();

/// @nodoc
mixin _$Response<T, Error> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T data) $default, {
    required TResult Function(Error error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T data)? $default, {
    TResult Function(Error error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ResponseData<T, Error> value) $default, {
    required TResult Function(_ResponseError<T, Error> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ResponseData<T, Error> value)? $default, {
    TResult Function(_ResponseError<T, Error> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson(Object Function(T value) toJsonT,
          Object Function(Error value) toJsonError) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseCopyWith<T, Error, $Res> {
  factory $ResponseCopyWith(
          Response<T, Error> value, $Res Function(Response<T, Error>) then) =
      _$ResponseCopyWithImpl<T, Error, $Res>;
}

/// @nodoc
class _$ResponseCopyWithImpl<T, Error, $Res>
    implements $ResponseCopyWith<T, Error, $Res> {
  _$ResponseCopyWithImpl(this._value, this._then);

  final Response<T, Error> _value;
  // ignore: unused_field
  final $Res Function(Response<T, Error>) _then;
}

/// @nodoc
abstract class _$ResponseDataCopyWith<T, Error, $Res> {
  factory _$ResponseDataCopyWith(_ResponseData<T, Error> value,
          $Res Function(_ResponseData<T, Error>) then) =
      __$ResponseDataCopyWithImpl<T, Error, $Res>;
  $Res call({T data});
}

/// @nodoc
class __$ResponseDataCopyWithImpl<T, Error, $Res>
    extends _$ResponseCopyWithImpl<T, Error, $Res>
    implements _$ResponseDataCopyWith<T, Error, $Res> {
  __$ResponseDataCopyWithImpl(_ResponseData<T, Error> _value,
      $Res Function(_ResponseData<T, Error>) _then)
      : super(_value, (v) => _then(v as _ResponseData<T, Error>));

  @override
  _ResponseData<T, Error> get _value => super._value as _ResponseData<T, Error>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_ResponseData<T, Error>(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

@JsonSerializable(genericArgumentFactories: true)
class _$_ResponseData<T, Error> implements _ResponseData<T, Error> {
  const _$_ResponseData(this.data);

  factory _$_ResponseData.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          Error Function(Object? json) fromJsonError) =>
      _$_$_ResponseDataFromJson(json, fromJsonT, fromJsonError);

  @override
  final T data;

  @override
  String toString() {
    return 'Response<$T, $Error>(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ResponseData<T, Error> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  _$ResponseDataCopyWith<T, Error, _ResponseData<T, Error>> get copyWith =>
      __$ResponseDataCopyWithImpl<T, Error, _ResponseData<T, Error>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T data) $default, {
    required TResult Function(Error error) error,
  }) {
    return $default(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T data)? $default, {
    TResult Function(Error error)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ResponseData<T, Error> value) $default, {
    required TResult Function(_ResponseError<T, Error> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ResponseData<T, Error> value)? $default, {
    TResult Function(_ResponseError<T, Error> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson(Object Function(T value) toJsonT,
      Object Function(Error value) toJsonError) {
    return _$_$_ResponseDataToJson(this, toJsonT, toJsonError)
      ..['runtimeType'] = 'default';
  }
}

abstract class _ResponseData<T, Error> implements Response<T, Error> {
  const factory _ResponseData(T data) = _$_ResponseData<T, Error>;

  factory _ResponseData.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          Error Function(Object? json) fromJsonError) =
      _$_ResponseData<T, Error>.fromJson;

  T get data => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$ResponseDataCopyWith<T, Error, _ResponseData<T, Error>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ResponseErrorCopyWith<T, Error, $Res> {
  factory _$ResponseErrorCopyWith(_ResponseError<T, Error> value,
          $Res Function(_ResponseError<T, Error>) then) =
      __$ResponseErrorCopyWithImpl<T, Error, $Res>;
  $Res call({Error error});
}

/// @nodoc
class __$ResponseErrorCopyWithImpl<T, Error, $Res>
    extends _$ResponseCopyWithImpl<T, Error, $Res>
    implements _$ResponseErrorCopyWith<T, Error, $Res> {
  __$ResponseErrorCopyWithImpl(_ResponseError<T, Error> _value,
      $Res Function(_ResponseError<T, Error>) _then)
      : super(_value, (v) => _then(v as _ResponseError<T, Error>));

  @override
  _ResponseError<T, Error> get _value =>
      super._value as _ResponseError<T, Error>;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_ResponseError<T, Error>(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Error,
    ));
  }
}

/// @nodoc

@JsonSerializable(genericArgumentFactories: true)
class _$_ResponseError<T, Error> implements _ResponseError<T, Error> {
  const _$_ResponseError(this.error);

  factory _$_ResponseError.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          Error Function(Object? json) fromJsonError) =>
      _$_$_ResponseErrorFromJson(json, fromJsonT, fromJsonError);

  @override
  final Error error;

  @override
  String toString() {
    return 'Response<$T, $Error>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ResponseError<T, Error> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$ResponseErrorCopyWith<T, Error, _ResponseError<T, Error>> get copyWith =>
      __$ResponseErrorCopyWithImpl<T, Error, _ResponseError<T, Error>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T data) $default, {
    required TResult Function(Error error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T data)? $default, {
    TResult Function(Error error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ResponseData<T, Error> value) $default, {
    required TResult Function(_ResponseError<T, Error> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ResponseData<T, Error> value)? $default, {
    TResult Function(_ResponseError<T, Error> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson(Object Function(T value) toJsonT,
      Object Function(Error value) toJsonError) {
    return _$_$_ResponseErrorToJson(this, toJsonT, toJsonError)
      ..['runtimeType'] = 'error';
  }
}

abstract class _ResponseError<T, Error> implements Response<T, Error> {
  const factory _ResponseError(Error error) = _$_ResponseError<T, Error>;

  factory _ResponseError.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          Error Function(Object? json) fromJsonError) =
      _$_ResponseError<T, Error>.fromJson;

  Error get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$ResponseErrorCopyWith<T, Error, _ResponseError<T, Error>> get copyWith =>
      throw _privateConstructorUsedError;
}
