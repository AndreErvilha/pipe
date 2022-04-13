import 'command.dart';
import 'objects.dart';

class World {
  final objects = <String, PipeObject>{};
  final commands = <String, Command>{};

  void addObject(ObjectValue value) => objects[value.name] = value;

  void addCommand(Command value) => commands[value.name] = value;
}
