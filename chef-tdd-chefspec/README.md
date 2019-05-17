## Chef TDD: Unit Testing with ChefSpec and Fauxhai

ChefSpec is an rspec library for unit testing Chef cookbooks, Fauxhai provides
mocked ohai data for different platforms:

* [chefspec](https://github.com/chefspec/chefspec)
* [fauxhai](https://github.com/chefspec/fauxhai)

### Running ChefSpec Examples

When we created our cookbook earlier, a first ChefSpec test was already generated
for us in `myapp/spec/unit/recipes/default_spec.rb`:
```ruby
require 'spec_helper'

describe 'myapp::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
```

As usual you can run the ChefSpec examples via `rspec` command, and it should be passing:
```
$ rspec --format doc

myapp::default
  When all attributes are default, on Ubuntu 16.04
    converges successfully
  When all attributes are default, on CentOS 7.4.1708
    converges successfully

Finished in 0.66223 seconds (files took 2.36 seconds to load)
2 examples, 0 failures
```

### Adding Tests

Let's add some meaningful tests here to verify that the chef run would install the "apache2" package,
start the service, and also render the index.html file with the expected content:

```ruby
require 'spec_helper'

describe 'myapp::default' do
  context 'on Ubuntu' do
    platform 'ubuntu'
    it { is_expected.to install_package('apache2') }
    it { is_expected.to start_service('apache2') }
    it { is_expected.to render_file('/var/www/html/index.html').with_content 'Hello from john doe!' }
  end
end
```

And so it does:
```
$ rspec --format doc

myapp::default
  on Ubuntu
    should install package "apache2"
    should start service "apache2"
    should render file "/var/www/html/index.html"

Finished in 0.51791 seconds (files took 1.83 seconds to load)
3 examples, 0 failures
```

The actual use case for ChefSpec is for testing variations in the recipe,
e.g. due to different platforms or user-supplied attributes. So a more complete
spec for our scenario would look like this:

```ruby
require 'spec_helper'

describe 'myapp::default' do
  context 'on Ubuntu' do
    platform 'ubuntu'
    it { is_expected.to install_package('apache2') }
    it { is_expected.to start_service('apache2') }
    it { is_expected.to render_file('/var/www/html/index.html').with_content 'Hello from john doe!' }

    context 'with custom greeter configured' do
      default_attributes['myapp']['greeter'] = 'peter parker'
      it { is_expected.to render_file('/var/www/html/index.html').with_content 'Hello from john doe!' }
    end

    context 'on 18.04' do
      platform 'ubuntu', '18.04'
      it { is_expected.to render_file('/var/www/html/index.html').with_content 'ubuntu 18.04' }
    end

    context 'on 16.04' do
      platform 'ubuntu', '16.04'
      it { is_expected.to render_file('/var/www/html/index.html').with_content 'ubuntu 16.04' }
    end
  end
end
```

...which is still super fast:
```
$ rspec --format doc

myapp::default
  on Ubuntu
    should install package "apache2"
    should start service "apache2"
    should render file "/var/www/html/index.html"
    with custom greeter configured
      should render file "/var/www/html/index.html"
    on 18.04
      should render file "/var/www/html/index.html"
    on 16.04
      should render file "/var/www/html/index.html"

Finished in 0.65563 seconds (files took 1.68 seconds to load)
6 examples, 0 failures
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
