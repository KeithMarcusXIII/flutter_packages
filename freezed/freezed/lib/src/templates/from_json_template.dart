import 'package:collection/collection.dart';
import 'package:freezed/src/templates/parameter_template.dart';

import '../models.dart';
import 'abstract_template.dart';

class FromJson {
  FromJson({
    required this.name,
    required this.unionKey,
    required this.constructors,
    required this.genericsParameter,
    required this.genericDefinitions,
    required this.hasGenericArgumentFactories,
  });

  final String name;
  final String unionKey;
  final List<ConstructorDetails> constructors;
  final GenericsParameterTemplate genericsParameter;
  final GenericsDefinitionTemplate genericDefinitions;
  final bool hasGenericArgumentFactories;

  @override
  String toString() {
    String content;

    if (constructors.length == 1) {
      content =
          'return ${constructors.first.redirectedName}$genericsParameter.fromJson(json${Abstract.genericsFromJsonArgsNames(hasGenericArgumentFactories, genericsParameter)});';
    } else {
      final cases = constructors
          .where((element) => !element.isFallback)
          .map((constructor) {
        final caseName = constructor.unionValue;
        final concreteName = constructor.redirectedName;

        return '''
        case '$caseName':
          return $concreteName$genericsParameter.fromJson(json${Abstract.genericsFromJsonArgsNames(hasGenericArgumentFactories, genericsParameter)});
        ''';
      }).join();

      // TODO(rrousselGit): update logic once https://github.com/rrousselGit/freezed/pull/370 lands
      var defaultCase = 'throw FallThroughError();';
      final fallbackConstructor =
          constructors.singleWhereOrNull((element) => element.isFallback);
      if (fallbackConstructor != null) {
        defaultCase =
            'return ${fallbackConstructor.redirectedName}$genericsParameter.fromJson(json${Abstract.genericsFromJsonArgsNames(hasGenericArgumentFactories, genericsParameter)});';
      }

      content = '''
        switch (json['$unionKey'] as String) {
          $cases
          default:
            $defaultCase
        }
      ''';
    }

    return '''
$name$genericsParameter _\$${name}FromJson$genericDefinitions(Map<String, dynamic> json${Abstract.genericsFromJsonArgs(hasGenericArgumentFactories, genericsParameter)}) {
$content
}
''';
  }
}
