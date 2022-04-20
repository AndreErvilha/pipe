import 'dart:convert';
import 'dart:io';

import 'package:pipe_cli/pipe_cli.dart';

class Run implements Command {
  @override
  Future<void> call(World world, dynamic args) async {
    args as Map;
    final executable = getArg<String>('executable', args);
    final argsList = getArgOpt<List>('args', args);
    final showOutputs = getArgOpt<bool>('show_outputs', args) ?? true;
    final provideFeedback = getArgOpt<bool>('provide_feedback', args) ?? true;

    final arguments = argsList?.map((e) => eval(e, world)).toList();

    final process =
        await Process.start(executable, arguments ?? [], runInShell: true);

    if (showOutputs) {
      process.stdout.listen((List<int> event) {
        stdout.add(white(utf8.decode(event)).codeUnits);
      });
      process.stderr.listen((List<int> event) {
        stderr.add(red(utf8.decode(event)).codeUnits);
      });
    }

    if (provideFeedback) {
      if (await process.exitCode == 0) {
        success('${[executable, ...?arguments].join(' ')}\n');
      } else {
        error('${[executable, ...?arguments].join(' ')}\n');
      }
    }
  }

  @override
  String get name => 'run';
}
