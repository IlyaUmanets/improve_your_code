# Rake Task

## Introduction

ImproveYourCode provides a Rake task that runs ImproveYourCode on a set of source files. In its most simple form you just include something like that in your Rakefile:

```Ruby
require 'improve_your_code/rake/task'

ImproveYourCode::Rake::Task.new do |t|
  t.fail_on_error = false
end
```

In its most simple form, that's it.

When you now run:

```Bash
rake -T
```

you should see

```Bash
rake improve_your_code  # Check for code smells
```

## Configuration via task

An more sophisticated rake task that would make use of all available configuration options could look like this:

```Ruby
ImproveYourCode::Rake::Task.new do |t|
  t.name          = 'custom_rake' # Whatever name you want. Defaults to "improve_your_code".
  t.config_file   = 'config/config.improve_your_code' # Defaults to nothing.
  t.source_files  = 'vendor/**/*.rb' # Glob pattern to match source files. Defaults to lib/**/*.rb
  t.improve_your_code_opts     = '-U'  # Defaults to ''. You can pass all the options here in that are shown by "improve_your_code -h"
  t.fail_on_error = false # Defaults to true
  t.verbose       = true  # Defaults to false
end
```

Alternatively, you can create your own [Rake::FileList](http://rake.rubyforge.org/classes/Rake/FileList.html) and use that for `source_files`:

```Ruby
ImproveYourCode::Rake::Task.new do |t|
  t.source_files = FileList['lib/**/*.rb'].exclude('lib/templates/**/*.rb')
end
```

## Configuration via environment variables

You can overwrite the following attributes by environment variables:

- "improve_your_code_opts" by using IMPROVE_YOUR_CODE_OPTS
- "config_file" by using IMPROVE_YOUR_CODE_CFG
- "source_files" by using IMPROVE_YOUR_CODE_SRC

An example rake call using environment variables could look like this:

```Bash
IMPROVE_YOUR_CODE_CFG="config/custom.improve_your_code" IMPROVE_YOUR_CODE_OPTS="-s" rake improve_your_code
```

See also: [ImproveYourCode-Driven-Development](ImproveYourCode-Driven-Development.md)
