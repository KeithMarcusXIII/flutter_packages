import 'dart:ffi';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:api_annotations/api_annotations.dart' as api_annotations;
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart' show Freezed;
import 'package:source_gen/source_gen.dart';

class ApiGenerator extends GeneratorForAnnotation<api_annotations.RestApi> {
  static const String _baseUrlVar = 'baseUrl';
  static const _queryParamsVar = "queryParameters";
  static const _dataVar = "data";
  static const _localDataVar = "_data";
  static const _dioVar = "_dio";
  static const _extraVar = 'extra';
  static const _localExtraVar = '_extra';
  static const _contentType = 'contentType';
  static const _resultVar = "_result";
  static const _cancelToken = "cancelToken";
  static const _onSendProgress = "onSendProgress";
  static const _onReceiveProgress = "onReceiveProgress";
  static const _path = 'path';
  bool hasCustomOptions = false;

  /// Annotation details for [RestApi]
  late api_annotations.RestApi clientAnnotation;
  final _methodsAnnotations = const {
    api_annotations.GET,
    api_annotations.POST,
    api_annotations.DELETE,
    api_annotations.PUT,
    api_annotations.PATCH,
    api_annotations.HEAD,
    api_annotations.OPTIONS,
    api_annotations.Method,
  };

  ApiGenerator();

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      return _implementClass(element, annotation);
    }
    final String name = element.displayName;
    throw InvalidGenerationSourceError(
      'Generator cannot target `$name`.',
      todo: 'Remove the [RestApi] annotation from `$name`.',
    );
  }

  String _implementClass(ClassElement element, ConstantReader annotation) {
    final String className = element.name;
    final api_annotations.RestApi classAnnotation = api_annotations.RestApi(
        baseUrl: annotation.peek('baseUrl')?.stringValue ?? '');
    final String? baseUrl = classAnnotation.baseUrl;
    final List<ConstructorElement> constructorElements = element.constructors
        .where((constructor) =>
            !constructor.isFactory && !constructor.isDefaultConstructor)
        .toList();

    final Class _class = Class((classBuilder) {
      classBuilder
        ..name = '_$className'
        ..types.addAll(_generateClassTypes(element))
        ..fields.addAll(_generateClassFields())
        ..constructors.addAll(_generateConstructors(element, baseUrl))
        ..methods.addAll(_parseMethods(element));

      if (constructorElements.isEmpty) {
        classBuilder.implements
            .add(refer(_generateTypeParameterizedName(element)));
      } else {
        classBuilder.extend = refer(_generateTypeParameterizedName(element));
      }
      if (hasCustomOptions) {
        classBuilder.methods.add(_generateOptionsCastMethod());
      }
      classBuilder.methods.add(_generateTypeSetterMethod());
    });

    final emitter = DartEmitter();
    // print('${_class.accept(emitter)}');
    // return '';
    return DartFormatter().format('${_class.accept(emitter)}');
  }

  Iterable<Reference> _generateClassTypes(ClassElement element) {
    return element.typeParameters.map((tp) => refer(tp.name));
  }

  Iterable<Constructor> _generateConstructors(
    ClassElement element,
    String? url,
  ) {
    final List<Constructor> constructors = [];
    final List<ConstructorElement> constructorElements = element.constructors
        .where((constructor) =>
            !constructor.isFactory && !constructor.isDefaultConstructor)
        .toList();
    constructors.addAll(constructorElements
        .map((constructor) => _generateConstructor(url, element: constructor)));

    if (constructorElements.isEmpty) {
      constructors.add(_generateConstructor(url));
    }

    return constructors;
  }

  String _generateTypeParameterizedName(TypeParameterizedElement element) {
    return element.displayName +
        (element.typeParameters.isNotEmpty
            ? '<${element.typeParameters.join(',')}>'
            : '');
  }

  Method _generateOptionsCastMethod() {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'newRequestOptions'
        ..returns = refer('RequestOptions')
        ..requiredParameters.add(Parameter((parameterBuilder) {
          parameterBuilder.name = 'options';
          parameterBuilder.type = refer('Options?').type;
        }))
        ..body = Code('''
          if (options is RequestOptions) {
            return options as RequestOptions;
          }
          if (options == null) {
            return RequestOptions(path: '');
          }
          return RequestOptions(
            path: '',
            method: options.method,
            sendTimeout: options.sendTimeout,
            receiveTimeout: options.receiveTimeout,
            extra: options.extra,
            headers: options.headers,
            responseType: options.responseType,
            contentType: options.contentType.toString(),
            validateStatus: options.validateStatus,
            receiveDataWhenStatusError: options.receiveDataWhenStatusError,
            followRedirects: options.followRedirects,
            maxRedirects: options.maxRedirects,
            requestEncoder: options.requestEncoder,
            responseDecoder: options.responseDecoder,
          );
        ''');
    });
  }

  Method _generateTypeSetterMethod() {
    return Method((methodBuilder) {
      final Reference genericRef = refer('T');
      final Parameter optionsParam = Parameter((parameterBuilder) {
        parameterBuilder
          ..name = 'requestOptions'
          ..type = refer('RequestOptions');
      });

      methodBuilder
        ..name = '_setStreamType'
        ..types = ListBuilder([genericRef])
        ..returns = refer('RequestOptions')
        ..requiredParameters = ListBuilder([optionsParam])
        ..body = Code('''
          if (T != dynamic &&
              !(requestOptions.responseType == ResponseType.bytes ||
                  requestOptions.responseType == ResponseType.stream)) {
            if (T == String) {
              requestOptions.responseType = ResponseType.plain;
            } else {
              requestOptions.responseType = ResponseType.json;
            }
          }
          return requestOptions;
        ''');
    });
  }

  Constructor _generateConstructor(
    String? url, {
    ConstructorElement? element,
  }) {
    return Constructor((constructorBuilder) {
      constructorBuilder.requiredParameters.addAll([
        Parameter(
          (parameterBuilder) => parameterBuilder
            ..name = _dioVar
            ..toThis = true,
        ),
      ]);
      constructorBuilder.optionalParameters.addAll([
        Parameter(
          (parameterBuilder) => parameterBuilder
            ..name = _baseUrlVar
            ..named = true
            ..toThis = true,
        ),
      ]);

      if (element != null) {
        String superclassName = 'super';
        if (element.name.isNotEmpty) {
          superclassName += '.${element.name}';
          constructorBuilder.name = element.name;
        }
        final List<ParameterElement> constructorParams = element.parameters;
        constructorParams.forEach((param) {
          if (!param.isOptional || param.isPrivate) {
            constructorBuilder.requiredParameters.add(Parameter(
                (parameterBuilder) => parameterBuilder
                  ..type =
                      refer(param.type.getDisplayString(withNullability: false))
                  ..name = param.name));
          } else {
            constructorBuilder.optionalParameters.add(Parameter(
                (parameterBuilder) => parameterBuilder
                  ..named = param.isNamed
                  ..type =
                      refer(param.type.getDisplayString(withNullability: false))
                  ..name = param.name));
          }
        });
        final List<String> parameterListString = constructorParams
            .map((param) =>
                (param.isNamed ? '${param.name}: ' : '') + '${param.name}')
            .toList();
        constructorBuilder.initializers.add(
            Code('$superclassName(' + parameterListString.join(',') + ')'));
      }

      final List<Code> block = <Code>[
        if (url != null && url.isNotEmpty)
          Code('$_baseUrlVar ??= ${literal(url)};'),
      ];

      if (!block.isEmpty) {
        constructorBuilder.body = Block.of(block);
      }
    });
  }

  Iterable<Field> _generateClassFields() {
    return <Field>[
      Field((f) => f
        ..name = _dioVar
        ..type = refer('Dio')
        ..modifier = FieldModifier.final$),
      Field((f) => f
        ..name = _baseUrlVar
        ..type = refer('String?')
        ..modifier = FieldModifier.var$),
    ];
  }

  Expression _generateRequestPath(
      MethodElement element, ConstantReader httpAnnotation) {
    final Map<ParameterElement, ConstantReader> paths =
        _getMethodAnnotations(element, {api_annotations.Path});
    String? inheritedPath = httpAnnotation.peek('path')?.stringValue;
    paths.forEach((parameterElement, annotation) {
      final String path =
          annotation.peek('value')?.stringValue ?? parameterElement.displayName;
      inheritedPath = inheritedPath?.replaceFirst(
          '$path', '\$${parameterElement.displayName}');
    });

    return literal(inheritedPath);
  }

  Iterable<Code> _generateExtra(MethodElement element) {
    final List<Code> block = <Code>[];
    final DartObject? extra = TypeChecker.fromRuntime(api_annotations.Extra)
        .firstAnnotationOf(element, throwOnUnresolved: false);

    if (extra != null) {
      final ConstantReader extraAnnotation = ConstantReader(extra);
      final Map<DartObject?, DartObject?> extraMap =
          extraAnnotation.peek('data')?.mapValue ?? {};
      final Map<Object?, Object?> extraMapExp =
          extraMap.map((key, value) => MapEntry(
                (key?.toStringValue())!,
                value?.toBoolValue() ??
                    value?.toDoubleValue() ??
                    value?.toIntValue() ??
                    value?.toStringValue() ??
                    value?.toListValue() ??
                    value?.toMapValue() ??
                    value?.toSetValue() ??
                    value?.toSymbolValue() ??
                    value?.toTypeValue() ??
                    (value != null
                        ? Code(revivedLiteral(value))
                        : Code('null')),
              ));
      block.add(literalMap(
        extraMapExp,
        refer('String'),
        refer('dynamic'),
      ).statement);
    } else {
      block.add(literalMap({}, refer('String'), refer('dynamic'))
          .assignConst(_localExtraVar)
          .statement);
    }

    return block;
  }

  Iterable<Code> _generateRequestQueries(MethodElement element) {
    final List<Code> block = <Code>[];

    final Map<ParameterElement, ConstantReader> queryAnnotations =
        _getMethodAnnotations(element, {api_annotations.Query});
    final Map<Expression, Expression> queryParameters =
        queryAnnotations.map((param, annotation) {
      final String key =
          annotation.peek('value')?.stringValue ?? param.displayName;
      final Expression value = (_isBasicType(param.type) ||
              param.type.isDartCoreList ||
              param.type.isDartCoreMap)
          ? refer(param.displayName)
          : param.type.nullabilitySuffix == NullabilitySuffix.question
              ? refer(param.displayName).nullSafeProperty('toJson').call([])
              : refer(param.displayName).property('toJson').call([]);

      return MapEntry(literalString(key, raw: true), value);
    });

    final Map<ParameterElement, ConstantReader> queriesAnnotation =
        _getMethodAnnotations(element, {api_annotations.Queries});
    block.add(literalMap(queryParameters, refer('String'), refer('dynamic'))
        .assignFinal(_queryParamsVar)
        .statement);

    queriesAnnotation.forEach((parameterElement, annotation) {
      final DartType type = parameterElement.type;
      final String displayName = parameterElement.displayName;
      final Expression value =
          (_isBasicType(type) || type.isDartCoreList || type.isDartCoreMap)
              ? refer(displayName)
              : type.nullabilitySuffix == NullabilitySuffix.question
                  ? refer(displayName).nullSafeProperty('toJson').call([])
                  : refer(displayName).property('toJson').call([]);

      /// workaround until this is merged in code_builder
      /// https://github.com/dart-lang/code_builder/pull/269
      final emitter = DartEmitter();
      final buffer = StringBuffer();
      value.accept(emitter, buffer);
      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        refer('?? <String,dynamic>{}').accept(emitter, buffer);
      }
      final expression = refer(buffer.toString());

      block.add(refer('$_queryParamsVar.addAll').call([expression]).statement);
    });

    if (element.parameters
        .where((parameterElement) =>
            parameterElement.type.nullabilitySuffix ==
            NullabilitySuffix.question)
        .isNotEmpty) {
      block.add(Code('$_queryParamsVar.removeWhere((k, v) => v == null);'));
    }

    return block;
  }

  Map<String, Expression> _generateRequestHeaders(MethodElement element) {
    final ConstantReader? headersAnnotation = _getMethodAnnotation(
      element,
      {api_annotations.Headers},
    );
    final Map<DartObject?, DartObject?> headersMap =
        headersAnnotation?.peek('value')?.mapValue ?? {};
    final Map<String, Expression> headers = headersMap.map((key, value) =>
        MapEntry(
            key?.toStringValue() ?? 'null', literal(value?.toStringValue())));

    final Map<ParameterElement, ConstantReader> headerInParametersAnnotations =
        _getMethodAnnotations(element, {api_annotations.Header});
    final Map<String, Expression> headersInParameters =
        headerInParametersAnnotations.map((key, value) {
      final String headerName =
          value.peek('value')?.stringValue ?? key.displayName;
      return MapEntry(headerName, refer(key.displayName));
    });
    headers.addAll(headersInParameters);

    return headers;
  }

  Iterable<Code> _generateRequestBody(MethodElement element) {
    final List<Code> block = <Code>[];
    final bool hasBody =
        _getMethodAnnotation(element, {api_annotations.NoBody}) != null;

    if (hasBody) {
      block.add(
          refer('null').assignFinal(_localDataVar, refer('String?')).statement);
      return block;
    }

    final ConstantReader? bodyAnnotation =
        _getMethodAnnotation(element, {api_annotations.Body});
    final ParameterElement? bodyParameter =
        _getMethodParameter(element, {api_annotations.Body});

    if (bodyParameter != null) {
      final bool nullToAbsent =
          bodyAnnotation?.peek('nullToAbsent')?.boolValue ?? false;
      final Element? bodyTypeElement = bodyParameter.type.element;

      if (TypeChecker.fromRuntime(Map)
          .isAssignableFromType(bodyParameter.type)) {
        block.add(literalMap({}, refer('String'), refer('dynamic'))
            .assignFinal(_localDataVar)
            .statement);

        block.add(refer('$_localDataVar.addAll').call([
          refer(
              '${bodyParameter.displayName}${element.type.nullabilitySuffix == NullabilitySuffix.question ? '?? <String, dynamic>{}' : ''}')
        ]).statement);
        if (nullToAbsent) {
          block.add(Code('$_dataVar.removeWhere((k, v) => v == null);'));
        }
      } else if (bodyTypeElement != null &&
          (TypeChecker.fromRuntime(List).isExactly(bodyTypeElement) &&
              !_hasBasicGeneric(bodyParameter.type))) {
        block.add(refer(
                '${bodyParameter.displayName}.map((e) => e.toJson()).toList()')
            .assignFinal(_localDataVar)
            .statement);
      } else if (bodyTypeElement != null &&
          TypeChecker.fromRuntime(File).isExactly(bodyTypeElement)) {
        block.add(refer('Stream')
            .property('fromIterable')
            .call([
              refer(
                  '${bodyParameter.displayName}.readAsBytesSync().map((i) => [i])')
            ])
            .assignFinal(_localDataVar)
            .statement);
      } else if (bodyTypeElement is ClassElement) {
        final ClassElement bodyClassElement = bodyTypeElement;
        final MethodElement? toJsonMethodElement =
            bodyClassElement.lookUpMethod('toJson', bodyClassElement.library);

        if (toJsonMethodElement == null) {
          log.warning(
              "${bodyParameter.type.getDisplayString(withNullability: false)} must provide a `toJson()` method which return a Map.\n"
              "It is programmer's responsibility to make sure the ${bodyParameter.type.getDisplayString(withNullability: false)} is properly serialized");
          block.add(refer(bodyParameter.displayName)
              .assignFinal(_localDataVar)
              .statement);
        } else {
          block.add(literalMap({}, refer('String'), refer('dynamic'))
              .assignFinal(_localDataVar)
              .statement);

          if (bodyParameter.type.nullabilitySuffix !=
              NullabilitySuffix.question) {
            block.add(refer('$_localDataVar.addAll').call(
                [refer('${bodyParameter.displayName}.toJson()')]).statement);
          } else {
            block.add(refer('$_localDataVar.addAll').call([
              refer(
                  '${bodyParameter.displayName}?.toJson() ?? <String, dynamic>{}')
            ]).statement);
          }

          if (nullToAbsent) {
            block.add(Code('$_localDataVar.removeWhere((k, v) => v == null);'));
          }
        }
      } else {
        block.add(refer(bodyParameter.displayName)
            .assignFinal(_localDataVar)
            .statement);
      }

      return block;
    }

    bool anyNullable = false;
    final Map<Expression, Reference> fields =
        _getMethodAnnotations(element, {api_annotations.Field})
            .map((parameterElement, annotation) {
      anyNullable |=
          parameterElement.type.nullabilitySuffix == NullabilitySuffix.question;
      final String fieldName =
          annotation.peek('value')?.stringValue ?? parameterElement.displayName;
      final bool isFileField = TypeChecker.fromRuntime(File)
          .isAssignableFromType(parameterElement.type);

      if (isFileField) {}

      return MapEntry(literal(fieldName), refer(parameterElement.displayName));
    });

    if (fields.isNotEmpty) {
      block.add(literalMap(fields).assignFinal(_localDataVar).statement);
      if (anyNullable) {
        block.add(Code('$_localDataVar.removeWhere((k, v) => v == null);'));
      }
      return block;
    }

    final List<Code> partRequest = _generatePartRequest(element);

    if (partRequest.isNotEmpty) {
      block.addAll(partRequest);
      return block;
    }

    /// There is no body
    block.add(literalMap({}, refer("String"), refer("dynamic"))
        .assignFinal(_localDataVar)
        .statement);

    return block;
  }

  List<Code> _generatePartRequest(MethodElement element) {
    final List<Code> block = <Code>[];
    final Map<ParameterElement, ConstantReader> parts =
        _getMethodAnnotations(element, {api_annotations.Part});
    final List<ParameterElement> parameters = element.parameters;
    // final DartType elementType = element.type;

    if (parts.isNotEmpty) {
      if (parameters.length == 1 && parameters.first.type.isDartCoreMap) {
        block.add(refer('FormData')
            .newInstanceNamed(
                'fromMap', [CodeExpression(Code(parameters.first.displayName))])
            .assignFinal(_dataVar)
            .statement);

        return block;
      }

      block.add(refer('FormData')
          .newInstance([])
          .assignFinal(_localDataVar)
          .statement);

      parts.forEach((partParameter, annotation) {
        final DartType partParameterType = partParameter.type;
        final String fieldName = annotation.peek('name')?.stringValue ??
            annotation.peek('value')?.stringValue ??
            partParameter.displayName;
        final String? contentType = annotation.peek('contentType')?.stringValue;
        final bool isFileField = TypeChecker.fromRuntime(File)
            .isAssignableFromType(partParameter.type);

        if (isFileField) {
          final String? fileNameValue =
              annotation.peek('fileName')?.stringValue;
          final Expression fileName = fileNameValue != null
              ? literalString(fileNameValue)
              : refer(partParameter.displayName)
                  .property('path.split(Platform.pathSeparator).last');

          final Expression uploadFileInfo =
              refer('$MultipartFile.fromFileSync').call([
            refer(partParameter.displayName).property('path')
          ], {
            'filename': fileName,
            if (contentType != null)
              'contentType':
                  refer('MediaType', 'package:http_parser/http_parser.dart')
                      .property('parse')
                      .call([literal(contentType)])
          });

          final bool hasOptionalParameters = (parameters
                      .cast<ParameterElement?>())
                  .firstWhere(
                      (parameter) =>
                          parameter?.displayName == partParameter.displayName,
                      orElse: () => null)
                  ?.isOptional ??
              false;
          final Code returnCode =
              refer(_localDataVar).property('files').property('add').call([
            refer('MapEntry').newInstance([literal(fieldName), uploadFileInfo])
          ]).statement;

          if (hasOptionalParameters) {
            final Code condition =
                refer(element.displayName).notEqualTo(literalNull).code;

            block.addAll([
              Code('if('),
              condition,
              Code(') {'),
              returnCode,
              Code('}'),
            ]);
          } else {
            block.add(returnCode);
          }
        } else if (partParameterType.getDisplayString(withNullability: false) ==
            'List<int>') {
          final String? fileName = annotation.peek("fileName")?.stringValue;
          final String contentTypeExpString = contentType == null
              ? ''
              : 'contentType: MediaType.parse(${literal(contentType)}),';

          block
              .add(refer(_localDataVar).property('files').property('add').call([
            refer('''
              MapEntry(
                '${fieldName}',
                MultipartFile.fromBytes(
                  ${partParameter.displayName},
                  filename: ${literal(fileName ?? null)},
                  $contentTypeExpString
                ),
              )
            ''')
          ]).statement);
        } else if (TypeChecker.fromRuntime(List)
            .isExactlyType(partParameterType)) {
          final DartType? genericType = _genericOf(partParameterType);

          if (genericType!.getDisplayString(withNullability: false) ==
              'List<int>') {
            final String? fileName = annotation.peek('fileName')?.stringValue;
            final String contentTypeExpString = contentType == null
                ? ''
                : 'contentType: MediaType.parse(${literal(contentType)}),';

            block.add(
                refer(_localDataVar).property('files').property('addAll').call([
              refer('''
                ${partParameter.displayName}.map(
                  (i) => MapEntry(
                    '${fieldName}',
                    MultipartFile.fromBytes(
                      i,
                      filename: ${literal(fileName ?? null)},
                      $contentTypeExpString
                    ),
                  ),
                )
              ''')
            ]).statement);
          } else if (_isBasicType(genericType) ||
              (genericType != null &&
                  (TypeChecker.fromRuntime(Map).isExactlyType(genericType) ||
                      TypeChecker.fromRuntime(List)
                          .isExactlyType(genericType)))) {
            final String genericTypeString =
                _isBasicType(genericType) ? 'i' : 'jsonEncode(i)';
            final String nullabilitySuffixString =
                partParameterType.nullabilitySuffix ==
                        NullabilitySuffix.question
                    ? '?'
                    : '';

            block.add(refer('''
                ${partParameter.displayName}${nullabilitySuffixString}.forEach((i) {
                  ${_localDataVar}.fields.add(MapEntry(${literal(fieldName)}, ${genericTypeString}));
                })
              ''').statement);
          } else if (genericType != null &&
              TypeChecker.fromRuntime(File).isExactlyType(genericType)) {
            final String contentTypeParamString = contentType == null
                ? ''
                : 'contentType: MediaType.parse(${literal(contentType)})';

            final Expression fileMapExp = refer('''
                ${partParameter.displayName}.map(
                  (i) => MapEntry(
                    '${fieldName}',
                    MultipartFile.fromFileSync(
                      i.path,
                      filename: i.path.split(Platform.pathSeparator).last,
                      ${contentTypeParamString}
                    ),
                  ),
                )
              ''');

            block.add(refer(_localDataVar)
                .property('files')
                .property('addAll')
                .call([fileMapExp]).statement);
          } else if (genericType != null &&
              TypeChecker.fromRuntime(MultipartFile)
                  .isExactlyType(genericType)) {
            final Expression filesExp = refer('''
                ${partParameter.displayName}.map(
                  (i) => MapEntry(
                    ${fieldName},
                    i,
                  ),
                );
              ''');

            block.add(
                refer(_dataVar).property('addAll').call([filesExp]).statement);
          } else if (genericType.element is ClassElement) {
            final ClassElement genericClassElement =
                genericType.element as ClassElement;
            final MethodElement? toJsonElement = genericClassElement
                .lookUpMethod('toJson', genericClassElement.library);

            if (toJsonElement == null) {
            } else {
              final Expression fieldExp = refer('MapEntry').newInstance([
                literal(fieldName),
                refer('jsonEncode(${partParameter.displayName})'),
              ]);
              block.add(refer(_localDataVar)
                  .property('fields')
                  .property('add')
                  .call([fieldExp]).statement);
            }
          } else {
            throw Exception();
          }
        } else if (_isBasicType(partParameterType)) {
          if (partParameterType.nullabilitySuffix ==
              NullabilitySuffix.question) {
            block.add(Code('if (${partParameter.displayName} != null) {'));
          }
          block.add(
              refer(_localDataVar).property('fields').property('add').call([
            refer('MapEntry').newInstance([
              literal(fieldName),
              if (TypeChecker.fromRuntime(String)
                  .isExactlyType(partParameterType))
                refer(partParameter.displayName)
              else
                refer(partParameter.displayName).property('toString').call([])
            ])
          ]).statement);
          if (partParameterType.nullabilitySuffix ==
              NullabilitySuffix.question) {
            block.add(Code('}'));
          }
        } else if (TypeChecker.fromRuntime(Map)
            .isExactlyType(partParameterType)) {
          final Expression fieldExp = refer('MapEntry').newInstance([
            literal(fieldName),
            refer('jsonEncode(${partParameter.displayName})'),
          ]);
          block.add(refer(_localDataVar)
              .property('fields')
              .property('add')
              .call([fieldExp]).statement);
        } else if (partParameterType.element is ClassElement) {
          final ClassElement partParameterClassElement =
              partParameterType.element as ClassElement;
          final MethodElement? toJsonElement = partParameterClassElement
              .lookUpMethod('toJson', partParameterClassElement.library);

          if (toJsonElement == null) {
          } else {
            final Expression fieldExp = refer('MapEntry').newInstance([
              literal(fieldName),
              refer(
                  'jsonEncode(${partParameter.displayName}${partParameterType.nullabilitySuffix == NullabilitySuffix.question ? '?? <String, dynamic>{}' : ''})'),
            ]);
            block.add(refer(_localDataVar)
                .property('fields')
                .property('add')
                .call([fieldExp]).statement);
          }
        } else {
          final Expression fieldExp = refer('MapEntry').newInstance([
            literal(fieldName),
            refer('${partParameter.displayName}'),
          ]);
          block.add(refer(_dataVar)
              .property('fields')
              .property('add')
              .call([fieldExp]).statement);
        }
      });
      return block;
    }

    return block;
  }

  Block _generateRequest(MethodElement element, ConstantReader httpAnnotation) {
    final String returnTypeString =
        element.returnType.isDartAsyncFuture ? 'return' : 'yield';
    final Expression path = _generateRequestPath(element, httpAnnotation);
    final List<Code> block = <Code>[];

    final List<Code> extraBlock = _generateExtra(element).toList();
    block.addAll(extraBlock);

    final List<Code> queriesBlock = _generateRequestQueries(element).toList();
    block.addAll(queriesBlock);

    final Map<String, Expression> headers = _generateRequestHeaders(element);

    final List<Code> bodyBlock = _generateRequestBody(element).toList();
    block.addAll(bodyBlock);

    final Map<String, Expression> extraOptions = {
      'method': literal(httpAnnotation.peek('method')?.stringValue),
      'headers': literalMap(
          headers.map((key, value) => MapEntry(
                literalString(key, raw: true),
                value,
              )),
          refer('String'),
          refer('dynamic')),
      _extraVar: refer(_localExtraVar),
    };

    final Expression? contentType = headers.entries
        .cast<MapEntry<String, Expression>?>()
        .firstWhere(
            (exp) => 'Content-Type'.toLowerCase() == exp?.key.toLowerCase(),
            orElse: () => null)
        ?.value;
    if (contentType != null) {
      extraOptions[_contentType] = contentType;
    }

    final ConstantReader? contentTypeAnnot =
        _getMethodAnnotation(element, {api_annotations.FormUrlEncoded});
    if (contentTypeAnnot != null) {
      extraOptions[_contentType] =
          literal(contentTypeAnnot.peek('mime')?.stringValue);
    }
    extraOptions[_baseUrlVar] = refer(_baseUrlVar);

    final ConstantReader? responseTypeAnnot =
        _getMethodAnnotation(element, {api_annotations.DioResponseType});
    if (responseTypeAnnot != null) {
      final ResponseType responseType = ResponseType.values.firstWhere((type) =>
          responseTypeAnnot
              .peek('responseType')
              ?.objectValue
              .toString()
              .toString()
              .contains(type.toString().split('.')[1]) ??
          false);

      extraOptions['responseType'] = refer(responseType.toString());
    }

    final Map<String, Expression> namedArguments = <String, Expression>{};
    namedArguments[_queryParamsVar] = refer(_queryParamsVar);
    namedArguments[_path] = path;
    namedArguments[_dataVar] = refer(_localDataVar);

    final ParameterElement? cancelTokenParam =
        _getMethodParameter(element, {api_annotations.CancelRequest});
    if (cancelTokenParam != null) {
      namedArguments[_cancelToken] = refer(cancelTokenParam.displayName);
    }
    final ParameterElement? sendProgressParam =
        _getMethodParameter(element, {api_annotations.SendProgress});
    if (sendProgressParam != null) {
      namedArguments[_onSendProgress] = refer(sendProgressParam.displayName);
    }
    final ParameterElement? receiveProgressParam =
        _getMethodParameter(element, {api_annotations.ReceiveProgress});
    if (receiveProgressParam != null) {
      namedArguments[_onReceiveProgress] =
          refer(receiveProgressParam.displayName);
    }

    final DartType? returnInnerType = _genericOf(element.returnType);
    final Map<String, Expression> optionsExps =
        _parseOptions(element, namedArguments, extraOptions);
    final Expression? options = optionsExps['options'];
    final List<Code> newOptionsBlock =
        (Map<String, Expression>.from(optionsExps)
              ..removeWhere((key, value) => key == 'options'))
            .values
            .map((exp) => exp.statement)
            .toList();

    block.addAll(newOptionsBlock);

    if (options != null) {
      /// if autoCastResponse is false, return the response as it is
      // block.add(refer('$_dioVar.fetch').call([options]).returned.statement);
      // return Block.of(block);

      if (returnInnerType == null || 'void' == returnInnerType.toString()) {
        block.add(refer('await $_dioVar.fetch')
            .call([options], {}, [refer('void')]).statement);
        block.add(Code('$returnTypeString null;'));

        return Block.of(block);
      }

      final bool isResponseType =
          TypeChecker.fromRuntime(api_annotations.HttpResponse)
              .isExactlyType(returnInnerType);
      final DartType? returnType =
          isResponseType ? _genericOf(returnInnerType) : returnInnerType;

      if (returnType == null || 'void' == returnType.toString()) {
        if (isResponseType) {
          block.add(refer('final $_resultVar = await $_dioVar.fetch')
              .call([options], {}, [refer('void')]).statement);
          block.add(Code('''
            final httpResponse = HttpResponse(null, $_resultVar);
            $returnTypeString httpResponse;
          '''));
        } else {
          block.add(refer('await $_dioVar.fetch')
              .call([options], {}, [refer('void')]).statement);
          block.add(Code('$returnTypeString null;'));
        }
      } else {
        final DartType? innerReturnType = _getResponseInnerType(returnType);
        final Reference resultDataRef = refer('$_resultVar.data');

        if (TypeChecker.fromRuntime(List).isExactlyType(returnType)) {
          if (_isBasicType(innerReturnType)) {
            block.add(refer('await $_dioVar.fetch<List<dynamic>>')
                .call([options])
                .assignFinal(_resultVar)
                .statement);
            block.add((returnType.nullabilitySuffix ==
                        NullabilitySuffix.question
                    ? resultDataRef.nullSafeProperty('cast')
                    : refer('${resultDataRef.symbol}!').property('cast'))
                .call([], {}, [
                  refer(
                      innerReturnType!.getDisplayString(withNullability: false))
                ])
                .assignFinal('value')
                .statement);
          } else {
            block.add(refer('await $_dioVar.fetch<List<dynamic>>')
                .call([options])
                .assignFinal(_resultVar)
                .statement);
            final Reference mapperRef = refer(
                '(dynamic i) => ${innerReturnType!.getDisplayString(withNullability: false)}.fromJson(i as Map<String, dynamic>)');
            block.add(
                (returnType.nullabilitySuffix == NullabilitySuffix.question
                        ? resultDataRef.nullSafeProperty('map')
                        : refer('${resultDataRef.symbol}!').property('map'))
                    .call([mapperRef])
                    .property('toList')
                    .call([])
                    .assignVar('value')
                    .statement);
          }
        } else if (TypeChecker.fromRuntime(Map).isExactlyType(returnType)) {
          final List<DartType>? types = _genericListOf(returnType);
          block.add(refer('await $_dioVar.fetch<Map<String, dynamic>>')
              .call([options])
              .assignFinal(_resultVar)
              .statement);

          if (types != null && types.length > 1) {
            final DartType secondType = types[1];
            if (TypeChecker.fromRuntime(List).isExactlyType(returnType)) {
              final DartType? type = _genericOf(secondType);

              Reference mapperRef = refer('''
                (key, dynamic value) => MapEntry(
                    key,
                    (value as List)
                        .map((e) => ${type!.getDisplayString(withNullability: false)}.fromJson(e as Map<String, dynamic>))
                        .toList(),
                )
              ''');

              block.add(
                  (returnType.nullabilitySuffix == NullabilitySuffix.question
                          ? resultDataRef.nullSafeProperty('map')
                          : refer('${resultDataRef.symbol}!').property('map'))
                      .call([mapperRef])
                      .assignVar('value')
                      .statement);
            } else if (!_isBasicType(secondType)) {
              Reference mapperRef = refer('''
                (key, dynamic value) => MapEntry(
                    key,
                    ${secondType.getDisplayString(withNullability: false)}.fromJson(value as Map<String, dynamic>),
                )
              ''');

              block.add(
                  (returnType.nullabilitySuffix == NullabilitySuffix.question
                          ? resultDataRef.nullSafeProperty('map')
                          : refer('${resultDataRef.symbol}!').property('map'))
                      .call([mapperRef])
                      .assignVar('value')
                      .statement);
            }
          } else {
            block.add(Code('final value = $_resultVar.data!;'));
          }
        } else {
          if (_isBasicType(returnType)) {
            block.add(refer(
                    'await $_dioVar.fetch<${returnType.getDisplayString(withNullability: false)}>')
                .call([options])
                .assignFinal(_resultVar)
                .statement);
            final Reference resultDataRef = refer('$_resultVar.data');
            block.add(
                (returnType.nullabilitySuffix == NullabilitySuffix.question
                        ? resultDataRef
                        : refer('${resultDataRef.symbol}!'))
                    .assignFinal('value')
                    .statement);
          } else if (returnType.toString() == 'dynamic') {
            block.add(refer('await $_dioVar.fetch')
                .call([options])
                .assignFinal(_resultVar)
                .statement);
            block.add(Code('final value = $_resultVar.data;'));
          } else {
            block.add(refer('await $_dioVar.fetch<Map<String, dynamic>>')
                .call([options])
                .assignFinal(_resultVar)
                .statement);
            Reference mapperRef;
            final bool isGenericArgumentFactories =
                _isGenericArgumentFactories(returnType);
            final List typeArgs =
                returnType is ParameterizedType ? returnType.typeArguments : [];

            if (typeArgs.length > 0 && isGenericArgumentFactories) {
              mapperRef = refer(
                  '${returnType.getDisplayString(withNullability: false)}.fromJson($_resultVar.data!,${_getInnerJsonSerializableMapperCodeString(returnType)})');
            } else {
              mapperRef = refer(
                  '${returnType.getDisplayString(withNullability: false)}.fromJson($_resultVar.data!)');
            }

            final Reference resultDataRef = refer('$_resultVar.data');
            block.add(
                (returnType.nullabilitySuffix == NullabilitySuffix.question
                        ? resultDataRef
                            .equalTo(literalNull)
                            .conditional(literalNull, mapperRef)
                        : mapperRef)
                    .assignFinal('value')
                    .statement);
          }
        }

        if (isResponseType) {
          block.add(Code('''
            final httpResponse = HttpResponse(value, $_resultVar);
            $returnTypeString httpResponse;
          '''));
        } else {
          block.add(Code('$returnTypeString value;'));
        }
      }

      return Block.of(block);
    }

    return Block();
  }

  bool _isBasicType(DartType? type) {
    if (type == null) {
      return false;
    }

    return TypeChecker.any([
      TypeChecker.fromRuntime(String),
      TypeChecker.fromRuntime(bool),
      TypeChecker.fromRuntime(int),
      TypeChecker.fromRuntime(double),
      TypeChecker.fromRuntime(num),
      TypeChecker.fromRuntime(Double),
      TypeChecker.fromRuntime(Float),
    ]).isExactlyType(type);
  }

  DartType? _genericOf(DartType type) {
    return type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
  }

  List<DartType>? _genericListOf(DartType type) {
    return type is ParameterizedType && type.typeArguments.isNotEmpty
        ? type.typeArguments
        : null;
  }

  bool _isGenericArgumentFactories(DartType? type) {
    final List<ElementAnnotation>? metadata = type?.element?.metadata;
    if (metadata == null || type == null) {
      return false;
    }
    final DartObject? constDartObject =
        metadata.isNotEmpty ? metadata.first.computeConstantValue() : null;

    bool genericArgumentFactories = false;
    if (constDartObject != null &&
        !TypeChecker.fromRuntime(List).isExactlyType(type)) {
      /* final ClassElement? constDartClassElement =
          constDartObject.type?.element as ClassElement?; */
      final ClassElement constDartClassElement = type.element as ClassElement;

      if (constDartClassElement != null) {
        for (var element in constDartClassElement.constructors) {
          final DartObject? _constDartObject = element.metadata.isNotEmpty
              ? element.metadata.first.computeConstantValue()
              : null;
          final ConstantReader _annotation = ConstantReader(_constDartObject);
          final ConstantReader? _annotatedObject =
              _annotation.peek('genericArgumentFactories');
          genericArgumentFactories = _annotatedObject?.boolValue ?? false;

          return genericArgumentFactories;
        }
      }

      try {
        final ConstantReader annotation = ConstantReader(constDartObject);
        final ConstantReader? annotatedObject =
            annotation.peek('genericArgumentFactories');
        genericArgumentFactories = annotatedObject?.boolValue ?? false;
      } catch (e) {}
    }

    return genericArgumentFactories;
  }

  String _getInnerJsonSerializableMapperCodeString(DartType type) {
    List typeArgs = type is ParameterizedType ? type.typeArguments : [];
    if (typeArgs.length > 0) {
      if (TypeChecker.fromRuntime(List).isExactlyType(type)) {
        final DartType? genericType = _genericOf(type);
        typeArgs =
            genericType is ParameterizedType ? genericType.typeArguments : [];
        var mapperCodeString;
        var genericTypeString =
            '${genericType?.getDisplayString(withNullability: false)}';

        if (typeArgs.length > 0 &&
            _isGenericArgumentFactories(genericType) &&
            genericType != null) {
          mapperCodeString = '''
            (json) => (json as List<dynamic>)
                .map<${genericTypeString}>((i) => ${genericTypeString}.fromJson(
                      i as Map<String, dynamic>
                      ${_getInnerJsonSerializableMapperCodeString(genericType)}
                    ))
                .toList(),
          ''';
        } else {
          if (_isBasicType(genericType)) {
            mapperCodeString = '''
              (json) => (json as List<dynamic>)
                .map<${genericTypeString}>(
                  (i) => i as ${genericTypeString}
                )
                .toList(),
            ''';
          } else {
            mapperCodeString = '''
              (json) => (json as List<dynamic>)
                .map<${genericTypeString}>(
                  (i) => ${genericTypeString == 'dynamic' ? 'i as Map<String, dynamic>' : genericTypeString + '.fromJson(i as Map<String, dynamic>)'},
                )
                .toList(),
            ''';
          }
        }
        return mapperCodeString;
      } else {
        String mappedCodeString = '';
        for (DartType arg in typeArgs) {
          final List typeArgs =
              arg is ParameterizedType ? arg.typeArguments : [];
          if (typeArgs.length > 0) {
            if (TypeChecker.fromRuntime(List).isExactlyType(arg)) {
              mappedCodeString +=
                  '${_getInnerJsonSerializableMapperCodeString(arg)}';
            } else {
              if (_isGenericArgumentFactories(arg)) {
                mappedCodeString +=
                    '(json) => ${arg.getDisplayString(withNullability: false)}.fromJson(json as Map<String, dynamic>,${_getInnerJsonSerializableMapperCodeString(arg)}),';
              } else {
                mappedCodeString +=
                    '(json) => ${arg.getDisplayString(withNullability: false)}.fromJson(json as Map<String, dynamic>),';
              }
            }
          } else {
            mappedCodeString +=
                '${_getInnerJsonSerializableMapperCodeString(arg)}';
          }
        }
        return mappedCodeString;
      }
    } else {
      if (type.getDisplayString(withNullability: false) == 'dynamic' ||
          _isBasicType(type)) {
        return '(json) => json as ${type.getDisplayString(withNullability: false)},';
      } else {
        return '(json) => ${type.getDisplayString(withNullability: false)}.fromJson(json as Map<String, dynamic>),';
      }
    }
  }

  DartType? _getResponseInnerType(DartType type) {
    final DartType? genericType = _genericOf(type);

    if (genericType == null ||
        TypeChecker.fromRuntime(Map).isExactlyType(type)) {
      return type;
    }

    if (genericType.isDynamic) {
      return null;
    }

    if (TypeChecker.fromRuntime(Map).isExactlyType(type)) {
      return type;
    }

    if (TypeChecker.fromRuntime(List).isExactlyType(type)) {
      return genericType;
    }

    return _getResponseInnerType(genericType);
  }

  bool _hasBasicGeneric(DartType type) {
    return _isBasicType(_genericOf(type));
  }

  Iterable<Method> _parseMethods(ClassElement element) {
    final List<MethodElement> methodElements = <MethodElement>[];
    methodElements
      ..addAll(element.methods)
      ..addAll(element.mixins.expand((mixin) => mixin.methods));

    final methods = methodElements.where((element) {
      final ConstantReader? methodAnnot =
          _getMethodAnnotation(element, _methodsAnnotations);
      return methodAnnot != null &&
          element.isAbstract &&
          (element.returnType.isDartAsyncFuture ||
              element.returnType.isDartAsyncStream);
    }).map((element) => _generateMethod(element)!);

    return methods;
  }

  ConstantReader? _getMethodAnnotation(
    MethodElement element, [
    Set<Type> types = const {},
  ]) {
    final DartObject? annotation = TypeChecker.any(types
            .toList()
            .map((annotationType) => TypeChecker.fromRuntime(annotationType)))
        .firstAnnotationOf(element);

    if (annotation != null) {
      return ConstantReader(annotation);
    }

    return null;
  }

  ParameterElement? _getMethodParameter(
    MethodElement element, [
    Set<Type> types = const {},
  ]) {
    for (final p in element.parameters) {
      final DartObject? a = TypeChecker.any(types
              .toList()
              .map((annotationType) => TypeChecker.fromRuntime(annotationType)))
          .firstAnnotationOf(p);
      if (a != null) {
        return p;
      }
    }

    return null;
    /* final List<ParameterElement> _parameters = element.parameters;

    final ParameterElement? parameter =
        _parameters.cast<ParameterElement?>().firstWhere(
      (element) {
        final DartObject? annotation = TypeChecker.any(types.map(
                (annotationType) => TypeChecker.fromRuntime(annotationType)))
            .firstAnnotationOf(element!);

        return annotation != null;
      },
      orElse: () => null,
    );

    return parameter; */
  }

  Map<ParameterElement, ConstantReader> _getMethodAnnotations(
    MethodElement element, [
    Set<Type> types = const {},
  ]) {
    Map<ParameterElement, ConstantReader> annotations = {};
    element.parameters.forEach((parameterElement) {
      final DartObject? annotation = TypeChecker.any(types
              .map((annotationType) => TypeChecker.fromRuntime(annotationType)))
          .firstAnnotationOf(parameterElement);
      if (annotation != null) {
        annotations[parameterElement] = ConstantReader(annotation);
      }
    });

    return annotations;
  }

  Method? _generateMethod(MethodElement element) {
    final ConstantReader? httpMethodAnnotation =
        _getMethodAnnotation(element, _methodsAnnotations);
    if (httpMethodAnnotation == null) {
      return null;
    }
    return Method((methodBuilder) {
      // final List<ParameterElement> parameterElements = element.parameters;
      // final List<ParameterElement> positionalParameterElements =
      //     element.parameters.where((pe) => pe.isRequiredPositional).toList();

      methodBuilder
        ..returns = refer(
            element.type.returnType.getDisplayString(withNullability: true))
        ..name = element.name
        ..types.addAll(element.typeParameters.map((tp) => refer(tp.name)))
        ..modifier = element.returnType.isDartAsyncFuture
            ? MethodModifier.async
            : MethodModifier.asyncStar
        ..annotations.add(CodeExpression(Code('override')));

      methodBuilder.requiredParameters.addAll(element.parameters
          .where((pe) => pe.isRequiredPositional)
          .map((pe) => Parameter((parameterBuilder) => parameterBuilder
            ..name = pe.name
            ..named = pe.isNamed)));

      methodBuilder.optionalParameters.addAll(element.parameters
          .where((pe) => pe.isOptional || pe.isRequiredNamed)
          .map((pe) => Parameter((parameterBuilder) => parameterBuilder
            ..required = (pe.isNamed &&
                pe.type.nullabilitySuffix == NullabilitySuffix.none &&
                !pe.hasDefaultValue)
            ..name = pe.name
            ..named = pe.isNamed
            ..defaultTo = pe.defaultValueCode == null
                ? null
                : Code(pe.defaultValueCode!))));

      methodBuilder.body = _generateRequest(element, httpMethodAnnotation);
    });
  }

  Map<String, Expression> _parseOptions(
      MethodElement element,
      Map<String, Expression> namedArguments,
      Map<String, Expression> extraOptions) {
    final Map<String, Expression> optionsExp = <String, Expression>{};
    final ConstantReader? optionsAnnot =
        _getMethodAnnotation(element, {api_annotations.DioOptions});
    final ParameterElement? optionsParam =
        _getMethodParameter(element, {api_annotations.DioOptions});

    if (optionsParam == null) {
      final Map<String, Expression> arguments =
          Map<String, Expression>.from(extraOptions)..addAll(namedArguments);
      final Expression path = arguments.remove(_path)!;
      final Expression dataVar = arguments.remove(_dataVar)!;
      final Expression queryParams = arguments.remove(_queryParamsVar)!;
      final Expression baseUrl = arguments.remove(_baseUrlVar)!;
      final Expression? cancelToken = arguments.remove(_cancelToken);
      final Expression? sendProgress = arguments.remove(_onSendProgress);
      final Expression? receieveProgress = arguments.remove(_onReceiveProgress);

      final DartType? returnType = _genericOf(element.returnType);
      final String returnTypeDisplayString =
          returnType!.getDisplayString(withNullability: false);
      final Reference returnTypeRef = refer(returnTypeDisplayString);

      final Map<String, Expression> composeArguments = <String, Expression>{
        _queryParamsVar: queryParams,
        _dataVar: dataVar,
      };
      if (cancelToken != null) {
        composeArguments[_cancelToken] = cancelToken;
      }
      if (sendProgress != null) {
        composeArguments[_onSendProgress] = sendProgress;
      }
      if (receieveProgress != null) {
        composeArguments[_onReceiveProgress] = receieveProgress;
      }

      optionsExp['options'] = refer('_setStreamType').call([
        refer('Options')
            .newInstance([], arguments)
            .property('compose')
            .call(
              [refer(_dioVar).property('options'), path],
              composeArguments,
            )
            .property('copyWith')
            .call([], {
              _baseUrlVar: baseUrl.ifNullThen(
                  refer(_dioVar).property('options').property('baseUrl'))
            })
      ], {}, [
        returnTypeRef
      ]);

      return optionsExp;
    } else {
      hasCustomOptions = true;
      optionsExp['newRequestOptions'] = refer('newRequestOptions')
          .call([refer(optionsParam.displayName)]).assignFinal('newOptions');
      final Reference newOptions = refer('newOptions');
      optionsExp[_extraVar] = newOptions
          .property(_extraVar)
          .property('addAll')
          .call([extraOptions.remove(_extraVar)!]);
      optionsExp['headers1'] = newOptions
          .property('headers')
          .property('addAll')
          .call([refer(_dioVar).property('options').property('headers')]);
      optionsExp['headers2'] = newOptions
          .property('headers')
          .property('addAll')
          .call([extraOptions.remove('headers')!]);
      optionsExp['options'] = newOptions
          .property('copyWith')
          .call(
              [],
              Map.from(extraOptions)
                ..[_queryParamsVar] = namedArguments[_queryParamsVar]!
                ..[_path] = namedArguments[_path]!
                ..[_baseUrlVar] = extraOptions.remove(_baseUrlVar)!.ifNullThen(
                    refer(_dioVar).property('options').property('baseUrl')))
          .cascade('data')
          .assign(namedArguments[_dataVar]!);

      return optionsExp;
    }
  }
}

