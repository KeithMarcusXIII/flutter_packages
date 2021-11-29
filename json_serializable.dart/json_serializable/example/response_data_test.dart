// import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_data_test.g.dart';

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

abstract class _DefaultResponseData<T, Error> {
  const factory _DefaultResponseData(@JsonKey(name: 'data2') T data) =
      _$_DefaultResponseData<T, Error>;

  @JsonKey(name: 'data2')
  T get data => throw _privateConstructorUsedError;
  /* @JsonKey(ignore: true)
  _$DefaultResponseDataCopyWith<T, Error, _DefaultResponseData<T, Error>>
      get copyWith => throw _privateConstructorUsedError; */
}

@JsonSerializable(genericArgumentFactories: true)
class _$_DefaultResponseData<T, Error>
    implements _DefaultResponseData<T, Error> {
  const _$_DefaultResponseData(@JsonKey(name: 'data2') this.data);

  @override
  @JsonKey(name: 'data2')
  final T data;

  @override
  String toString() {
    return 'DefaultResponse<$T, $Error>(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DefaultResponseData<T, Error> &&
            (identical(other.data,
                data) /* ||
                const DeepCollectionEquality().equals(other.data, data) */
            ));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode /* ^ const DeepCollectionEquality().hash(data) */;

  /* @JsonKey(ignore: true)
  @override
  _$DefaultResponseDataCopyWith<T, Error, _DefaultResponseData<T, Error>>
      get copyWith => __$DefaultResponseDataCopyWithImpl<T, Error,
          _DefaultResponseData<T, Error>>(this, _$identity); */

  @override
  // @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'data2') T data) $default, {
    required TResult Function(Error error) error,
  }) {
    return $default(data);
  }

  @override
  // @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'data2') T data)? $default, {
    TResult Function(Error error)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(data);
    }
    return orElse();
  }

  /* @override
  // @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DefaultResponseData<T, Error> value) $default, {
    required TResult Function(_DefaultResponseError<T, Error> value) error,
  }) {
    return $default(this);
  }

  @override
  // @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DefaultResponseData<T, Error> value)? $default, {
    TResult Function(_DefaultResponseError<T, Error> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  } */
}
