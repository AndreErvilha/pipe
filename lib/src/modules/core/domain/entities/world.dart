import 'package:args/args.dart';
import 'package:args/command_runner.dart' as args;

import 'command.dart';

class World {
  final objects = <String, dynamic>{};
  final commands = <String, Command>{};
  final cliCommands = <String, args.Command>{};
  ArgResults? argResults;

  void addObject(String name, dynamic value) => objects[name] = value;

  void addCommand(Command value) => commands[value.name] = value;

  void addCliCommand(args.Command value) => cliCommands[value.name] = value;

  World copy({ArgResults? argResults}) {
    final result = World();
    for (final command in commands.values) {
      result.addCommand(command);
    }
    for (final object in objects.entries) {
      result.addObject(object.key, object.value);
    }
    result.argResults = argResults ?? this.argResults;
    return result;
  }
}
