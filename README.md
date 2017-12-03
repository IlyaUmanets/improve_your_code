# Improve Your Code

## Code smell detector for Ruby

**Table of Contents**

- [Quickstart](#quickstart)
- [Example](#example)
- [Fixing Smell Warnings](#fixing-smell-warnings)

## Quickstart

ImproveYourCode is a tool that examines Ruby classes, modules and methods and reports any.

Install it via rubygems:

```Bash
gem install improve_your_code
```

and run it like this:

```Bash
improve_your_code
```

## Example

Imagine a source file `main.rb` containing:

```Ruby
module A
  # UncommunicativeModuleName: A has the name 'A'

  class Main

    # TooManyConstants: Main has 4 constants
    # TooManyMethods: Main Your class has 8 methods. We propose to use 
    # ExtractClass Pattern

    # TooManyInstanceVariables: Main has at least 4 instance variables.
    # We propose to use Facade Pattern

    FIRST = 1
    SECOND = 2
    THIRD = 3
    FOURTH = 4

    # LongParameterList: initialize has 4 parameters.
    # We propose to use Builder Pattern

    def initialize(first, second, third, fourth)
      @first = first
      @second = second
      @third = third
      @fourth = fourth
    end

    def first
      # TooManyStatements: first Your method has 6 statements.
      # We propose to use ExtractMethod Pattern

      # UncommunicativeVariableName: first has the variable name 'a'

      a = 1
      b = 2
      c = 3
      d = 4
      e = 5
      f = 6
    end

    def second

    end

    def third

    end

    def fourth

    end

    def fifth

    end

    def a(a)
      # UnusedParameters: a has unused parameter 'a'

      b = 1
    end

    private

    def b
      # UnusedPrivateMethod: Main has the unused private instance
      # method 'b'

    end
  end
end
```

ImproveYourCode will report the following code smells in this file:

```
$ improve_your_code

W

main.rb -- 17 warnings:
  [8]:LongParameterList: initialize has 4 parameters. We propose to use Builder Pattern.
  [2]:TooManyConstants: Main has 4 constants
  [2]:TooManyInstanceVariables: Main has at least 4 instance variables. We propose to use Facade Pattern
  [2]:TooManyMethods: Main Your class has 8 methods. We propose to use ExtractClass Pattern
  [15]:TooManyStatements: first Your method has 6 statements. We propose to use ExtractMethod Pattern
  [40]:UncommunicativeMethodName: a has the name 'a'
  [46]:UncommunicativeMethodName: b has the name 'b'
  [1]:UncommunicativeModuleName: A has the name 'A'
  [41]:UncommunicativeVariableName: a has the variable name 'b'
  [16]:UncommunicativeVariableName: first has the variable name 'a'
  [17]:UncommunicativeVariableName: first has the variable name 'b'
  [18]:UncommunicativeVariableName: first has the variable name 'c'
  [19]:UncommunicativeVariableName: first has the variable name 'd'
  [20]:UncommunicativeVariableName: first has the variable name 'e'
  [21]:UncommunicativeVariableName: first has the variable name 'f'
  [40]:UnusedParameters: a has unused parameter 'a'
  [46]:UnusedPrivateMethod: Main has the unused private instance method 'b'
17 total warnings

```

## Fixing Smell Warnings

ImproveYourCode focuses on high-level code smells, so we can't tell you how to fix warnings in
a generic fashion; this is and will always be completely dependent on your domain
language and business logic.
