import 'package:pipe_cli/pipe_cli.dart';

import 'commands/capture.dart';
import 'commands/conditions/if_flag.dart';
import 'commands/generate.dart';
import 'commands/install.dart';
import 'commands/loops/for_each.dart';
import 'commands/print.dart';
import 'commands/run.dart';

void main(List<String> arguments) {
  Pipeline()
    ..addCommand(Capture())
    ..addCommand(ForEach())
    ..addCommand(Generate())
    ..addCommand(IfFlag())
    ..addCommand(Install())
    ..addCommand(Print())
    ..addCommand(Run())
    ..loadMarkdown()
    ..run(arguments);
}
