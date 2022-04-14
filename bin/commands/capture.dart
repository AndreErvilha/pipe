import 'package:pipe_cli/pipe_cli.dart';

class Capture implements Command {
  @override
  String get name => 'capture';

  @override
  Future<void> call(World world, ObjectValue args) async {
    final textValue = args.getValue<TextValue>('text');
    final regexValue = args.getValue<TextValue>('regex');

    final text = Utils.eval(textValue, world);
    final pattern = RegExp(regexValue.value);

    final values = pattern.firstMatch(text);

    if (values == null) {
      throw Exception(
          'capture has no match with gave pattern => ${regexValue.value}');
    }

    for (var group in values.groupNames) {
      final text = values.namedGroup(group);
      final obj = ObjectValue(group, TextValue(text!));
      world.addObject(obj);
      //success('$name => Add var $text');
    }
  }
}
