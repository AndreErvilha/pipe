import 'package:recase/recase.dart';

import 'domain/entities/world.dart';

T getArg<T>(String name, Map map) {
  if (map.containsKey(name)) {
    final arg = map[name];

    if (arg is T) return arg;

    throw Exception(
      'Invalid argument type => $name '
      '| Expects ${T.toString()} but got ${arg.runtimeType}',
    );
  } else {
    throw Exception('Required argument missing => $name');
  }
}

T? getArgOpt<T>(String name, Map map) {
  try {
    final arg = getArg<T>(name, map);

    return arg;
  } on Exception catch (e) {
    if (e.toString().contains('Required')) return null;
    rethrow;
  }
}

String eval(String value, World world) {
  final pattern = RegExp(r'{{(?!{{)(?!\|)([A-z.]*)(?:\|([A-z.]*))?(?<!}})}}');

  var text = value;
  final matches = pattern.allMatches(text);

  for (var match in matches) {
    final objName = match.group(1)!;
    final from = match.group(0)!;
    final reCase = match.group(2);

    var to = getArg<String>(objName, world.objects);

    if (to.contains(pattern)) to = eval(to, world);

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
