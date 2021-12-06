import 'package:extended_formz/src/errors/comparison_input_error.dart';
import 'package:extended_formz/src/inputs/value_input.dart';

class ComparisonInput<T> extends ValueInput<T, ComparisonInputError> {
  ComparisonInput.pure(
    T value, {
    required String name,
    required this.compare,
    bool isRequired = false,
  }) : super.pure(
          value,
          name: name,
          isRequired: isRequired,
        );

  ComparisonInput._dirty(
    T value, {
    required String name,
    required this.compare,
    bool isRequired = false,
  }) : super.dirty(
          value,
          name: name,
          isRequired: isRequired,
        );

  final T compare;

  @override
  ComparisonInput<T> dirtyCopy(T value) => ComparisonInput._dirty(
        value,
        name: name,
        compare: compare,
        isRequired: isRequired,
      );

  @override
  ComparisonInput<T> pureCopy(T value) => ComparisonInput.pure(
        value,
        name: name,
        compare: compare,
        isRequired: isRequired,
      );

  @override
  ComparisonInputError? validator(T value) {
    return value == null
        ? isRequired
            ? ComparisonInputError.empty
            : null
        : value != compare
            ? ComparisonInputError.unequal
            : null;
  }

  @override
  List<Object?> get props => [...super.props, compare];
}
