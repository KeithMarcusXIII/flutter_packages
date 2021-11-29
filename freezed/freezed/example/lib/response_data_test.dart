import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_data_test.g.dart';

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

abstract class ResponseDataTest<T, Error> {
  const factory ResponseDataTest(T data) = _$ResponseDataTest<T, Error>;

  factory ResponseDataTest.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          Error Function(Object? json) fromJsonError) =
      _$ResponseDataTest<T, Error>.fromJson;

  T get data => throw _privateConstructorUsedError;
}

@JsonSerializable(genericArgumentFactories: true)
class _$ResponseDataTest<T, Error> implements ResponseDataTest<T, Error> {
  const _$ResponseDataTest(this.data);

  factory _$ResponseDataTest.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          Error Function(Object? json) fromJsonError) =>
      _$_$ResponseDataTestFromJson(json, fromJsonT, fromJsonError);

  @override
  final T data;

  @override
  String toString() {
    return 'Response<$T, $Error>(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ResponseDataTest<T, Error> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

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
  Map<String, dynamic> toJson(Object Function(T value) toJsonT,
      Object Function(Error value) toJsonError) {
    return _$_$ResponseDataTestToJson(this, toJsonT, toJsonError)
      ..['custom-key'] = 'Default';
  }
}
