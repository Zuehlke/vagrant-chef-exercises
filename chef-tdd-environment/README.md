
## Chef TDD: Environment

The environment we need for ["Test-Driven Infrastructure with Chef"](http://www.amazon.com/Test-Driven-Infrastructure-Chef-Behavior-Driven-Development/dp/1449372201)
is a set of tools, which we want to briefly introduce here:

 * [cookstyle](https://docs.chef.io/cookstyle.html) is a linting tool on Ruby code level
 * [foodcritic](https://acrmp.github.io/foodcritic/) is a linting tool on Chef cookbook level
 * [chefspec](https://github.com/sethvargo/chefspec) + [fauxhai](https://github.com/customink/fauxhai) is for unit testing Chef cookbooks / mocking platforms
 * [test-kitchen](https://github.com/test-kitchen/test-kitchen) + [serverspec](http://serverspec.org) is an integration testing framework / library for testing servers

All of these tools come bundled with [ChefDK](https://downloads.chef.io/chef-dk/),
the "Chef Development Kit", in a specific version:
```
$ chef -v
Chef Development Kit Version: 3.9.0
chef-client version: 14.12.3
delivery version: master (9d07501a3b347cc687c902319d23dc32dd5fa621)
berks version: 7.0.8
kitchen version: 1.24.0
inspec version: 3.9.3

$ cookstyle -v
Cookstyle 3.0.2
  * RuboCop 0.55.0

$ foodcritic -V
foodcritic 15.1.0

$  kitchen -v
Test Kitchen version 1.24.0
```

ChefSpec, Fauhai and Serverspec are only libraries, not commandline tools. They
are also bundled at a very specific version within the ChefDK:
```
$ gem list chefspec fauxhai serverspec --no-details

*** LOCAL GEMS ***

chefspec (7.3.4)

*** LOCAL GEMS ***

fauxhai (6.11.0)

*** LOCAL GEMS ***

serverspec (2.41.3)
```

### Pro Tip: use a Rakefile

A `Rakefile` in Ruby is quite similar to a Makefile -- it let's you define the tasks
your are expected to run in a central place.

This is a `Rakefile` that can be commonly used for cookbook projects:
```ruby
desc 'check code style with cookstyle/rubocop'
task :cookstyle do
  sh 'cookstyle .'
end

desc 'run foodcritic lint checks'
task :foodcritic do
  sh 'foodcritic -f any .'
end

desc 'run chefspec examples'
task :chefspec do
  sh 'rspec --format doc --color'
end

desc 'run test-kitchen integration tests'
task :integration do
  sh 'kitchen test --log-level info'
end

desc 'run all unit-level tests'
task :unit => [:cookstyle, :foodcritic, :chefspec]
```

Whenever you see a `Rakefile` around, you can list the available tasks via `rake -T`:
```
$ rake -T
rake chefspec     # run chefspec examples
rake foodcritic   # run foodcritic lint checks
rake integration  # run test-kitchen integration tests
rake cookstyle    # check code style with cookstyle/rubocop
rake unit         # run all unit-level tests
```

Running a task then becomes as simple as running `rake foodcritic` or `rake unit`.
