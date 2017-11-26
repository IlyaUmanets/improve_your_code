## Introduction

_Too Many Methods_ is a case of [Large Class](Large-Class.md).

## Example

Given this configuration

```yaml
TooManyMethods:
  max_methods: 3
```

and this code:

```Ruby
class Smelly
  def one; end
  def two; end
  def three; end
  def four; end
end
```

ImproveYourCode would emit the following warning:

```
test.rb -- 1 warning:
  [1]:TooManyMethods: Smelly has at least 4 methods
```
## Current Support in ImproveYourCode

ImproveYourCode counts all the methods it can find in a class &mdash; instance *and* class
methods. So given `max_methods` from above is 4, this:

```Ruby
class Smelly
  class << self
    def one; end
    def two; end
  end

  def three; end
  def four; end
end
```

would cause ImproveYourCode to emit the same warning as in the example above.

## Configuration

ImproveYourCode's _Too Many Methods_ detector offers the [Basic Smell Options](Basic-Smell-Options.md), plus:

| Option        | Value   | Effect  |
| --------------|---------|---------|
| `max_methods` | integer | The maximum number of methods that are permitted. Defaults to 15 |