String revivedLiteral(
  Object object, {
  DartEmitter? dartEmitter,
}) {
  dartEmitter ??= DartEmitter();

  ArgumentError.checkNotNull(object, 'object');

  Revivable? revived;
  if (object is Revivable) {
    revived = object;
  }
  if (object is DartObject) {
    revived = ConstantReader(object).revive();
  }
  if (object is ConstantReader) {
    revived = object.revive();
  }
  if (revived == null) {
    throw ArgumentError.value(object, 'object',
        'Only `Revivable`, `DartObject`, `ConstantReader` are supported values');
  }

  String instantiation = '';
  final location = revived.source.toString().split('#');

  /// If this is a class instantiation then `location[1]` will be populated
  /// with the class name
  if (location.length > 1) {
    instantiation = location[1] +
        (revived.accessor.isNotEmpty ? '.${revived.accessor}' : '');
  } else {
    /// Getters, Setters, Methods can't be declared as constants so this
    /// literal must either be a top-level constant or a static constant and
    /// can be directly accessed by `revived.accessor`
    return revived.accessor;
  }

  final args = StringBuffer();
  final kwargs = StringBuffer();
  Spec objectToSpec(DartObject? object) {
    if (object == null) return literalNull;
    final constant = ConstantReader(object);
    if (constant.isNull) {
      return literalNull;
    }

    if (constant.isBool) {
      return literal(constant.boolValue);
    }

    if (constant.isDouble) {
      return literal(constant.doubleValue);
    }

    if (constant.isInt) {
      return literal(constant.intValue);
    }

    if (constant.isString) {
      return literal(constant.stringValue);
    }

    if (constant.isList) {
      return literalList(constant.listValue.map(objectToSpec));
      // return literal(constant.listValue);
    }

    if (constant.isMap) {
      return literalMap(Map.fromIterables(
          constant.mapValue.keys.map(objectToSpec),
          constant.mapValue.values.map(objectToSpec)));
      // return literal(constant.mapValue);
    }

    if (constant.isSymbol) {
      return Code('Symbol(${constant.symbolValue.toString()})');
      // return literal(constant.symbolValue);
    }

    if (constant.isNull) {
      return literalNull;
    }

    if (constant.isType) {
      return refer(constant.typeValue.getDisplayString(withNullability: false));
    }

    if (constant.isLiteral) {
      return literal(constant.literalValue);
    }

    /// Perhaps an object instantiation?
    /// In that case, try initializing it and remove `const` to reduce noise
    final revived = revivedLiteral(constant.revive(), dartEmitter: dartEmitter)
        .replaceFirst('const ', '');
    return Code(revived);
  }

  for (var arg in revived.positionalArguments) {
    final literalValue = objectToSpec(arg);

    args.write('${literalValue.accept(dartEmitter)},');
  }

  for (var arg in revived.namedArguments.keys) {
    final literalValue = objectToSpec(revived.namedArguments[arg]!);

    kwargs.write('$arg:${literalValue.accept(dartEmitter)},');
  }

  return '$instantiation($args $kwargs)';
}

extension DartTypeStreamAnnotation on DartType {
  bool get isDartAsyncStream {
    final element = this.element == null ? null : this.element as ClassElement;
    if (element == null) {
      return false;
    }
    return element.name == "Stream" && element.library.isDartAsync;
  }
}
