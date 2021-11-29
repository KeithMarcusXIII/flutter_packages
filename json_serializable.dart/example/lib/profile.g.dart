// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProfileBusiness _$_$_ProfileBusinessFromJson(Map<String, dynamic> json) {
  return _$_ProfileBusiness(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    identification: json['id_no'] as String,
    phoneNo: json['contact'] as String? ?? '',
    address:
        json == null ? null : Address.fromJson(json as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_ProfileBusinessToJson(_$_ProfileBusiness instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'id_no': instance.identification,
      'contact': instance.phoneNo,
      'address': instance.address,
    };
