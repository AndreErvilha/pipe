import 'package:pipe_cli/pipe_cli.dart';

class Capture implements Command {
  @override
  String get name => 'capture';

  @override
  Future<void> call(World world, dynamic args) async {
    args as Map;
    final textValue = getArg<String>('text', args);
    final regexValue = getArg<String>('regex', args);

    final text = eval(textValue, world);
    final pattern = RegExp(regexValue);

    final values = pattern.firstMatch(text);

    if (values == null) {
      throw Exception('capture has no match with gave pattern => $regexValue');
    }

    for (var group in values.groupNames) {
      final text = values.namedGroup(group);
      world.addObject(group, text);
      //success('$name => Add var $text');
    }
  }
}
