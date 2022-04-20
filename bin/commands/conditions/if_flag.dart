import 'package:pipe_cli/pipe_cli.dart';

class IfFlag implements Command {
  @override
  String get name => 'if_flag';

  @override
  Future<void> call(World world, dynamic args) async {
    args as Map;

    final flagName = getArg<String>('flag', args);
    final thenExecution = getArg<List>('then', args);
    final elseExecution = getArgOpt<List>('else', args);

    if (world.argResults![flagName]) {
      for (var command in thenExecution) {
        command as Map;
        final key = command.entries.first.key;
        final value = command.entries.first.value;

        if (world.commands.containsKey(key)) {
          await world.commands[key]?.call(world, value);
        } else {
          world.addObject(key, value);
        }
      }
    } else {
      for (var command in elseExecution ?? []) {
        command as Map;
        final key = command.entries.first.key;
        final value = command.entries.first.value;

        if (world.commands.containsKey(key)) {
          await world.commands[key]?.call(world, value);
        } else {
          world.addObject(key, value);
        }
      }
    }
  }
}
