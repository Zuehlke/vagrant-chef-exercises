
## Chef TDD: Chef-level Linting with Foodcritic

Similar to Rubocop, Foodcritic is also a linting tool for detecting bugs and
ensure a consistent coding style. However, Foodcritic does the lint checking
on top of the Chef DSL:

 * [foodcritic](https://acrmp.github.io/foodcritic/) for Chef-level linting

### Running Foodcritic Linting

The first thing to run is `rake foodcritic`:
```
$ rake foodcritic
foodcritic -f any .

```

Silence means everything is good in this case :-)

So let's introduce some erroneous recipe code:
```ruby
package "apache2" do
  action :installed
end

execute "start-apache" do
  command "/etc/init.d/apache2 start"
end
```

Did you already spot it? Foodcritic did:
```
$ rake foodcritic
foodcritic -f any .
FC004: Use a service resource to start and stop services: ./recipes/default.rb:5
FC038: Invalid resource action: ./recipes/default.rb:1
rake aborted!
Command failed with status (3): [foodcritic -f any ....]
/home/tkn/zdays/zdays2015-demo-repo/playground/myapp/Rakefile:10:in `block in <top (required)>'
Tasks: TOP => foodcritic
(See full trace by running task with --trace)
```

### Correcting the Issues

Foodcritic does not have something like auto-correction, but since the reported
issues are much fewer on this level it's not really a big deal.

First, we were using an incorrect action `:installed` which should have been `:install` rather:
```ruby
package "apache2" do
  action :install
end
```

Next, we were using an `execute` resource which should only be the last resort if there
is no alternative resource which does the same thing with idempotency and platform
independence already built in! In that case, Foodcritic recognized we should have
rather used the `service` resource:
```ruby
service "apache2" do
  action :start
end
```

Fixing this in our recipe will also make foodcritic happy again:
```
$ rake foodcritic
foodcritic -f any .

```

### Ignoring Rules

In case you need to ignore specific rules, or work with a subset of the rules only,
you can do that by specifying which rules you want to run:
```
$ bundle exec foodcritic --tags FC004 .
FC004: Use a service resource to start and stop services: ./recipes/default.rb:5

```

...or by telling which rules you don't want to run:
```
$ bundle exec foodcritic --tags ~FC004 .
FC038: Invalid resource action: ./recipes/default.rb:1

```

### Tipp: Check out the Rules

You might want to check the Foodcritic Rules to get a better impression on the
actual checks that it does. Each rule comes with a good / bad example and should
be well understandable:
https://acrmp.github.io/foodcritic/#rules


### Tipp: Run Rubocop first

It's a good idea to run the lower level tests first. In the case we actually
introduced some new rubocop offenses without noticing:
```
$ rake rubocop
rubocop . --format progress --format offenses
Inspecting 8 files
.......C

Offenses:

recipes/default.rb:1:9: C: Prefer single-quoted strings when you don't need string interpolation or special symbols.
package "apache2" do
        ^^^^^^^^^
recipes/default.rb:5:9: C: Prefer single-quoted strings when you don't need string interpolation or special symbols.
service "apache2" do
        ^^^^^^^^^

8 files inspected, 2 offenses detected

2  Style/StringLiterals
--
2  Total

rake aborted!
Command failed with status (1): [rubocop . --format progress --format offen...]
/home/tkn/zdays/zdays2015-demo-repo/playground/myapp/Rakefile:5:in `block in <top (required)>'
Tasks: TOP => rubocop
(See full trace by running task with --trace)
```

Those are easys ones though that I usually fix via auto-correction:
```
$ bundle exec rubocop --auto-correct
Inspecting 8 files
.......C

Offenses:

recipes/default.rb:1:9: C: [Corrected] Prefer single-quoted strings when you don't need string interpolation or special symbols.
package "apache2" do
        ^^^^^^^^^
recipes/default.rb:5:9: C: [Corrected] Prefer single-quoted strings when you don't need string interpolation or special symbols.
service "apache2" do
        ^^^^^^^^^

8 files inspected, 2 offenses detected, 2 offenses corrected
```
