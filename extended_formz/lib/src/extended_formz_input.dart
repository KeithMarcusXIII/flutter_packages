import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

abstract class ExtendedFormzInput<T, E> extends FormzInput<T, E>
    with EquatableMixin {
  const ExtendedFormzInput.pure(
    T value, {
    required this.name,
    this.isRequired = false,
  }) : super.pure(value);

  const ExtendedFormzInput.dirty(
    T value, {
    required this.name,
    this.isRequired = false,
  }) : super.dirty(value);

  final String name;
  final bool isRequired;

  @override
  int get hashCode => super.hashCode ^ name.hashCode;

  @override
  operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ExtendedFormzInput<T, E> &&
        other.name == name &&
        super == (other);
  }

  @override
  List<Object?> get props => [name, isRequired];
}
