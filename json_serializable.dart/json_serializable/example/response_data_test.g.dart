// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_data_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DefaultResponseData<T, Error> _$_$_DefaultResponseDataFromJson<T, Error>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
  Error Function(Object? json) fromJsonError,
) {
  return _$_DefaultResponseData<T, Error>(
    fromJsonT(json['data2']),
  );
}

Map<String, dynamic> _$_$_DefaultResponseDataToJson<T, Error>(
  _$_DefaultResponseData<T, Error> instance,
  Object? Function(T value) toJsonT,
  Object? Function(Error value) toJsonError,
) =>
    <String, dynamic>{
      'data2': toJsonT(instance.data),
    };
