import 'package:collection/collection.dart';
import 'package:extended_formz/extended_formz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

FormzStatus useForm({
  required Inputs inputs,
  // required FormSubmitter delegate,
}) {
  return use(_FormHook(
    inputs: inputs,
    // delegate: delegate,
  ));
}

class _FormHook extends Hook<FormzStatus> {
  const _FormHook({
    required this.inputs,
    // required this.delegate,
  });

  final Inputs inputs;
  // final FormSubmitter delegate;

  @override
  _FormHookState createState() => _FormHookState();
}

class _FormHookState extends HookState<FormzStatus, _FormHook> with FormzMixin {
  @override
  void initHook() {
    super.initHook();
  }

  @override
  void didUpdateHook(_FormHook oldHook) {
    super.didUpdateHook(oldHook);
    /* if (!ListEquality().equals(hook.inputs, oldHook.inputs)) {
      _validate();
    } */
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  FormzStatus build(BuildContext context) => status;

  void _validate() {
    setState(() {});
  }

  @override
  List<FormzInput> get inputs => hook.inputs;

  /* @override
  Object? get debugValue => _state.value;

  @override
  String get debugLabel => 'useState<$T>'; */
}
