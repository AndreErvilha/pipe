import 'objects.dart';
import 'world.dart';

abstract class Command {
  String get name;

  Future<void> call(World world, ObjectValue args);
}
