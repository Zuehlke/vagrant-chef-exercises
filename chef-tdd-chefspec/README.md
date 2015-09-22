## Chef TDD: Unit Testing with ChefSpec and Fauxhai

ChefSpec is an rspec library for unit testing Chef cookbooks, Fauxhai provides
mocked ohai data for different platforms:

* [chefspec](https://github.com/sethvargo/chefspec)
* [fauxhai](https://github.com/customink/fauxhai)

### Running ChefSpec Examples

When we created our cookbook earlier, a first ChefSpec test was already generated
for us in `myapp/spec/unit/recipes/default_spec.rb`:
```ruby
require 'spec_helper'

describe 'myapp::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
```

As usual you can run the ChefSpec examples via rake, and it should be passing:
```
$ rake chefspec
rspec --format doc --color

myapp::default
  When all attributes are default, on an unspecified platform
    converges successfully

Finished in 0.26818 seconds (files took 1.12 seconds to load)
1 example, 0 failures
```

### Adding Tests

Since we specified earlier that we want to install "apache2" and ensure that the
"apache2" service is started, we could verify that in a unit test by adding some
more expectations:
```ruby
...
  it 'installs apache webserver' do
    expect(chef_run).to install_package('apache2')
  end
  it 'makes sure the apache service is started' do
    expect(chef_run).to start_service('apache2')
  end
...
```

That should pass as well according to our minimal default recipe from the last
step, which should still look like this:
```ruby
package 'apache2' do
  action :install
end

service 'apache2' do
  action :start
end
```

And so should the tests pass:
```
$ rake chefspec
rspec --format doc --color

myapp::default
  When all attributes are default, on an unspecified platform
    converges successfully
    installs apache webserver
    makes sure the apache service is started

Finished in 0.66116 seconds (files took 1.09 seconds to load)
3 examples, 0 failures

```

While we are at it, we should also make sure that the service is enabled / started
when at startup (e.g. when the system is rebooted):
```ruby
...
  it 'enables the apache service when the system starts up' do
    expect(chef_run).to enable_service('apache2')
  end
...
```

This will probably be failing...
```
$ rake chefspec
rspec --format doc --color

myapp::default
  When all attributes are default, on an unspecified platform
    converges successfully
    installs apache webserver
    makes sure the apache service is started
    enables the apache service when the system starts up (FAILED - 1)

Failures:

  1) myapp::default When all attributes are default, on an unspecified platform enables the apache service when the system starts up
     Failure/Error: expect(chef_run).to enable_service("apache2")
       expected "service[apache2]" actions [:start] to include :enable
     # ./spec/unit/recipes/default_spec.rb:26:in `block (3 levels) in <top (required)>'

Finished in 0.88344 seconds (files took 1.11 seconds to load)
4 examples, 1 failure

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:25 # myapp::default When all attributes are default, on an unspecified platform enables the apache service when the system starts up

rake aborted!
Command failed with status (1): [rspec --format doc --color...]
/home/tkn/zdays/zdays2015-demo-repo/playground/myapp/Rakefile:15:in `block in <top (required)>'
Tasks: TOP => chefspec
(See full trace by running task with --trace)
```

...until we fix it in our `default.rb` recipe:
```ruby
...
service 'apache2' do
  action [:start, :enable]
end
...
```

And we see it passing!
```
$ rake chefspec
rspec --format doc --color

myapp::default
  When all attributes are default, on an unspecified platform
    converges successfully
    installs apache webserver
    makes sure the apache service is started
    enables the apache service when the system starts up

Finished in 0.926 seconds (files took 1.14 seconds to load)
4 examples, 0 failures

```

### When and What to test with ChefSpec?

Running ChefSpec does not actually converge your system, i.e. it does not
really install the "apache2" package. Instead it builds up the so-called "resource
collection" and verifies that a package resource with name "apache2" and action
":install" is actually contained therein.

By no means does that guarantee that the installation of the "apache2" package
would succeed on your platform (that's what test-kitchen will do, bear with me
for a moment). It might even be named "httpd" if you are on CentOS or would
not work at all when you are on Windows...

So what are useful tests that can be done on ChefSpec / unit level?

Answer: anything that is parameterized (e.g. via attributes, data bags, environments, etc)
or involves conditional logic (such as platform-specific behavior)


### Extending our Tests and Recipes

How useful is a web server without serving any useful content anyway?

So let's get back to work and make it show some great content that can be configured
via a node attribute. This time we start with a spec test first:
```ruby
...
  context 'with the myapp/page_content attribute set' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['myapp']['page_content'] = 'ZDays rocks!'
      end
      runner.converge(described_recipe)
    end
    it 'serves the great content we defined' do
      expect(chef_run).to render_file('/var/www/html/index.html').with_content('ZDays rocks!')
    end
  end
...
```

Running that should give us a failure since we are really TDD-ing here:
```
$ rake chefspec
rspec --format doc --color

myapp::default
  When all attributes are default, on an unspecified platform
    converges successfully
    installs apache webserver
    makes sure the apache service is started
    enables the apache service when the system starts up
  with the myapp/page_content attribute set
    serves the great content we defined (FAILED - 1)

Failures:

  1) myapp::default with the myapp/page_content attribute set serves the great content we defined
     Failure/Error: expect(chef_run).to render_file('/var/www/html/index.html').with_content('<html><body>ZDays rocks!</html></html>')
       expected Chef run to render "/var/www/html/index.html" matching:

       <html><body>ZDays rocks!</html></html>

       but got:



     # ./spec/unit/recipes/default_spec.rb:37:in `block (3 levels) in <top (required)>'

Finished in 1.11 seconds (files took 1.11 seconds to load)
5 examples, 1 failure

```

In order to make it work we have to:

 * add a template resource to our default recipe `recipes/default.rb`:
```ruby
template '/var/www/html/index.html' do
  source 'index.html.erb'
  variables(
    content: node['myapp']['page_content']
  )
end
```
 * add the actual template in `templates/default/index.html.erb`:
```html
<html><body><%= @content %></body></html>
```
 * and probably define a default value for the node attribute in `attributes/default.rb`:
```ruby
node.default['myapp']['page_content'] = 'some stuff!'
```

In addition, we should also test for the default value:
```ruby
...
  context 'When all attributes are default, on an unspecified platform' do
    ...
    it 'serves just some stuff' do
      expect(chef_run).to render_file('/var/www/html/index.html').with_content('some stuff!')
    end
  end
...
```

Finally having all specs passing :-)
```
$ rake chefspec
rspec --format doc --color

myapp::default
  When all attributes are default, on an unspecified platform
    converges successfully
    installs apache webserver
    makes sure the apache service is started
    enables the apache service when the system starts up
    serves just some stuff
  with the myapp/page_content attribute set
    serves the great content we defined

Finished in 1.34 seconds (files took 1.1 seconds to load)
6 examples, 0 failures

```
