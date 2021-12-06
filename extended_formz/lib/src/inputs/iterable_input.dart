import 'package:extended_formz/src/errors/iterable_input_error.dart';
import 'package:extended_formz/src/inputs/value_input.dart';

class IterableInput<T> extends ValueInput<Iterable<T>, IterableInputError> {
  const IterableInput.pure(
    Iterable<T> iterable, {
    required this.options,
    required String name,
    bool isRequired = false,
    this.maxIterable,
  }) : super.pure(
          iterable,
          name: name,
          isRequired: isRequired,
        );

  const IterableInput._dirty(
    Iterable<T> iterable,
    this.options, {
    required String name,
    required bool isRequired,
    this.maxIterable,
  }) : super.dirty(
          iterable,
          name: name,
          isRequired: isRequired,
        );

  final Iterable<T> options;
  final int? maxIterable;

  @override
  IterableInput<T> dirtyCopy(Iterable<T> value) => IterableInput._dirty(
        value,
        options,
        name: name,
        isRequired: isRequired,
        maxIterable: maxIterable,
      );

  @override
  IterableInput<T> pureCopy(Iterable<T> value) => IterableInput.pure(
        value,
        options: options,
        name: name,
        isRequired: isRequired,
        maxIterable: maxIterable,
      );

  @override
  IterableInputError? validator(Iterable<T> value) {
    final Set<T> valueSet = value.toSet();
    final Set<T> optionsSet = options.toSet();

    return value.isEmpty
        ? !isRequired
            ? null
            : IterableInputError.empty
        : optionsSet.intersection(valueSet).isNotEmpty
            ? (maxIterable != null || maxIterable != 0)
                ? value.length <= maxIterable!
                    ? null
                    : IterableInputError.outOfRange
                : null
            : IterableInputError.invalid;
  }

  @override
  List<Object?> get props => [...super.props, options.length, maxIterable];
}
