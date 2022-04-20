import 'package:args/args.dart';
import 'package:pipe_cli/pipe_cli.dart';

class Script implements Command {
  final MapEntry _declaration;

  Script(this._declaration);

  @override
  Future<void> call(World world, args) async {
    args as Map;

    final _args = getArgOpt<List>('args', args) ?? [];
    final _rest = getArgOpt<String>('rest', args);
    final _restList = eval(_rest ?? '', world).split(' ');

    final execute = getArg<List>('execute', _declaration.value);

    final cliCommand = _declaration.key.split('.');
    ArgResults? argResults = world
        .cliCommands[cliCommand[0]]?.subcommands[cliCommand[1]]?.argParser
        .parse(_args.cast());
    final _world = world.copy(argResults: argResults);

    if (_restList.isNotEmpty) {
      if (_restList.length == 1) {
        _world.addObject('rest.single', _restList.single);
      } else {
        _world.addObject('rest', _restList.join(' '));

        _world.addObject('rest.list', _restList);
      }
    }

    for (var command in execute) {
      command as Map;
      final key = command.entries.first.key;
      final value = command.entries.first.value;

      if (key == 'exports') {
        value is List;
        for (final export in value) {
          final valueToExport = _world.objects[export];
          world.addObject(export, valueToExport);
        }
      } else if (_world.commands.containsKey(key)) {
        await _world.commands[key]?.call(_world, value);
      } else {
        _world.addObject(key, value);
      }
    }
  }

  @override
  String get name => _declaration.key;
}
