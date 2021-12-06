import 'package:extended_formz/src/errors/value_input_error.dart';
import 'package:meta/meta.dart';

@immutable
class ComparisonInputError extends ValueInputError {
  const ComparisonInputError._(int index)
      : index = index,
        super(index);

  factory ComparisonInputError.fromJson(String json) =>
      ComparisonInputError._(_names.indexOf(json));

  final int index;

  static const ComparisonInputError empty = ComparisonInputError._(0);

  static const ComparisonInputError unequal = ComparisonInputError._(1);

  static const List<ComparisonInputError> values = <ComparisonInputError>[
    empty,
    unequal,
  ];

  static const List<String> _names = <String>[
    'empty',
    'unequal',
  ];

  String get _name => _names[index];

  T maybeMap<T extends Object?>({
    T Function()? empty,
    T Function()? unequal,
    required T orElse(),
  }) {
    switch (index) {
      case 0:
        if (empty != null) {
          return empty();
        }
        break;
      case 1:
        if (unequal != null) {
          return unequal();
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
    return other is ComparisonInputError && other.index == index;
  }

  @override
  String toJson() => _names[index];
}
