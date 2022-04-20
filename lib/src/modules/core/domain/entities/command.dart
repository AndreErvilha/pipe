import 'package:pipe_cli/pipe_cli.dart';

import 'world.dart';

abstract class Command {
  String get name;

  Future<void> call(World world, dynamic args);
}
