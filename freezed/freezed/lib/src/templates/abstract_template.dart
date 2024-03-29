import 'package:freezed/src/models.dart';

import 'copy_with.dart';
import 'parameter_template.dart';
import 'properties.dart';
import 'prototypes.dart';

class Abstract {
  Abstract({
    required this.name,
    required this.genericsParameter,
    required this.genericsDefinition,
    required this.abstractProperties,
    required this.shouldGenerateJson,
    required this.allConstructors,
    required this.copyWith,
    required this.hasGenericArgumentFactories,
  });

  final String name;
  final List<Getter> abstractProperties;
  final GenericsParameterTemplate genericsParameter;
  final GenericsDefinitionTemplate genericsDefinition;
  final List<ConstructorDetails> allConstructors;
  final bool shouldGenerateJson;
  final CopyWith copyWith;
  final bool hasGenericArgumentFactories;

  @override
  String toString() {
    return '''
/// @nodoc
mixin _\$$name$genericsDefinition {

${abstractProperties.join()}

$_when
$_maybeWhen
$_map
$_maybeMap
$_toJson
${copyWith.abstractCopyWithGetter}
}

${copyWith.interface}

${copyWith.commonContreteImpl(abstractProperties)}
''';
  }

  String get _toJson {
    if (!shouldGenerateJson) return '';
    return 'Map<String, dynamic> toJson($_genericsToJsonArgs) => throw $privConstUsedErrorVarName;';
  }

  String get _when {
    if (!allConstructors.shouldGenerateUnions) return '';
    return '${whenPrototype(allConstructors)} => throw $privConstUsedErrorVarName;';
  }

  String get _maybeWhen {
    if (!allConstructors.shouldGenerateUnions) return '';
    return '${maybeWhenPrototype(allConstructors)} => throw $privConstUsedErrorVarName;';
  }

  String get _map {
    if (!allConstructors.shouldGenerateUnions) return '';
    return '${mapPrototype(allConstructors, genericsParameter)} => throw $privConstUsedErrorVarName;';
  }

  String get _maybeMap {
    if (!allConstructors.shouldGenerateUnions) return '';
    return '${maybeMapPrototype(allConstructors, genericsParameter)} => throw $privConstUsedErrorVarName;';
  }

  String get _genericsFromJsonArgsNames => hasGenericArgumentFactories
      ? genericsParameter.typeParameters.map((type) => ', fromJson$type').join()
      : '';

  String get _genericsFromJsonArgs => hasGenericArgumentFactories
      ? genericsParameter.typeParameters.map((type) {
          return ', $type Function(Object? json) fromJson$type';
        }).join()
      : '';

  static String genericsFromJsonArgsNames(bool hasGenericArgumentFactories,
          GenericsParameterTemplate genericsParameter) =>
      hasGenericArgumentFactories
          ? genericsParameter.typeParameters
              .map((type) => ', fromJson$type')
              .join()
          : '';

  static String genericsFromJsonArgs(bool hasGenericArgumentFactories,
          GenericsParameterTemplate genericsParameter) =>
      hasGenericArgumentFactories
          ? genericsParameter.typeParameters.map((type) {
              return ', $type Function(Object? json) fromJson$type';
            }).join()
          : '';

  String get _genericsToJsonArgs => hasGenericArgumentFactories
      ? genericsParameter.typeParameters.map((type) {
          return 'Object Function($type value) toJson$type';
        }).join(', ')
      : '';

  String get _genericsToJsonArgsNames => hasGenericArgumentFactories
      ? genericsParameter.typeParameters.map((type) => ', toJson$type').join()
      : '';

  static String genericsToJsonArgs(bool hasGenericArgumentFactories,
          GenericsParameterTemplate genericsParameter) =>
      hasGenericArgumentFactories
          ? genericsParameter.typeParameters.map((type) {
              return 'Object Function($type value) toJson$type';
            }).join(', ')
          : '';

  static String genericsToJsonArgsNames(bool hasGenericArgumentFactories,
          GenericsParameterTemplate genericsParameter) =>
      hasGenericArgumentFactories
          ? genericsParameter.typeParameters
              .map((type) => ', toJson$type')
              .join()
          : '';
}
