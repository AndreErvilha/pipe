# Pipes

Declaration of Command usecase(u).

>**`pipe.yaml`**
```yaml
gen_usecase:  
 name: usecase
 abbr: u
 description: 'Creates an usecase in a custom template'
```

Declaration of flags and options [Work In Progress]

```yaml
 args:
  repository:
   help: 'Create repository file'
   abbr: r
   negatable: false
  service: 
   help: 'Create service file'
   abbr: s
   negatable: false
  no-test:
   help: 'Avoid test files creation'
   abbr: n
   negatable: false
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
  - created_by: 'andré_ervilha'
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
// Created by {{created_by|pascalCase}}, {{created_by|snackCase}}
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