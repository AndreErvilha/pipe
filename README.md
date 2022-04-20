# Pipe CLI

## Why should I use it?

Pipe goal's is help users automate everyday tasks and standardize codes. Pipe allow you create and
document CLI commands and code templates using ``markdown`` and ``yaml``. With Pipe you can create
scripts that:

- Generate code
- Refactor code
- Run commands

and much more.

## Motivations

You probably know a CLI command, but it takes care of everything you need?

Sometimes we need a very specific command or, that well know command with some changes, but
sometimes these changes are not possible to config and there are no command that meet expectations
available.

**Pipe CLI** allows you write CLI commands with flexible configurations using scripts ``yaml`` and
pre-fabs [commands](#Commands).

# Features

- [Create CLI (Command Line Interface)](#create-cli-command-line-interface)
- [Create subcommands](#create-subcommands)
- [Add options to CLI](#add-options-to-cli)

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

````markdown
**`example.yaml`**

```yaml
say_hello:
 name: 'hello'            # Name of command, used to call it on terminal
 abbr: 'h'                # Abbrev of command, used as an alias of Name
 description: 'Say hello'
 execute:
  - print: 'Hello World'    # A pre-fab command called "print" that show 'Hello World' in terminal
```
````

to use just simple runs

```bash
pipe say hello
```

### Create subcommands

To create a subcommand write first your command and add a list named `sub-commands` with the name of
cli that will work as subcommand, subcommands name must have command name and name separated by a
dot.

````markdown
**`example.yaml`**

```yaml
say:
  name: 'say'            # Name of command, used to call it on terminal
  abbr: 's'                # Abbrev of command, used as an alias of Name
  description: 'Say something'
  sub_commands:
    - say.hello
say.hello:
  name: 'hello'
  abbr: 'h'
  description: 'Say hello
  execute:
    - print: 'Hello World'    # A pre-fab command called "print" that show 'Hello World' in terminal
```
````

to use just simple runs

```bash
pipe say hello
```

### Add options to CLI

To create a subcommand write first your command and add a list named `sub-commands` with the name of
cli that will work as subcommand, subcommands name must have command name and name separated by a
dot.

````markdown
**`example.yaml`**
```yaml
say:
  name: 'say'              # Name of command, used to call it on terminal
  abbr: 's'                # Abbrev of command, used as an alias of Name
  description: 'Say something'
  sub_commands:
    - say.hello
say.hello:
  name: 'hello'
  abbr: 'h'
  description: 'Say hello
  args:
    world:
      help: "appends a word 'World' to phrase"   # help text showed when use --help flag
      abbr: w                                    # an alias to this flag (usage -w)
      negatable: true                            # create option --no-world that set world as false
      defaults: true                             # set defaults as true
  execute:
    if_flag:
      flag: world
      then:
        - print: 'Hello World'    # A pre-fab command called "print" that show 'Hello World' in terminal
      else:
        - print: 'Hello'          # A pre-fab command called "print" that show 'Hello' in terminal
```
````

to use just simple runs

```bash
pipe say hello --world
```

or

```bash
pipe say hello -w
```

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

The command receive a pattern, extracts of this pattern two arguments `feature` and `name`, then
creates a usecase named `**name**_usecase.dart` in
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
````

### Detailing

1. Name of your script
   > You **must** declare the name of yaml script at least once, on first declaration.

    ````markdown
    **`name_of_script`**
    ````

2. Script declaration named **`gen_usecase`**, where created a CLI command named **`usecase`** with
   abbrev **`u`** and description **` Creates an usecase in a custom template`**.
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

4. Execution steps declaration Note that there are Objects and Values, the objects are interpreted
   as a [Command](#Commands) and the Values as a [Variable](#Variables).

   ````markdown
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
   ````

5. Creates a dart template

   ````markdown
   **`interface_usecase`**
   ```dart
   abstract class I{{file_name|pascalCase}} {
     Future<void> call();
   }
   ```
   ````

## Commands

**capture**: Create variables with names
equals [named capturing groups](https://docs.microsoft.com/pt-br/dotnet/standard/base-types/grouping-constructs-in-regular-expressions#named-matched-subexpressions) (
regex) of gived `regex` with values matches in `text`.

````markdown
```yaml
...
capture:
 text: 'a CamelCase word'
 regex: '(?<word_with_camelCase>^[a-z]|[A-Z0-9])[a-z]*'
```
````

**generate**: Create a file `path` with content `template`.

````markdown
```yaml
...
generate:
 template: '{{build_usecase}}'
 path: '{{file_path}}'
```
````

**print**: Print the given value.

````markdown
```yaml
...
print: 'Hello World'
```
````

**run**: Run a command at terminal.

````markdown
```yaml
...
run:
  executable: 'dart'
  args:
    - pub
    - add
    - dio
  show_outputs: true      # defaults true - show outputs of given command (dart) 
  provide_feedback: true  # defaults true - provide a feedback of success or error at end the command
```
````

## Variables

Declare variables using an yaml object with value `String` `num` `bool`, the variable name must not
match an object name.
> You can interpolate values using double mustache expression `Hello {{name}}`.

````markdown
```yaml
...
name: 'André'
hello_world: 'Hello {{André}}'
print: hello_world
```
````

## Templates

Dart code are saved as templates and can be used as parameter using eval sintax `{{template_name}}`
passing the name of template that is the content before dart block between template name pattern
``**`name_of_template`**``

````markdown
```yaml
generate_class:
  name: generate_class
  abbr: g
  description: Creates a Class.
  execute:
    - class_name: 'some_class'
    - generate:
        template: '{{use_case.dart}}'
        path: 'lib/classes/{{class_name}}.dart'
```

**`class_template`**

```dart
class {{class_name|pascalCase}}{}
```
````