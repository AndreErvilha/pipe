import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart' as args;
import 'package:pipe_cli/pipe_cli.dart';
import 'package:yaml/yaml.dart' as _yaml;

class Pipeline {
  final World world;

  final cliCommands = <String, args.Command>{};

  final yaml = <String, String>{};

  late args.CommandRunner runner;

  Pipeline() : world = World();

  void addCommand(Command command) {
    world.addCommand(command);
  }

  void addCliCommand(args.Command command) {
    cliCommands.putIfAbsent(command.name, () => command);
  }

  void addYaml(String? script_name, String value) {
    if (script_name == null) {
      final newValue = yaml.entries.last.value + value;
      yaml[yaml.entries.last.key] =
          newValue.split('\n').where((e) => e.isNotEmpty).join('\n');
    } else if (yaml.containsKey(script_name)) {
      final newValue = yaml[script_name]! + value;
      yaml[script_name] =
          newValue.split('\n').where((e) => e.isNotEmpty).join('\n');
    } else {
      yaml[script_name] =
          value.split('\n').where((e) => e.isNotEmpty).join('\n');
    }
  }

  void loadYaml() {
    final file = File('pipe.md');

    if (!file.existsSync()) {
      error('file "pipe.yaml" was not found at current location');
      return;
    }

    addYaml(file.path.split('/').last, file.readAsStringSync());

    createCliCommands();
  }

  void loadMarkdown() {
    final file = File('pipe.md');

    if (!file.existsSync()) {
      error('file "pipe.md" was not found at current location');
      return;
    }

    final markdown = file.readAsStringSync();

    _detectYaml(markdown);
    _detectDart(markdown);

    createCliCommands();
  }

  void run(List<String> arguments) {
    runner = args.CommandRunner('pipe', 'Pipeline for everything.');

    for (final command in cliCommands.values) {
      runner.addCommand(command);
    }

    runner.run(arguments);
  }

  void createCliCommands() {
    for (var yamlDoc in yaml.values) {
      final _yaml.YamlMap result = _yaml.loadYaml(yamlDoc);

      final steps = Utils.parseValues(result);

      if (steps is ObjectValue) {
        final cli = CliCommand(
          world,
          steps,
        );
        addCliCommand(cli);

        // Create abbrev command
        final abbrCommand = cli.abbrCommand;
        if (abbrCommand != null) {
          addCliCommand(abbrCommand);
        }
      }
    }
  }

  void _detectYaml(String markdown) {
    final regex = r''
        // capture name of script
        r'(?:\*\*`(?<script_name>(?!\*\*`)[\S]*(?<!`\*\*))`\*\**)?[\s]?'
        // capture yaml
        r'```yaml(?<yaml>(?!```)[\s\S][^`]*(?<!```))[\S]*[\n]```';
    final pattern = RegExp(regex);

    final values = pattern.allMatches(markdown);

    if (values.isEmpty) {
      throw Exception('capture has no match with gave pattern => $regex');
    }

    for (var match in values) {
      final scriptName = match.namedGroup('script_name');
      final yaml = match.namedGroup('yaml');

      addYaml(scriptName, yaml!);
    }
  }

  void _detectDart(String markdown) {
    final regex = r''
        // capture name of script
        r'(?:\*\*`(?<template_name>(?!\*\*`)[\S]*(?<!`\*\*))`\*\**)?[\s]?'
        // capture yaml
        r'```dart[\s]*\n(?<dart>(?!```)[\s\S][^`]*(?<!```))```';
    final pattern = RegExp(regex);

    final values = pattern.allMatches(markdown);

    if (values.isEmpty) {
      throw Exception('capture has no match with gave pattern => $regex');
    }

    for (var match in values) {
      final scriptName = match.namedGroup('template_name');
      final dart = match.namedGroup('dart');

      world.addObject(ObjectValue(scriptName!, TextValue(dart!)));
    }
  }
}

class CliCommand extends args.Command {
  final World _world;
  final ObjectValue _declaration;
  late ListValue _execute;
  late ListValue? _args;

  // command declaration variables
  late String _pipeName;
  late String _name;
  late String _description;
  late String? _abbr;

  CliCommand(
    this._world,
    this._declaration,
  ) {
    _args = _declaration.getOpt<ListValue>('args');
    _execute = _declaration.getValue<ListValue>('execute');

    // command declaration variables
    _pipeName = _declaration.name;
    _name = _declaration.getValue<TextValue>('name').value;
    _description = _declaration.getValue<TextValue>('description').value;
    _abbr = _declaration.getOpt<TextValue>('abbr')?.value;

    // Parse flags
    if (_args != null) {
      for (var arg in _args!.value) {
        arg as ObjectValue;
        final help = arg.getValue<TextValue>('help');
        final abbr = arg.getValue<TextValue>('abbr');
        final negatable = arg.getValue<BoolValue>('negatable');

        argParser.addFlag(
          arg.name,
          help: help.value,
          abbr: abbr.value,
          negatable: negatable.value,
        );
      }
    }
  }

  @override
  FutureOr run() async {
    final rest = argResults?.rest;
    if (rest != null && rest.isNotEmpty) {
      _world.addObject(ObjectValue('rest', TextValue(rest.single)));
    }

    for (var command in _execute.value) {
      command as ObjectValue;

      if (_world.commands.containsKey(command.name)) {
        await _world.commands[command.name]?.call(_world, command);
      } else if (!_world.objects.containsKey(command.name)) {
        _world.addObject(command);
        //success('pipeline => Add var ${command.name}');
      }
    }
  }

  CliCommand? get abbrCommand {
    if (_abbr != null) {
      return AbbrCommand(_world, _declaration);
    }
    return null;
  }

  @override
  String get description => _description;

  @override
  String get name => _name;
}

class AbbrCommand extends CliCommand {
  AbbrCommand(world, declaration) : super(world, declaration);

  @override
  String get name => _abbr!;
}
