# Pipe CLI

## Why should I use it?

## Motivations

# Features

## Create CLI (Command Line Interface)

Create your own CLI without create a new project, using pre-fabs ``commands``.

# Installation

```bash
dart pub global activate pipe_cli
```

# usage
1. Create a [pipe.md](#pipe.md) file, write your CLI command using yaml
2. Run your CLI command
    ```bash
    pipe <your_created_cli>
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

## Commands

## Variables