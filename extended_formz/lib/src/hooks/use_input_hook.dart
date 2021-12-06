import 'package:extended_formz/src/extended_formz_input.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

O useInput<I, O extends ExtendedFormzInput>({
  required O initialInput,
  required ValueNotifier<I> controller,
  required O Function(I value, O input) map,
}) {
  return use(_InputHook<I, O>(
    initialInput: initialInput,
    controller: controller,
    map: map,
  ));
}

class _InputHook<I, O extends ExtendedFormzInput> extends Hook<O> {
  const _InputHook({
    required this.initialInput,
    required this.controller,
    required this.map,
  });

  final O initialInput;
  final ValueNotifier<I> controller;
  final O Function(I value, O input) map;

  @override
  _InputHookState<I, O> createState() => _InputHookState();
}

class _InputHookState<I, O extends ExtendedFormzInput>
    extends HookState<O, _InputHook<I, O>> {
  late O _input;

  @override
  void initHook() {
    super.initHook();
    _input = hook.initialInput;
    hook.controller.addListener(_listener);
  }

  @override
  void didUpdateHook(_InputHook<I, O> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook.controller != oldHook.controller) {
      oldHook.controller.removeListener(_listener);
      hook.controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  O build(BuildContext context) => _input;

  void _listener() {
    setState(() {
      _input = hook.map(hook.controller.value, _input);
    });
  }

  /* @override
  Object? get debugValue => _state.value;

  @override
  String get debugLabel => 'useState<$T>'; */
}
