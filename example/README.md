# Getting Started
1. Create `pipe.md` at root directory of your project 

````markdown
**`greetings`**
```yaml
greetings:
 name: hello
 abbr: h
 description: 'A simple hello world'
 execute:
  name: world
  print: 'Hello {{name}}'
```
````

2. Execute command

```bash
pipe hello
```

Expect output
```bash
SUCCESS: print => Hello world
```