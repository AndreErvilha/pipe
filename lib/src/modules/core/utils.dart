import 'package:recase/recase.dart';

import 'domain/entities/objects.dart';
import 'domain/entities/world.dart';

class Utils {
  static T getArg<T extends Value>(String name, World world) {
    if (world.objects.containsKey(name)) {
      final arg = world.objects[name];

      if (arg is ObjectValue) {
        final value = arg.value;
        if (value is T) {
          return value;
        }
      }

      throw Exception(
        'Invalid argument type => $name '
        '| Expects ${T.runtimeType} but got ${arg.runtimeType}',
      );
    } else {
      throw Exception('Required argument missing => $name');
    }
  }

  static T? getArgOpt<T extends Value>(String name, World world) {
    try {
      final arg = getArg<T>(name, world);

      return arg;
    } on Exception catch (e) {
      if (e.toString().contains('Required')) return null;
      rethrow;
    }
  }

  static Value parseValues(dynamic data) {
    if (data is Map) {
      if (data.length > 1) {
        final list = <Value>[];
        for (var entry in data.entries) {
          final value = parseValues(entry.value);

          list.add(ObjectValue(entry.key, value));
        }

        return ListValue(list);
      } else {
        return ObjectValue(
            data.entries.first.key, parseValues(data.entries.first.value));
      }
    } else if (data is List) {
      final list = <Value>[];
      for (var d in data) {
        list.add(parseValues(d));
      }

      return ListValue(list);
    } else if (data is num) {
      return NumValue(data);
    } else if (data is bool) {
      return BoolValue(data);
    } else {
      return TextValue(data ?? '');
    }
  }

  static String eval(TextValue value, World world) {
    final pattern = RegExp(r'{{(?!{{)(?!\|)([A-z]*)(?:\|([\S]*))?(?<!}})}}');

    var text = value.value;
    final matches = pattern.allMatches(text);

    for (var match in matches) {
      final objName = match.group(1)!;
      final from = match.group(0)!;
      final reCase = match.group(2);

      var to = getArg<TextValue>(objName, world).value;

      if (to.contains(pattern)) to = eval(TextValue(to), world);

      if (reCase != null) {
        switch (reCase) {
          case 'pascalCase':
            to = ReCase(to).pascalCase;
            break;
          case 'camelCase':
            to = ReCase(to).camelCase;
            break;
          case 'constantCase':
            to = ReCase(to).constantCase;
            break;
          case 'dotCase':
            to = ReCase(to).dotCase;
            break;
          case 'headerCase':
            to = ReCase(to).headerCase;
            break;
          case 'paramCase':
            to = ReCase(to).paramCase;
            break;
          case 'pathCase':
            to = ReCase(to).pathCase;
            break;
          case 'sentenceCase':
            to = ReCase(to).sentenceCase;
            break;
          case 'snakeCase':
            to = ReCase(to).snakeCase;
            break;
          case 'titleCase':
            to = ReCase(to).titleCase;
            break;
        }
      }

      text = text.replaceFirst(from, to);
    }

    return text;
  }
}
