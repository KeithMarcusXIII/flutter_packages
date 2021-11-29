import 'package:example/address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed(
  unionKey: 'type',
  unionValueCase: FreezedUnionCase.snake,
)
class Profile with _$Profile {
  const factory Profile.business({
    required int id,
    required String name,
    required String description,
    @JsonKey(name: 'id_no')
        required String identification,
    @JsonKey(
      name: 'contact',
      defaultValue: '',
    )
        String? phoneNo,
    @JsonKey(
      excludeFromJson: true,
      excludeToJson: true,
    )
        Address? address,
  }) = _ProfileBusiness;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
