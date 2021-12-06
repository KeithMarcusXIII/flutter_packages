import 'package:meta/meta.dart';

@immutable
class ValueInputError<T> {
  @protected
  const ValueInputError(this.index);

  factory ValueInputError.fromJson(String json) =>
      ValueInputError(_names.indexOf(json));

  final int index;

  static const ValueInputError empty = ValueInputError(0);

  static const List<ValueInputError> values = <ValueInputError>[
    empty,
  ];

  static const List<String> _names = <String>[
    'empty',
  ];

  String get _name => _names[index];

  @override
  String toString() => _name;

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is ValueInputError<T> && other.index == index;
  }

  String toJson() => _names[index];
}
