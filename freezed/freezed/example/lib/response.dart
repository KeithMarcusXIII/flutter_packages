import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
class Response<T, Error> with _$Response<T, Error> {
  @JsonSerializable(genericArgumentFactories: true)
  const factory Response(T data) = _ResponseData;

  @JsonSerializable(genericArgumentFactories: true)
  const factory Response.error(Error error) = _ResponseError;

  factory Response.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
    Error Function(Object?) fromJsonError,
  ) =>
      _$ResponseFromJson(json, fromJsonT, fromJsonError);
}
