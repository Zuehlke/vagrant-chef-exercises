
## Chef TDD: Scaffolding the MyApp Cookbook

Before for we step into TDD let's briefly revisit the structure of cookbooks
and how to scaffold / generate them.

### The MyApp Scenario

Our scenario for the remainder of this workshop is a sample web application called "myapp".

It's a super simple web application that will be set up using a Chef cookbook with the same
name and is just good enough to get to know the Chef TDD tools.

It will live in it's own Git repository (one repository per cookbook is a common practice
and has various benefits), so let's create a new workspace for it in `~/myapp`.

### Generating the MyApp Cookbook

The ChefDK includes a command called `chef`, which lets you easily create a new cookbook structure.
Let's make sure to run it from the home directory so that it creates the cookbook in `~/myapp`:
```
$ cd ~
$ chef generate cookbook myapp --copyright "Zuehlke Engineering GmbH" --email "your.name@zuehlke.com" --license mit
```

The above `chef generate` command scaffolded a cookbook structure with the basic skeleton files for
testing already included:
```
myapp/
├── Berksfile
├── CHANGELOG.md
├── chefignore
├── LICENSE
├── metadata.rb
├── README.md
├── recipes
│   └── default.rb
├── spec
│   ├── spec_helper.rb
│   └── unit
│       └── recipes
│           └── default_spec.rb
└── test
    └── integration
        └── default
            └── default_test.rb
```

It also initialized a Git repo in `~/myapp/.git` for us so we don't need to ;-)
```
$ cd ~/myapp
$ git slog
580eda0 (HEAD -> master) Merge branch 'add-delivery-configuration'
5af03a2 Add generated cookbook content
df5e2a7 Add generated delivery build cookbook
89682d6 Add generated delivery configuration
```

*Feel free to inspect the generated files already. Many of them will not be needed for now, 
but we will revisited them in the next sections*

For more details you can also check:
```
$ chef generate cookbook --help
$ chef generate --help
$ chef --help
```

### MyApp Service: Adding the initial Recipe

Let's use a combination of what we had earlier to `myapp/recipes/default.rb`:
```ruby
package "apache2" do
  action :install
end

service "apache2" do
  action [:enable, :start]
end

file "/var/www/html/index.html" do
  content "hello world!"
end

log "open your browser at http://localhost:8080 to see it running"
```

### MyApp Service: Make it configurable via Attributes

As already done before, let's also make the myapp cookbook configurable
with an attribute.

In `myapp/attributes/default.rb` add a "greeter" attribute:
```ruby
node.default['myapp']['greeter'] = 'john doe'
```

Then adapt `myapp/recipes/default.rb` accordingly:
```ruby
file "/var/www/html/index.html" do
  content "hello from #{node['myapp']['greeter']}!"
end
```

### MyApp Service: Adding Platform Specifics

In order to add some (artificial) platform specifics, let's simply output
the current platform and version as reported by [ohai](https://docs.chef.io/ohai.html). 

So in `myapp/recipes/default.rb`:
```ruby
file "/var/www/html/index.html" do
  content <<~HTML
    <html>
        <body>
            Hello from #{node['myapp']['greeter']}!<br/>
            (sent via #{node['platform']} #{node['platform_version']})
        </body>
    </html>
  HTML
end
```

### MyApp Service: Adding Cookbook Dependencies

One of the most commonly re-used cookbooks on debian based systems is the
[apt cookbook](https://supermarket.chef.io/cookbooks/apt), which ensures
that we have up-to-date apt package lists before installing anything via apt.

So we need to define the dependency in `myapp/metadata.rb`:
```ruby
...
depends 'apt', '7.1.1'
...
```

Also, we need to instruct Berkshelf to respect the dependencies defined in
the metadata, i.e. add the "metadata" keyword to `myapp/Berksfile`:
```ruby
source 'https://supermarket.chef.io'

metadata
```

And finally, include the "apt::default" recipe in our run list, e.g. by including
it at the very beginning in `myapp/recipes/default.rb`:
```ruby
include_recipe 'apt::default'
...
```