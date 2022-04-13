abstract class Value {
  final dynamic value;

  Value(this.value);
}

class NumValue implements Value {
  @override
  final num value;

  NumValue(this.value);
}

class TextValue implements Value {
  @override
  final String value;

  TextValue(this.value);
}

class BoolValue implements Value {
  @override
  final bool value;

  BoolValue(this.value);
}

class ListValue<T extends Value> implements Value {
  @override
  final List<T> value;

  ListValue(this.value);
}

class PipeObject implements Value {
  final String name;
  @override
  final dynamic value;

  PipeObject(this.name, this.value);
}

class ObjectValue<T extends Value> implements PipeObject {
  @override
  final String name;
  @override
  final T value;

  ObjectValue(this.name, this.value);

  T getValue<T extends Value>(String name) {
    if (!(value is ListValue)) {
      throw Exception(
        'Invalid argument type => ${this.name}.value '
        '| Expects ListValue but got ${value.runtimeType}',
      );
    }
    if (!(value.value.first is ObjectValue)) {
      throw Exception(
        'Invalid argument type => $name.value.value '
        '| Expects ListValue but got ${value.value.runtimeType}',
      );
    }

    final matches = value.value.where((element) => element.name == name);
    if (matches.length == 1) {
      final arg = matches.first;
      final value = arg.value as T;

      if (arg.value is T) return value;

      throw Exception(
        'Invalid argument type => ${arg.name} '
        '| Expects ObjectValue<${T.toString()}> but got ${arg.runtimeType}',
      );
    } else if (matches.isNotEmpty) {
      throw Exception('Too many argument with name => $name');
    } else {
      throw Exception('Required argument missing => $name');
    }
  }
}
