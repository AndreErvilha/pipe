import 'package:pipe_cli/pipe_cli.dart';

class Install implements Command {
  @override
  Future<void> call(World world, dynamic args) async {
    args as List;

    for (var dependency in args) {
      dependency as String;
      //success('$name => ${dependency.value}');
    }
  }

  @override
  String get name => 'install';
}
