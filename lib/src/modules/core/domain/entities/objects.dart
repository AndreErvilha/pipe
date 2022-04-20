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
}
