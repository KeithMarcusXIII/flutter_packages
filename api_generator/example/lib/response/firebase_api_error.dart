import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_api_error_freezed.dart';
part 'firebase_api_error_g.dart';

abstract class CommonError implements Exception {
  factory CommonError([var message]) => CommonError(message);

  String? get message;
}

class FirebaseApiError with _$FirebaseApiError implements CommonError {
  const factory FirebaseApiError([String? message]) = _FirebaseApiError;

  factory FirebaseApiError.fromJson(Map<String, dynamic> json) =>
      _$FirebaseApiErrorFromJson(json);
}
