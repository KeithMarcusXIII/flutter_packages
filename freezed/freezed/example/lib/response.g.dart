// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ResponseData<T, Error> _$_$_ResponseDataFromJson<T, Error>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
  Error Function(Object? json) fromJsonError,
) {
  return _$_ResponseData<T, Error>(
    fromJsonT(json['data']),
  );
}

Map<String, dynamic> _$_$_ResponseDataToJson<T, Error>(
  _$_ResponseData<T, Error> instance,
  Object? Function(T value) toJsonT,
  Object? Function(Error value) toJsonError,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
    };

_$_ResponseError<T, Error> _$_$_ResponseErrorFromJson<T, Error>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
  Error Function(Object? json) fromJsonError,
) {
  return _$_ResponseError<T, Error>(
    fromJsonError(json['error']),
  );
}

Map<String, dynamic> _$_$_ResponseErrorToJson<T, Error>(
  _$_ResponseError<T, Error> instance,
  Object? Function(T value) toJsonT,
  Object? Function(Error value) toJsonError,
) =>
    <String, dynamic>{
      'error': toJsonError(instance.error),
    };
