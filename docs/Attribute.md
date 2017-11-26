# Attribute

## Introduction

A class that publishes a setter for an instance variable invites
client classes to become too intimate with its inner workings, and in
particular with its representation of state.

The same holds to a lesser extent for getters, but ImproveYourCode doesn't flag those.

## Example

Given:

```Ruby
class Klass
  attr_accessor :dummy
end
```

ImproveYourCode would emit the following warning:

```
improve_your_code test.rb

test.rb -- 1 warning:
  [2]:Attribute: Klass#dummy is a writable attribute
```

## Support in ImproveYourCode

This detector it raises a warning for every public `attr_writer`,
`attr_accessor`, and `attr` with the writable flag set to `true`.

ImproveYourCode does not raise warnings for read-only attributes.

## Configuration

_Attribute_ supports only the [Basic Smell Options](Basic-Smell-Options.md).
