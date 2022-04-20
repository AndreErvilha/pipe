import 'package:pipe_cli/pipe_cli.dart';

class Print implements Command {
  @override
  String get name => 'print';

  @override
  Future<void> call(World world, dynamic msg) async {
    msg as String;

    success('$name => ${eval(msg, world)}');
  }
}
