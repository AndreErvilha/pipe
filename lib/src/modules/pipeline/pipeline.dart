import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart' as args;
import 'package:pipe_cli/pipe_cli.dart';
import 'package:pipe_cli/src/modules/core/domain/entities/script.dart';
import 'package:yaml/yaml.dart' as _yaml;

class Pipeline {
  final World world;

  final yaml = <String, String>{};

  late args.CommandRunner runner;

  Pipeline() : world = World();

  void addCommand(Command command) {
    world.addCommand(command);
  }

  void addCliCommand(args.Command command) {
    world.addCliCommand(command);
  }

  void addYaml(String? scriptName, String value) {
    if (scriptName == null) {
      final newValue = yaml.entries.last.value + value;
      yaml[yaml.entries.last.key] =
          newValue.split('\n').where((e) => e.isNotEmpty).join('\n');
    } else if (yaml.containsKey(scriptName)) {
      final newValue = yaml[scriptName]! + value;
      yaml[scriptName] =
          newValue.split('\n').where((e) => e.isNotEmpty).join('\n');
    } else {
      yaml[scriptName] =
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
    createScriptCommands();
  }

  void run(List<String> arguments) async {
    runner = args.CommandRunner('pipe', 'Pipeline for everything.');

    for (final command in world.cliCommands.values) {
      runner.addCommand(command);
    }

    try {
      await runner.run(arguments);
    } catch (e) {
      error(e);
    }
  }

  void createCliCommands() {
    for (var yamlDoc in yaml.values) {
      final Map result = _yaml.loadYaml(yamlDoc);

      final Map map = jsonDecode(jsonEncode(result));

      final cliSubCommands = <String, CliCommand>{};

      final subCommands = map.entries.where((e) => e.key.contains('.'));
      for (final command in subCommands) {
        final cli = CliCommand(
          world,
          command,
          yamlDoc,
        );

        cliSubCommands[command.key] = cli;
      }

      final commands = map.entries.where((e) => !e.key.contains('.'));
      for (final command in commands) {
        final cli = CliCommand(
          world,
          command,
          yamlDoc,
        );

        world.cliCommands[command.key] = cli;

        Map map = command.value;
        if (map.containsKey('sub_commands')) {
          List subCommands = map['sub_commands'];

          for (var subCommand in subCommands) {
            final _cliSubCommand = cliSubCommands[subCommand]!;
            cli.addSubcommand(_cliSubCommand);
          }
        }
      }
    }
  }

  void createScriptCommands() {
    for (var yamlDoc in yaml.values) {
      final Map result = _yaml.loadYaml(yamlDoc);

      final Map map = jsonDecode(jsonEncode(result));

      for (final command in map.entries) {
        if (command.value.containsKey('execute')) {
          addCommand(Script(command));
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

    for (var match in values) {
      final scriptName = match.namedGroup('template_name');
      final dart = match.namedGroup('dart');

      world.addObject(scriptName!, dart!);
    }
  }
}

class CliCommand extends args.Command {
  final String _pipeName;
  final World _world;
  final MapEntry _declaration;
  late List? _execute;
  late Map? _args;

  // command declaration variables
  late String _name;
  late String _description;
  late String? _abbr;

  CliCommand(
    this._world,
    this._declaration,
    this._pipeName,
  ) {
    _args = getArgOpt<Map>('args', _declaration.value);
    _execute = getArgOpt<List>('execute', _declaration.value);

    // command declaration variables
    _name = getArgOpt<String>('name', _declaration.value) ?? _declaration.key;
    _abbr = getArgOpt<String>('abbr', _declaration.value);
    _description = getArg<String>('description', _declaration.value);
    _description += _abbr != null ? ' ($_abbr)' : '';

    if (_abbr != null) aliases.add(_abbr!);

    // Parse flags
    if (_args != null) {
      for (var arg in _args!.entries) {
        final help = getArg<String>('help', arg.value);
        final abbr = getArgOpt<String>('abbr', arg.value);
        final negatable = getArgOpt<bool>('negatable', arg.value) ?? false;
        final defaults = getArgOpt<bool>('defaults', arg.value) ?? false;

        argParser.addFlag(
          arg.key,
          help: help,
          abbr: abbr,
          negatable: negatable,
          defaultsTo: defaults,
        );
      }
    }
  }

  @override
  FutureOr run() async {
    _world.argResults = argParser.parse(argResults?.arguments ?? []);
    final rest = argResults?.rest;
    if (rest != null && rest.isNotEmpty) {
      if (rest.length == 1) {
        _world.addObject('rest.single', rest.single);
      } else {
        _world.addObject('rest', rest.join(' '));

        _world.addObject('rest.list', rest);
      }
    }

    for (var command in _execute ?? []) {
      command as Map;
      final key = command.entries.first.key;
      final value = command.entries.first.value;

      if (_world.commands.containsKey(key)) {
        await _world.commands[key]?.call(_world, value);
      } else {
        _world.addObject(key, value);
      }
    }
  }

  @override
  String get description => _description;

  @override
  String get name => _name;

  @override
  List<String> get aliases => [if (_abbr != null) _abbr!];
}
