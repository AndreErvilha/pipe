import 'package:pipe_cli/pipe_cli.dart';

class ForEach implements Command {
  @override
  String get name => 'for_each';

  @override
  Future<void> call(World world, dynamic args) async {
    args as Map;
    final valueName = getArg<String>('value', args);
    final values = getArg('values', args);
    List? list;
    if (values is String) {
      list = getArg<List>(values, world.objects);
    } else {
      values as List;
      list = values;
    }

    final execute = getArg<ListValue>('execute', args);
    final executeCommand = world.commands['execute'];

    for (final _value in list) {
      world.addObject(valueName, _value);
      await executeCommand?.call(world, ObjectValue('execute', execute));
    }
  }
}
