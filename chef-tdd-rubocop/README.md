
## Chef TDD: Ruby-level Linting with Rubocop

Lint checks find easy to catch bugs and ensure a consistent coding style. For linting Chef cookbooks you usually use:

 * [rubocop](https://github.com/bbatsov/rubocop) for Ruby-level linting

### Running Rubocop Linting

The first thing to run is `rake rubocop`:
```
$ rake rubocop
rubocop . --format progress --format offenses
Inspecting 9 files
..C......

Offenses:

Rakefile:24:6: C: Use the new Ruby 1.9 hash syntax.
task :unit => [:rubocop, :foodcritic, :chefspec]
     ^^^^^^^^

9 files inspected, 1 offense detected

1  Style/HashSyntax
--
1  Total

rake aborted!
Command failed with status (1): [rubocop . --format progress --format offen...]
/home/tkn/zdays/zdays2015-demo-repo/playground/myapp/Rakefile:5:in `block in <top (required)>'
Tasks: TOP => rubocop
(See full trace by running task with --trace)
```

And ooops, it already found something in our `Rakefile`. We are using the outdated Ruby 1.9 syntax here and should use the Ruby 2.0 syntax instead.

### Manual Correction

We could simply correct that manually in our `Rakefile`:
```ruby
task unit: [:rubocop, :foodcritic, :chefspec]
```

We could easily fix that an run rubocop again:
```
$ rake rubocop
rubocop . --format progress --format offenses
Inspecting 9 files
.........

9 files inspected, no offenses detected

--
0  Total
```

### Auto-Correction

Another option would have been to auto-correct the offenses that rubocop finds. In order to do that, you would have run `bundle exec rubocop --auto-correct` instead:
```
$ bundle exec rubocop --auto-correct
Inspecting 9 files
..C......

Offenses:

Rakefile:24:6: C: [Corrected] Use the new Ruby 1.9 hash syntax.
task :unit => [:rubocop, :foodcritic, :chefspec]
     ^^^^^^^^

9 files inspected, 1 offense detected, 1 offense corrected
```

### Exclusions

Finally, we could also have excluded specific rules or even complete files via a `.rubocop.yml` configuration file.

I usually add a `.rubocop.yml` similar to this to my cookbook projects:
```yaml
Metrics/LineLength:
  Max: 120

Style/EmptyLinesAroundBlockBody:
  Enabled: false

AllCops:
  Exclude:
    - Rakefile
```

This excludes the Rakefile generally, allows line-length to exceed the 80 chars default, and lets me put an empty line before a block of code. That's just my gusto and YMMV ;-)  

This would also make it pass again:
```
$ rake rubocop
rubocop . --format progress --format offenses
Inspecting 8 files
........

8 files inspected, no offenses detected

--
0  Total
```

### A Note on Legacy Projects

When introducing rubocop to legacy projects it  will probably find lots of offenses. The easiest way to deal with that is to "generate a configuration file acting as a TODO list" via the `--auto-gen-config` option (from `bundle exec rubocop --help`):
```
$ bundle exec rubocop --auto-gen-config
Inspecting 9 files
..C......

Offenses:

Rakefile:24:6: C: Use the new Ruby 1.9 hash syntax.
task :unit => [:rubocop, :foodcritic, :chefspec]
     ^^^^^^^^

9 files inspected, 1 offense detected
Created .rubocop_todo.yml.
Run `rubocop --config .rubocop_todo.yml`, or
add inherit_from: .rubocop_todo.yml in a .rubocop.yml file.
```
