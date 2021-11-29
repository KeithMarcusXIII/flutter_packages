// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _ProfileBusiness.fromJson(json);
}

/// @nodoc
class _$ProfileTearOff {
  const _$ProfileTearOff();

  _ProfileBusiness business(
      {required int id,
      required String name,
      required String description,
      @JsonKey(name: 'id_no') required String identification,
      @JsonKey(name: 'contact', defaultValue: '') String? phoneNo,
      @JsonKey(excludeFromJson: true, excludeToJson: true) Address? address}) {
    return _ProfileBusiness(
      id: id,
      name: name,
      description: description,
      identification: identification,
      phoneNo: phoneNo,
      address: address,
    );
  }

  Profile fromJson(Map<String, Object> json) {
    return Profile.fromJson(json);
  }
}

/// @nodoc
const $Profile = _$ProfileTearOff();

/// @nodoc
mixin _$Profile {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_no')
  String get identification => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact', defaultValue: '')
  String? get phoneNo => throw _privateConstructorUsedError;
  @JsonKey(excludeFromJson: true, excludeToJson: true)
  Address? get address => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'id_no')
                String identification,
            @JsonKey(name: 'contact', defaultValue: '')
                String? phoneNo,
            @JsonKey(excludeFromJson: true, excludeToJson: true)
                Address? address)
        business,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'id_no')
                String identification,
            @JsonKey(name: 'contact', defaultValue: '')
                String? phoneNo,
            @JsonKey(excludeFromJson: true, excludeToJson: true)
                Address? address)?
        business,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileBusiness value) business,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileBusiness value)? business,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String name,
      String description,
      @JsonKey(name: 'id_no') String identification,
      @JsonKey(name: 'contact', defaultValue: '') String? phoneNo,
      @JsonKey(excludeFromJson: true, excludeToJson: true) Address? address});

  $AddressCopyWith<$Res>? get address;
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  final Profile _value;
  // ignore: unused_field
  final $Res Function(Profile) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? identification = freezed,
    Object? phoneNo = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      identification: identification == freezed
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNo: phoneNo == freezed
          ? _value.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address?,
    ));
  }

  @override
  $AddressCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value));
    });
  }
}

/// @nodoc
abstract class _$ProfileBusinessCopyWith<$Res>
    implements $ProfileCopyWith<$Res> {
  factory _$ProfileBusinessCopyWith(
          _ProfileBusiness value, $Res Function(_ProfileBusiness) then) =
      __$ProfileBusinessCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String name,
      String description,
      @JsonKey(name: 'id_no') String identification,
      @JsonKey(name: 'contact', defaultValue: '') String? phoneNo,
      @JsonKey(excludeFromJson: true, excludeToJson: true) Address? address});

  @override
  $AddressCopyWith<$Res>? get address;
}

/// @nodoc
class __$ProfileBusinessCopyWithImpl<$Res> extends _$ProfileCopyWithImpl<$Res>
    implements _$ProfileBusinessCopyWith<$Res> {
  __$ProfileBusinessCopyWithImpl(
      _ProfileBusiness _value, $Res Function(_ProfileBusiness) _then)
      : super(_value, (v) => _then(v as _ProfileBusiness));

  @override
  _ProfileBusiness get _value => super._value as _ProfileBusiness;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? identification = freezed,
    Object? phoneNo = freezed,
    Object? address = freezed,
  }) {
    return _then(_ProfileBusiness(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      identification: identification == freezed
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNo: phoneNo == freezed
          ? _value.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProfileBusiness implements _ProfileBusiness {
  const _$_ProfileBusiness(
      {required this.id,
      required this.name,
      required this.description,
      @JsonKey(name: 'id_no') required this.identification,
      @JsonKey(name: 'contact', defaultValue: '') this.phoneNo,
      @JsonKey(excludeFromJson: true, excludeToJson: true) this.address});

  factory _$_ProfileBusiness.fromJson(Map<String, dynamic> json) =>
      _$_$_ProfileBusinessFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(name: 'id_no')
  final String identification;
  @override
  @JsonKey(name: 'contact', defaultValue: '')
  final String? phoneNo;
  @override
  @JsonKey(excludeFromJson: true, excludeToJson: true)
  final Address? address;

  @override
  String toString() {
    return 'Profile.business(id: $id, name: $name, description: $description, identification: $identification, phoneNo: $phoneNo, address: $address)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ProfileBusiness &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.identification, identification) ||
                const DeepCollectionEquality()
                    .equals(other.identification, identification)) &&
            (identical(other.phoneNo, phoneNo) ||
                const DeepCollectionEquality()
                    .equals(other.phoneNo, phoneNo)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality().equals(other.address, address)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(identification) ^
      const DeepCollectionEquality().hash(phoneNo) ^
      const DeepCollectionEquality().hash(address);

  @JsonKey(ignore: true)
  @override
  _$ProfileBusinessCopyWith<_ProfileBusiness> get copyWith =>
      __$ProfileBusinessCopyWithImpl<_ProfileBusiness>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'id_no')
                String identification,
            @JsonKey(name: 'contact', defaultValue: '')
                String? phoneNo,
            @JsonKey(excludeFromJson: true, excludeToJson: true)
                Address? address)
        business,
  }) {
    return business(id, name, description, identification, phoneNo, address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'id_no')
                String identification,
            @JsonKey(name: 'contact', defaultValue: '')
                String? phoneNo,
            @JsonKey(excludeFromJson: true, excludeToJson: true)
                Address? address)?
        business,
    required TResult orElse(),
  }) {
    if (business != null) {
      return business(id, name, description, identification, phoneNo, address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileBusiness value) business,
  }) {
    return business(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileBusiness value)? business,
    required TResult orElse(),
  }) {
    if (business != null) {
      return business(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ProfileBusinessToJson(this);
  }
}

abstract class _ProfileBusiness implements Profile {
  const factory _ProfileBusiness(
      {required int id,
      required String name,
      required String description,
      @JsonKey(name: 'id_no')
          required String identification,
      @JsonKey(name: 'contact', defaultValue: '')
          String? phoneNo,
      @JsonKey(excludeFromJson: true, excludeToJson: true)
          Address? address}) = _$_ProfileBusiness;

  factory _ProfileBusiness.fromJson(Map<String, dynamic> json) =
      _$_ProfileBusiness.fromJson;

  @override
  int get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'id_no')
  String get identification => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'contact', defaultValue: '')
  String? get phoneNo => throw _privateConstructorUsedError;
  @override
  @JsonKey(excludeFromJson: true, excludeToJson: true)
  Address? get address => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ProfileBusinessCopyWith<_ProfileBusiness> get copyWith =>
      throw _privateConstructorUsedError;
}
