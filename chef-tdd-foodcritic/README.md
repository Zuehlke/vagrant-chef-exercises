
## Chef TDD: Chef-level Linting with Foodcritic

Foodcritic is a linting tool for detecting bugs and ensuring best practices
on Chef Cookbook level:

 * [foodcritic](http://www.foodcritic.io/) for Chef-level linting

### Running Foodcritic Linting

The first thing to run is `foodcritic` in `~/myapp`:
```
$ cd ~/myapp
$ foodcritic .
Checking 2 files
x.
FC064: Ensure issues_url is set in metadata: ./metadata.rb:1
FC065: Ensure source_url is set in metadata: ./metadata.rb:1
FC067: Ensure at least one platform supported in metadata: ./metadata.rb:1
FC093: Generated README text needs updating: ./README.md:1
```

Ooops....

### Correcting the initial Issues

Let's fix the `metadata.rb` right away and add the missing properties:
```ruby
...
supports "ubuntu"
issues_url 'https://github.com/your.name/myapp/issues'
source_url 'https://github.com/your.name/myapp'
```

Looks better already:
```
$ foodcritic .
Checking 2 files
x.
FC093: Generated README text needs updating: ./README.md:1
```

Let's also update the `README.md`, e.g. like that:
```
# MyApp Cookbook

A Chef application cookbook for setting up MyApp
```

Hooray, silence means success here!
```
$ foodcritic .
Checking 2 files
..
```

### Installing Apache

So let's introduce some erroneous recipe code in `~/myapp/recipes/default.rb`:
```ruby
package 'apache2' do
  action :installed
end

execute 'start-apache' do
  command '/etc/init.d/apache2 start'
end
```

Did you already spot it? Foodcritic did:
```
$ foodcritic .
Checking 2 files
.x
FC004: Use a service resource to start and stop services: ./recipes/default.rb:31
FC038: Invalid resource action: ./recipes/default.rb:27
```

### Correcting the newly introduced Issues

Foodcritic does not have something like auto-correction, but since the reported
issues are much fewer on this level it's not really a big deal.

First, we were using an incorrect action `:installed` which should have been `:install` rather:
```ruby
package 'apache2' do
  action :install
end
```

Next, we were using an `execute` resource which should only be the last resort if there
is no alternative resource which does the same thing with idempotency and platform
independence already built in! In that case, Foodcritic recognized we should have
rather used the `service` resource:
```ruby
service 'apache2' do
  action :start
end
```

Fixing this in our recipe will also make foodcritic happy again:
```
$ foodcritic .
Checking 2 files
..
```

### Ignoring Rules

In case you need to ignore specific rules, or work with a subset of the rules only,
you can do that by specifying which rules you want to run:
```
$ foodcritic --tags FC004 .
FC004: Use a service resource to start and stop services: ./recipes/default.rb:31

```

...or by telling which rules you don't want to run:
```
$ foodcritic --tags ~FC004 .
FC038: Invalid resource action: ./recipes/default.rb:27

```

### Check out the Rules

You might want to check the Foodcritic Rules to get a better impression on the
actual checks that it does. Each rule comes with a good / bad example and should
be well understandable:
http://www.foodcritic.io
