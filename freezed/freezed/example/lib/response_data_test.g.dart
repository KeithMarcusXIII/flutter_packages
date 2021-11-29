// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_data_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponseDataTest<T, Error> _$_$ResponseDataTestFromJson<T, Error>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
  Error Function(Object? json) fromJsonError,
) {
  return _$ResponseDataTest<T, Error>(
    fromJsonT(json['data']),
  );
}

Map<String, dynamic> _$_$ResponseDataTestToJson<T, Error>(
  _$ResponseDataTest<T, Error> instance,
  Object? Function(T value) toJsonT,
  Object? Function(Error value) toJsonError,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
    };
