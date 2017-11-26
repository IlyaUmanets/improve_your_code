# RSpec matchers

## Introduction

ImproveYourCode offers matchers for RSpec you can easily include into your project.

There are 3 matchers available:

- `improve_your_code`
- `improve_your_code_of`
- `improve_your_code_only_of`

## Quickstart

Let's install the dependencies:

```
gem install improve_your_code
gem install rspec
```

And then use it like that in your spec file:

```Ruby
require 'improve_your_code'
require 'improve_your_code/spec'
require 'rspec'

RSpec.describe 'ImproveYourCode Integration' do
  it 'works with ImproveYourCode' do
    smelly_class = 'class C; def m; end; end'
    expect(smelly_class).not_to improve_your_code
  end
end
```

Running this via

```
rspec improve_your_code-integration-spec.rb
```

would give you:

```
Failures:

  1) ImproveYourCode Integration works with ImproveYourCode
     Failure/Error: expect(smelly_class).not_to improve_your_code
       Expected no smells, but got:
         C has no descriptive comment (IrresponsibleModule)
         C has the name 'C' (UncommunicativeModuleName)
         C#m has the name 'm' (UncommunicativeMethodName)
     # ./improve_your_code-integration-spec.rb:8:in `block (2 levels) in <top (required)>'

Finished in 0.00284 seconds (files took 0.28815 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./improve_your_code-integration-spec.rb:6 # ImproveYourCode Integration works with ImproveYourCode
```

## The matchers explained

### `improve_your_code`

A very generic matcher that basically just tells you if something improve_your_codes, but
not after what exactly.
See the "Quickstart" example from above.

### `improve_your_code_of`

Checks the target source code for instances of "smell type"
and returns true only if it can find one of them that matches.

You can pass the smell type you want to check for as String or as Symbol:

- `:UtilityFunction`
- `"UtilityFunction"`

It is recommended to pass this as a symbol like `:UtilityFunction`. However we
don't enforce this.

Additionally you can be more specific and pass in "smell_details" you want to
check for as well e.g. "name" or "count" (see the examples below). The
parameters you can check for are depending on the smell you are checking for.
For instance "count" doesn't make sense everywhere whereas "name" does in most
cases. If you pass in a parameter that doesn't exist (e.g. you make a typo like
"namme") ImproveYourCode will raise an ArgumentError to give you a hint that you passed
something that doesn't make much sense.

So in a nutshell `improve_your_code_of` takes the following two arguments:

- `smell_type` - The "smell type" we check for.
- `smells_details` - A hash containing "smell warning" parameters

**Examples**

 Without smell_details:

```Ruby
  improve_your_code_of(:FeatureEnvy)
  improve_your_code_of(:UtilityFunction)
```

With smell_details:

```Ruby
  improve_your_code_of(:UncommunicativeParameterName, name: 'x2')
  improve_your_code_of(:DataClump, count: 3)
```

**Examples from a real spec**

```Ruby
  expect(src).to improve_your_code_of(:DuplicateMethodCall, name: '@other.thing')
```

### improve_your_code_only_of

See the documentaton for `improve_your_code_of`.

**Notable differences to `improve_your_code_of`:**

1. `improve_your_code_of` doesn't mind if there are other smells of a different type.
   "improve_your_code_only_of" will fail in that case.

2. `improve_your_code_only_of` doesn't support the additional smell_details hash.
