**`name_of_script`**
```yaml
gen_usecase:
 name: usecase
 abbr: u
 description: 'Creates an usecase in a custom template'
```

The command receive a pattern, extracts of this pattern
two arguments `feature` and `name`, then creates a usecase named `**name**_usecase.dart` in
`lib/**feature**/domain/usecases/` path from templates `interface_usecase` and `usecase`.

```yaml
 execute:
  - install:
    - get_it
  - capture:
     text: '{{rest}}'
     regex: '(?<feature>[A-z]*)@(?<name>[A-z]*)'
  - file_name: '{{name}}_usecase'
  - file_path: 'lib/features/{{feature}}/domain/usecase/{{file_name}}.dart'
  - build_usecase: '{{interface_usecase}}{{\n}}{{usecase}}'
  - generate:
     template: '{{build_usecase}}'
     path: '{{file_path}}'
```

# Templates

Creates a new line

**`\n`**
```dart

```

Template of an interface for Usecases

**`interface_usecase`**
```dart
abstract class I{{file_name|pascalCase}} {
  Future<void> call();
}
```  

Template of an implementation of Usecase using interface

**`usecase`**
```dart
class {{file_name|pascalCase}} extends I{{file_name|pascalCase}} {
  @override
  Future<void> call() async {
    throw UnimplementedError();
  }
}
```