import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_freezed.dart';
part 'user_g.dart';

@freezed
class User with _$User {
  const factory User() = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
