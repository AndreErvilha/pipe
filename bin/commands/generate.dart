import 'dart:io';

import 'package:pipe_cli/pipe_cli.dart';

class Generate implements Command {
  @override
  Future<void> call(World world, dynamic args) async {
    args as Map;
    final template = getArg<String>('template', args);
    final path = getArg<String>('path', args);

    final file = File(eval(path, world));
    if (file.existsSync()) {
      error('file ${file.path} already exists');
      return;
    }
    await file.create(recursive: true);
    await file.writeAsString(eval(template, world));

    success('$name => Created file: ${eval(path, world)}');
  }

  @override
  String get name => 'generate';
}
