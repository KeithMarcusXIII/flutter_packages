import 'package:extended_formz/src/errors/number_input_error.dart';
import 'package:extended_formz/src/inputs/value_input.dart';

class NumberInput extends ValueInput<num, NumberInputError> {
  NumberInput.pure({
    num value = 0,
    this.minValue,
    this.maxValue,
    required String name,
    bool isRequired = false,
  }) : super.pure(
          value,
          name: name,
          isRequired: isRequired,
        );

  const NumberInput._dirty(
    num value, {
    this.minValue,
    this.maxValue,
    required String name,
    required bool isRequired,
  }) : super.dirty(
          value,
          name: name,
          isRequired: isRequired,
        );

  final num? minValue;
  final num? maxValue;

  @override
  NumberInput dirtyCopy(num value, {num? minValue, num? maxValue}) =>
      NumberInput._dirty(
        value,
        minValue: minValue ?? this.minValue,
        maxValue: maxValue ?? this.maxValue,
        name: name,
        isRequired: isRequired,
      );

  @override
  NumberInput pureCopy(num value) =>
      NumberInput.pure(value: value, name: name, isRequired: isRequired);

  @override
  NumberInputError? validator(num value) {
    if (minValue != null) {
      if (value < minValue!) {
        return NumberInputError.outOfRange;
      }
    }
    if (maxValue != null) {
      if (value > maxValue!) {
        return NumberInputError.outOfRange;
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [...super.props, minValue, maxValue];
}
