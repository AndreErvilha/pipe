import 'package:pipe_cli/pipe_cli.dart';

class Print implements Command {
  @override
  String get name => 'print';

  @override
  Future<void> call(World world, ObjectValue args) async {
    final msg = args.value as TextValue;

    success('$name => ${Utils.eval(msg, world)}');
  }
}
