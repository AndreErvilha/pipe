# Pipe CLI

## Why should I use it?
Pipe goal's is help users automate everyday tasks and standardize codes. Pipe allow you create and document CLI commands and code templates using ``markdown`` and ``yaml``. With Pipe you can create scripts that:

- Generate code
- Refactor code
- Run commands

and much more.

## Motivations
You probably know a CLI command, but it takes care of everything you need?

Sometimes we need a very specific command or, that well know command with some changes, but sometimes these changes are not possible to config and there are no command that meet expectations available.

**Pipe CLI** allows you write CLI commands with flexible configurations using scripts ``yaml`` and pre-fabs [commands](#Commands).

# Features

- Create CLI (Command Line Interface)

# Installation

```bash
dart pub global activate pipe_cli
```

# Usage
### Getting Stated
1. Create a [pipe.md](#pipe.md) file, write your CLI command using yaml
2. Run your CLI command
    ```bash
    pipe <your_created_cli>
    ```

### Create CLI (Command Line Interface)
To create a new CLI command simple add your script inside file [pipe.md](#pipe.md).
````markdownn
**``example.yaml``**
```yaml
say_hello:
 name: 'hello'            # Name of command, used to call it on terminal
 abbr: 'h'                # Abbrev of command, used as an alias of Name
 description: 'Creates an usecase in a custom template'
 args:
  - repository:
     help: 'Create repository file'
     abbr: r
     negatable: false
 execute:
  - print: 'Hello World'    # A pre-fab command called "print" that show 'Hello World' in terminal
```
````

## Pipe.md

Create a markdown file named ``pipe.md`` then write your first command.

````markdown
**`name_of_script`**
```yaml
gen_usecase:
 name: usecase
 abbr: u
 description: 'Creates an usecase in a custom template'
```

Declaration of flags and options [Work In Progress].

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
````


### Detailing
1. Name of your script
> You **must** declare the name of yaml script at least once, on first declaration.
    ````markdown
    **`name_of_script`**
    ````
2. Script declaration named **``gen_usecase``**, where created a CLI command named **``usecase``** with abbrev **``u``** and description **``Creates an usecase in a custom template``**.
> Must be at next line after name.
    ````markdown
    **`name_of_script`**
    ```yaml
    usecase:
     name: usecase
     abbr: u
     description: 'Creates an usecase in a custom template'
    ```
    ````
3. Documentation of your script.
    ```markdown
    Declaration of flags and options [Work In Progress].
    ```
4. Continuation of **``gen_usecase``** script, declaring __flags__ to be used on your CLI command **``usecase``**.
    ````
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
    ````
5. Execution steps declaration

   Note that there are Objects and Values, the objects are interpreted as a [Command](#Commands) and the Values as a [Variable](#Variables).
   ````
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
   ````

6. Creates a dart template

   ````
   **`interface_usecase`**
   ```dart
   // Created by {{created_by|pascalCase}}, {{created_by|snackCase}}
   abstract class I{{file_name|pascalCase}} {
     Future<void> call();
   }
   ```
   ````

## Commands

## Variables