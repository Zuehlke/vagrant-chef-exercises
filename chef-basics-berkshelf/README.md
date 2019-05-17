## Chef Basics: Berkshelf

Since we learned that cookbooks are the unit of packaging and distribution,
you might be wondering how to find and reuse other library cookbooks, don't you?

### Where to find Cookbooks?

If you are looking for other cookbooks the central place to find them is the "supermarket":

 * https://supermarket.chef.io/

Other places to look for are Github repositories (e.g. search for ["cookbooks" written in Ruby](https://github.com/search?l=Ruby&q=cookbook&type=Repositories))

### How to (re-)use other Cookbooks?

The answer is simple: you need a cookbook dependency management tool. The most popular one is a tool called "berkshelf":

 * https://docs.chef.io/berkshelf.html

### Install / vendor Cookbook dependencies directly

In essence, you need a `Berksfile` which lists the cookbook sources and the specific dependencies you want to install:
```ruby
source 'https://supermarket.chef.io'

cookbook 'jenkins', '7.0.0'
```

Then you can run `berks vendor`, which will "install" the specified cookbooks (along with their dependencies) to `~/.berkshelf/cookbooks` and "vendor" it to the `./berks-cookbooks` directory:
```
$ berks vendor
Resolving cookbook dependencies...
Fetching cookbook index from https://supermarket.chef.io...
Installing dpkg_autostart (0.2.0)
Installing jenkins (7.0.0)
Installing packagecloud (1.0.1)
Installing runit (5.1.0)
Installing yum-epel (3.3.0)
Vendoring dpkg_autostart (0.2.0) to /home/user/vagrant-chef-exercises/chef-basics-berkshelf/berks-cookbooks/dpkg_autostart
Vendoring jenkins (7.0.0) to /home/user/vagrant-chef-exercises/chef-basics-berkshelf/berks-cookbooks/jenkins
Vendoring packagecloud (1.0.1) to /home/user/vagrant-chef-exercises/chef-basics-berkshelf/berks-cookbooks/packagecloud
Vendoring runit (5.1.0) to /home/user/vagrant-chef-exercises/chef-basics-berkshelf/berks-cookbooks/runit
Vendoring yum-epel (3.3.0) to /home/user/vagrant-chef-exercises/chef-basics-berkshelf/berks-cookbooks/yum-epel
```

Note that it will also create a `Berksfile.lock`, which pins the exact dependencies that have been resolved.
(in case that a `Berksfile.lock` is already present, berkshelf will use the pinned dependencies and not try
to re-resolve them):
```
DEPENDENCIES
  jenkins (= 7.0.0)

GRAPH
  dpkg_autostart (0.2.0)
  jenkins (7.0.0)
    dpkg_autostart (>= 0.0.0)
    runit (>= 1.7)
  packagecloud (1.0.1)
  runit (5.1.0)
    packagecloud (>= 0.0.0)
    yum-epel (>= 0.0.0)
  yum-epel (3.3.0)
```

### Install / vendor Cookbook dependencies from metadata.rb

In case you write your own cookbook, you need to specify it's cookbook dependencies in `metadata.rb`:
```ruby
name "hello"
description "says hello, what do you expect?"
version "0.1.0"

depends "apt", "7.1.1"
```

In order to avoid duplication the `Berksfile` also supports the "metadata" keyword, which essentially
instructs berkshelf to use the dependencies defined in `metadata.rb`:
```ruby
source 'https://supermarket.chef.io'

metadata
```