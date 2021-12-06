import 'package:extended_formz/src/errors/value_input_error.dart';
import 'package:meta/meta.dart';

@immutable
class NumberInputError extends ValueInputError<num> {
  const NumberInputError._(int index)
      : index = index,
        super(index);

  factory NumberInputError.fromJson(String json) =>
      NumberInputError._(_names.indexOf(json));

  final int index;

  static const NumberInputError empty = NumberInputError._(0);

  static const NumberInputError outOfRange = NumberInputError._(1);

  static const List<NumberInputError> values = <NumberInputError>[
    empty,
    outOfRange,
  ];

  static const List<String> _names = <String>[
    'empty',
    'outOfRange',
  ];

  String get _name => _names[index];

  T maybeMap<T extends Object?>({
    T Function()? empty,
    T Function()? outOfRange,
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
    return other is NumberInputError && other.index == index;
  }

  @override
  String toJson() => _names[index];
}
