**`pipe.yaml`**
```yaml
pipeline_example:  
 name: usecase1
 abbr: w
 description: 'Creates an usecase in a custom template'
```

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

```yaml
 execute:
  - install:
    - get_it
  - capture:
     text: '{{rest}}'
     regex: '(?<feature>[A-z]*)@(?<name>[A-z]*)'
  - file_name: '{{name}}_usecase'
  - file_path: 'lib/features/{{feature}}/domain/usecase/{{file_name}}.dart'
  - new_line: 
  - build_usecase: '{{interface_usecase}}{{\n}}{{usecase}}'
  - generate:
     template: '{{build_usecase}}'
     path: '{{file_path}}'
```

# Templates

## Utils

Creates a new line
### **`\n`**
```dart

```

## Usecases
###  **`interface_usecase`**
```dart
abstract class I{{file_name|pascalCase}} {
	Future<void> call();
}
```  

### **`usecase`**
```dart
class {{file_name|pascalCase}} extends I{{file_name|pascalCase}} {  
 @override
 Future<void> call() async {
   throw UnimplementedError();
 }
}
```