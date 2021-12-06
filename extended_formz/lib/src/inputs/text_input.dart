import 'package:extended_formz/src/errors/text_input_error.dart';
import 'package:extended_formz/src/inputs/value_input.dart';

class TextInput extends ValueInput<String, TextInputError> {
  TextInput.pure({
    String value = '',
    required String name,
    this.minLength,
    this.maxLength,
    this.regex,
    // TextInputError? Function(String text)? validator,
    bool isRequired = false,
  }) : /* _validator = validator, */
        super.pure(
          value,
          name: name,
          // validator: validator,
          isRequired: isRequired,
        );

  TextInput._dirty(
    String value, {
    required String name,
    this.minLength,
    this.maxLength,
    this.regex,
    TextInputError? Function(String text)? validator,
    bool isRequired = false,
  }) : /* _validator = validator, */
        super.dirty(
          value,
          name: name,
          // validator: validator,
          isRequired: isRequired,
        );

  TextInputError? _validateFromRegex(String text) {
    if (regex?.isEmpty ?? true) {
      return null;
    }

    final RegExp validationRegex = RegExp(regex!);
    if (!validationRegex.hasMatch(text)) {
      return TextInputError.invalid;
    }
    return null;
  }

  final int? minLength;

  final int? maxLength;
  // final TextInputError? Function(String text)? _validator;
  final String? regex;

  @override
  TextInput dirtyCopy(String value) {
    return TextInput._dirty(
      value,
      minLength: minLength,
      maxLength: maxLength,
      regex: regex,
      // validator: _validator,
      name: name,
      isRequired: isRequired,
    );
  }

  @override
  TextInput pureCopy(String value) => TextInput.pure(
        value: value,
        name: name,
        minLength: minLength,
        maxLength: maxLength,
        regex: regex,
        // validator: _validator,
        isRequired: isRequired,
      );

  @override
  TextInputError? validator(String value) {
    final int length = value.length;
    TextInputError? error;

    if (minLength != null) {
      if (length < minLength!) {
        error = TextInputError.outOfRange;
      }
    }
    if (maxLength != null) {
      if (length > maxLength!) {
        error = TextInputError.outOfRange;
      }
    }

    /* final TextInputError? validationError = _validator?.call(value);
    if (validationError != null) {
      error = validationError;
    } */

    if (regex?.isNotEmpty ?? false) {
      final TextInputError? validationError = _validateFromRegex(value);
      if (validationError != null) {
        error = validationError;
      }
    }

    return value.isEmpty
        ? !isRequired
            ? null
            : TextInputError.empty
        : error;
  }

  /* @override
  TextInputError? get error; */

  @override
  List<Object?> get props => [...super.props, minLength, maxLength];
}
