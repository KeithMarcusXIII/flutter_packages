import 'package:extended_formz/extended_formz.dart';
import 'package:extended_formz/src/errors/value_input_error.dart';
import 'package:meta/meta.dart';

class ValueInput<T, E extends ValueInputError>
    extends ExtendedFormzInput<T, E> {
  const ValueInput.pure(
    T value, {
    required String name,
    E? Function(T value)? validator,
    bool isRequired = false,
  })  : _validator = validator,
        super.pure(
          value,
          name: name,
          isRequired: isRequired,
        );

  @protected
  const ValueInput.dirty(
    T value, {
    required String name,
    E? Function(T value)? validator,
    required bool isRequired,
  })  : _validator = validator,
        super.dirty(
          value,
          name: name,
          isRequired: isRequired,
        );

  final E? Function(T value)? _validator;

  ValueInput<T, E> dirtyCopy(T value) => ValueInput.dirty(
        value,
        name: name,
        validator: _validator,
        isRequired: isRequired,
      );

  ValueInput<T, E> pureCopy(T value) => ValueInput.pure(
        value,
        name: name,
        validator: _validator,
        isRequired: isRequired,
      );

  @override
  E? validator(T value) => _validator?.call(value);

  @override
  List<Object?> get props => [...super.props, validator];
}
