# Command Line Options

## Introduction

ImproveYourCode follows standard Unix convention for passing arguments.

Check out

```Bash
improve_your_code -h
```

for details.

## Telling ImproveYourCode Which Code to Check

Probably the most standard use case would be to check all Ruby files in the lib directory:

```Bash
improve_your_code lib/*.rb
```

In general, if any command-line argument is a directory, ImproveYourCode searches that directory and all sub-directories for Ruby source files. Thus

```Bash
improve_your_code lib
```

would be equivalent to

```Bash
improve_your_code lib/**/*.rb
```

Occasionally you may want to quickly check a code snippet without going to the trouble of creating a file to hold it. You can pass the snippet directly to ImproveYourCode's standard input:

```Bash
echo "def x() true end" | improve_your_code
```

To just check all Ruby files in the current directory, you can simply run it
with no parameters:

```Bash
improve_your_code
```

## Telling ImproveYourCode Which Smells to Detect

You can tell ImproveYourCode to only check particular smells by using the `--smell`
option and passing in the smell name.

For example, to only check for [Utility Function](Utility-Function.md), you
would use:

```Bash
improve_your_code --smell UtilityFunction
```

You can select several smells by repeating the `--smell` option like so:

```Bash
improve_your_code --smell UtilityFunction --smell UncommunicativeMethodName
```

## Output options

### Output smell's line number

By passing in a "-n" flag to the _improve_your_code_ command, the output will suppress the line numbers:

```Bash
$ improve_your_code -n mess.rb
```

```
mess.rb -- 2 warnings:
  x doesn't depend on instance state (UtilityFunction)
  x has the name 'x' (UncommunicativeMethodName)
```

Otherwise line numbers will be shown as default at the beginning of each warning in square brackets:

```Bash
$ improve_your_code mess.rb
```

```
mess.rb -- 2 warnings:
  [2]:x doesn't depend on instance state (UtilityFunction)
  [2]:x has the name 'x' (UncommunicativeMethodName)
```

### Enable the ultra-verbose mode

_improve_your_code_ has a ultra-verbose mode which you might find helpful as a beginner. "ultra-verbose" just means that behind each warning a helpful link will be displayed which leads directly to the corresponding _improve_your_code_ wiki page.
This mode can be enabled via the "-U" or "--ultra-verbose" flag.

So for instance, if your test file would smell of _ClassVariable_, this is what the _improve_your_code_ output would look like:

```Bash
improve_your_code -U test.rb
```
```
test.rb -- 1 warning:
  [2]:Dummy declares the class variable @@class_variable (ClassVariable) [https://github.com/troessner/improve_your_code/wiki/Class-Variable]
```

Note the link at the end.
