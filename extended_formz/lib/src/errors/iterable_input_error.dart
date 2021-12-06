import 'package:extended_formz/src/errors/value_input_error.dart';
import 'package:meta/meta.dart';

@immutable
class IterableInputError extends ValueInputError {
  const IterableInputError._(int index)
      : index = index,
        super(index);

  factory IterableInputError.fromJson(String json) =>
      IterableInputError._(_names.indexOf(json));

  final int index;

  static const IterableInputError empty = IterableInputError._(0);

  static const IterableInputError outOfRange = IterableInputError._(1);

  static const IterableInputError invalid = IterableInputError._(2);

  static const List<IterableInputError> values = <IterableInputError>[
    empty,
    outOfRange,
    invalid,
  ];

  static const List<String> _names = <String>[
    'empty',
    'outOfRange',
    'invalid',
  ];

  String get _name => _names[index];

  T maybeMap<T extends Object?>({
    T Function()? empty,
    T Function()? outOfRange,
    T Function()? invalid,
    required T orElse(),
  }) {
    switch (index) {
      case 0:
        if (empty != null) {
          return empty();
        }
        break;
      case 1:
        if (outOfRange != null) {
          return outOfRange();
        }
        break;
      case 2:
        if (invalid != null) {
          return invalid();
        }
        break;
      default:
        return orElse();
    }
    return orElse();
  }

  @override
  String toString() => _name;

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is IterableInputError && other.index == index;
  }

  @override
  String toJson() => _names[index];
}
