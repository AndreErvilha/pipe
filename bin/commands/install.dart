import 'package:pipe/pipe.dart';

class Install implements Command {
  @override
  Future<void> call(World world, ObjectValue<Value> args) async {
    final dependencies = args.value;
    dependencies as ListValue;

    for (var dependency in dependencies.value) {
      dependency as TextValue;
      //success('$name => ${dependency.value}');
    }
  }

  @override
  String get name => 'install';
}
