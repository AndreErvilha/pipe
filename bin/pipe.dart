import 'package:pipe_cli/pipe_cli.dart';

import 'commands/capture.dart';
import 'commands/generate.dart';
import 'commands/install.dart';
import 'commands/print.dart';

void main(List<String> arguments) {
  Pipeline()
    ..addCommand(Capture())
    ..addCommand(Generate())
    ..addCommand(Install())
    ..addCommand(Print())
    ..loadMarkdown()
    ..run(arguments);
}
