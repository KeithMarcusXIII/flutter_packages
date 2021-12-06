import 'dart:async';

import 'package:flutter/foundation.dart';

import 'extended_formz_input.dart';

typedef Inputs = List<ExtendedFormzInput>;
typedef FormParameters = Future Function(
    Inputs inputs, List<Inputs> previousForms);
typedef InputsGetter = Future<Inputs> Function(
    Inputs inputs, List<Inputs> previousForms);

mixin FormLoader {
  Future<Inputs> loadForm({
    required Inputs inputs,
    List<Inputs> previousForms = const [],
  });
}

mixin FormSubmitter {
  Future submitForm({
    required Inputs inputs,
    // List<Inputs> previousForms = const [],
  });
}

class FormDelegate {
  final Inputs initialFields;
  final FormLoader? loader;
  final FormSubmitter? submitter;

  const FormDelegate(
    this.initialFields, {
    this.loader,
    this.submitter,
  });
}

class FormLoaderDelegate with FormLoader {
  const FormLoaderDelegate(InputsGetter delegate) : _delegate = delegate;

  final InputsGetter _delegate;

  @override
  Future<Inputs> loadForm({
    required Inputs inputs,
    List<Inputs> previousForms = const [],
  }) =>
      _delegate(inputs, previousForms);
}

class FormSubmitterDelegate with FormSubmitter {
  // const FormSubmitterDelegate(FormParameters delegate) : _delegate = delegate;
  const FormSubmitterDelegate(AsyncValueSetter<Inputs> delegate)
      : _delegate = delegate;

  // final FormParameters _delegate;
  final AsyncValueSetter<Inputs> _delegate;

  @override
  Future submitForm({
    required Inputs inputs,
    // List<Inputs> previousForms = const [],
  }) =>
      _delegate(inputs /* , previousForms */);
}
