## Chef TDD: Integration Testing with Test-Kitchen

Test-kitchen is an integration testing tool for Chef cookbooks. It is basically
a test runner which converges a matrix of platforms and test suites for you. It
is commonly used with Serverspec or InSpec which provide rspec matchers for testing servers:

 * [test-kitchen](https://github.com/test-kitchen/test-kitchen)
 * [serverspec](http://serverspec.org/)
 * [inspec](https://www.inspec.io/)

### Running Test-Kitchen

Our "myapp" example cookbook already contains a test suite and configuration for
test-kitchen.

The suite is located in `myapp/test/integration/default/default_test.rb`,
and in fact does nothing spectacular yet:
```ruby
# InSpec test for recipe myapp::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end
```

The configuration in `.kitchen.yml` is quite self-explanatory, but I usually
add some stuff to make it play nice with vagrant-cachier and use the correct
basebox when using the vagrant docker provider:
```yaml
---
driver:
  name: vagrant

provisioner:
  name: chef_zero
  require_chef_omnibus: 14.12.3
  chef_omnibus_install_options: -d /tmp/vagrant-cache/

verifier:
  name: inspec

platforms:
  - name: ubuntu-18.04
    driver:
      provider: docker
      box: tknerr/baseimage-ubuntu-18.04

suites:
  - name: default
    run_list:
      - recipe[myapp::default]
    verifier:
      inspec_tests:
        - test/integration/default
    attributes:

```

That's enough for running it via `kitchen test`:
```
$ kitchen test
-----> Starting Kitchen (v1.24.0)
-----> Cleaning up any prior instances of <default-ubuntu-1804>
-----> Destroying <default-ubuntu-1804>...
       ==> default: Stopping container...
       ==> default: Deleting the container...
       Vagrant instance <default-ubuntu-1804> destroyed.
       Finished destroying <default-ubuntu-1804> (0m5.75s).
-----> Testing <default-ubuntu-1804>
-----> Creating <default-ubuntu-1804>...
       Bringing machine 'default' up with 'docker' provider...
       ==> default: Creating the container...
           default:   Name: default-ubuntu-1804_default_1557902515
           default:  Image: tknerr/baseimage-ubuntu:18.04
           default: Volume: /home/user/.vagrant.d/cache/tknerr/baseimage-ubuntu-18.04:/tmp/vagrant-cache
           default:   Port: 127.0.0.1:2222:22
           default:  
           default: Container created: fdd954186fa8dbb0
       ==> default: Starting container...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: SSH address: 127.0.0.1:2222
           default: SSH username: vagrant
           default: SSH auth method: private key
           default: 
           default: Vagrant insecure key detected. Vagrant will automatically replace
           default: this with a newly generated keypair for better security.
           default: 
           default: Inserting generated public key within guest...
           default: Removing insecure key from the guest if it's present...
           default: Key inserted! Disconnecting and reconnecting using new SSH key...
       ==> default: Machine booted and ready!
       ==> default: Configuring cache buckets...
       ==> default: Running provisioner: shell...
           default: Running: inline script
       ==> default: Configuring cache buckets...
       [SSH] Established
       Vagrant instance <default-ubuntu-1804> created.
       Finished creating <default-ubuntu-1804> (0m25.44s).
-----> Converging <default-ubuntu-1804>...
       Preparing files for transfer
       Preparing dna.json
       Resolving cookbook dependencies with Berkshelf 7.0.8...
       Removing non-cookbook files before transfer
       Preparing validation.pem
       Preparing client.rb
-----> Installing Chef 14.12.3 package
       Downloading https://omnitruck.chef.io/install.sh to file /tmp/install.sh
       Trying wget...
       Download complete.
       ubuntu 18.04 x86_64
       Getting information for chef stable 14.12.3 for ubuntu...
       downloading https://omnitruck.chef.io/stable/chef/metadata?v=14.12.3&p=ubuntu&pv=18.04&m=x86_64
         to file /tmp/install.sh.638/metadata.txt
       trying wget...
       sha1     75916241c04d8a8658f3efff4d1dcf30a3a88d50
       sha256   dae16815100524683b0359980f79bb94474848a6d1683b93171744a203f20a92
       url      https://packages.chef.io/files/stable/chef/14.12.3/ubuntu/18.04/chef_14.12.3-1_amd64.deb
       version  14.12.3
       downloaded metadata file looks valid...
       /tmp/vagrant-cache//chef_14.12.3-1_amd64.deb exists
       Comparing checksum with sha256sum...
       Installing chef 14.12.3
       installing with dpkg...
       Selecting previously unselected package chef.
(Reading database ... 11558 files and directories currently installed.)
       Preparing to unpack ...//chef_14.12.3-1_amd64.deb ...
       Unpacking chef (14.12.3-1) ...
       Setting up chef (14.12.3-1) ...
       Thank you for installing Chef!
       Transferring files to <default-ubuntu-1804>
       Starting Chef Client, version 14.12.3
       [2019-05-15T06:42:29+00:00] WARN: Plugin Network: unable to detect ipaddress
       Creating a new client identity for default-ubuntu-1804 using the validator key.
       resolving cookbooks for run list: ["myapp::default"]
       Synchronizing Cookbooks:
         - myapp (0.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 2 resources
       Recipe: myapp::default
         * apt_package[apache2] action install
           - install version 2.4.29-1ubuntu4.6 of package apache2
         * service[apache2] action start
           - start service service[apache2]
       
       Running handlers:
       Running handlers complete
       Chef Client finished, 2/2 resources updated in 18 seconds
       Downloading files from <default-ubuntu-1804>
       Finished converging <default-ubuntu-1804> (0m28.22s).
-----> Setting up <default-ubuntu-1804>...
       Finished setting up <default-ubuntu-1804> (0m0.00s).
-----> Verifying <default-ubuntu-1804>...
       Loaded tests from {:path=>".home.user.myapp.test.integration.default"} 

Profile: tests from {:path=>"/home/user/myapp/test/integration/default"} (tests from {:path=>".home.user.myapp.test.integration.default"})
Version: (not specified)
Target:  ssh://vagrant@127.0.0.1:2222

  User root
     ↺  
  Port 80
     ↺  

Test Summary: 0 successful, 0 failures, 2 skipped
       Finished verifying <default-ubuntu-1804> (0m0.40s).
-----> Destroying <default-ubuntu-1804>...
       ==> default: Stopping container...
       ==> default: Deleting the container...
       Vagrant instance <default-ubuntu-1804> destroyed.
       Finished destroying <default-ubuntu-1804> (0m4.85s).
       Finished testing <default-ubuntu-1804> (1m4.98s).
-----> Kitchen is finished. (1m11.10s)
```

As you can see, this already:

 * spun up a fresh ubuntu 18.04 Vagrant docker baseimage
 * downloaded and installed chef-client 14.12.3
 * started a chef run and converged the system
 * ran the inspec tests (which were all skipped by now)

### Interacting with Test-Kitchen

Before we dig deeper into TDD'ing, we should learn some basic commands for
interacting and debugging with test-kitchen first:

* `kitchen list` - show instances(= platform + suite) and their status (running, converged, verified, etc)
* `kitchen destroy` - destroy instances
* `kitchen converge` - converge instances, i.e. apply the chef recipes
* `kitchen verify` - run tests against a converged instance, e.g. using serverspec
* `kitchen test` - shortcut for destroy + converge + verify
* `kitchen login` - login to an instance via SSH
* `kitchen diagnose` - show debugging / diagnostic information

*Note:* when you have multiple platforms / suites to test against defined in your
`.kitchen.yml` you can pass the name of the instance as the second parameter
(e.g. `kitchen verify <instance>`). If you don't pass the name the command will
be executed for *all* instances in the `.kitchen.yml` config.

The first thing we probably want to see now is that the apache web server is
actually running and serves the default content:
```
$ kitchen list
Instance             Driver   Provisioner  Verifier  Transport  Last Action    Last Error
default-ubuntu-1804  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>

$ kitchen converge
-----> Starting Kitchen (v1.24.0)
-----> Creating <default-ubuntu-1804>...
       Bringing machine 'default' up with 'docker' provider...
       ==> default: Creating the container...
           default:   Name: default-ubuntu-1804_default_1557902761
           default:  Image: tknerr/baseimage-ubuntu:18.04
           default: Volume: /home/user/.vagrant.d/cache/tknerr/baseimage-ubuntu-18.04:/tmp/vagrant-cache
           default:   Port: 127.0.0.1:2222:22
           default:  
           default: Container created: a70c5ba87cd5b7bd
       ==> default: Starting container...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: SSH address: 127.0.0.1:2222
           default: SSH username: vagrant
           default: SSH auth method: private key
           default: 
           default: Vagrant insecure key detected. Vagrant will automatically replace
           default: this with a newly generated keypair for better security.
           default: 
           default: Inserting generated public key within guest...
           default: Removing insecure key from the guest if it's present...
           default: Key inserted! Disconnecting and reconnecting using new SSH key...
       ==> default: Machine booted and ready!
       ==> default: Configuring cache buckets...
       ==> default: Running provisioner: shell...
           default: Running: inline script
       ==> default: Configuring cache buckets...
       [SSH] Established
       Vagrant instance <default-ubuntu-1804> created.
       Finished creating <default-ubuntu-1804> (0m24.35s).
-----> Converging <default-ubuntu-1804>...
       Preparing files for transfer
       Preparing dna.json
       Resolving cookbook dependencies with Berkshelf 7.0.8...
       Removing non-cookbook files before transfer
       Preparing validation.pem
       Preparing client.rb
-----> Installing Chef 14.12.3 package
       Downloading https://omnitruck.chef.io/install.sh to file /tmp/install.sh
       Trying wget...
       Download complete.
       ubuntu 18.04 x86_64
       Getting information for chef stable 14.12.3 for ubuntu...
       downloading https://omnitruck.chef.io/stable/chef/metadata?v=14.12.3&p=ubuntu&pv=18.04&m=x86_64
         to file /tmp/install.sh.638/metadata.txt
       trying wget...
       sha1     75916241c04d8a8658f3efff4d1dcf30a3a88d50
       sha256   dae16815100524683b0359980f79bb94474848a6d1683b93171744a203f20a92
       url      https://packages.chef.io/files/stable/chef/14.12.3/ubuntu/18.04/chef_14.12.3-1_amd64.deb
       version  14.12.3
       downloaded metadata file looks valid...
       /tmp/vagrant-cache//chef_14.12.3-1_amd64.deb exists
       Comparing checksum with sha256sum...
       Installing chef 14.12.3
       installing with dpkg...
       Selecting previously unselected package chef.
(Reading database ... 11558 files and directories currently installed.)
       Preparing to unpack ...//chef_14.12.3-1_amd64.deb ...
       Unpacking chef (14.12.3-1) ...
       Setting up chef (14.12.3-1) ...
       Thank you for installing Chef!
       Transferring files to <default-ubuntu-1804>
       Starting Chef Client, version 14.12.3
       [2019-05-15T06:46:32+00:00] WARN: Plugin Network: unable to detect ipaddress
       Creating a new client identity for default-ubuntu-1804 using the validator key.
       resolving cookbooks for run list: ["myapp::default"]
       Synchronizing Cookbooks:
         - myapp (0.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 2 resources
       Recipe: myapp::default
         * apt_package[apache2] action install
           - install version 2.4.29-1ubuntu4.6 of package apache2
         * service[apache2] action start
           - start service service[apache2]
       
       Running handlers:
       Running handlers complete
       Chef Client finished, 2/2 resources updated in 19 seconds
       Downloading files from <default-ubuntu-1804>
       Finished converging <default-ubuntu-1804> (0m27.21s).
-----> Kitchen is finished. (0m56.21s)

$ kitchen list
Instance             Driver   Provisioner  Verifier  Transport  Last Action  Last Error
default-ubuntu-1804  Vagrant  ChefZero     Inspec    Ssh        Converged    <None>
```

Now we see that the system is converged, but we didn't see it running yet. As
we don't know the IP address of the docker container yet, we could check from the
inside whether apache is running via `kitchen login`:
```
$ kitchen login
Last login: Wed May 15 06:50:37 2019 from 172.17.0.1

vagrant@default-ubuntu-1804:~$ wget localhost
--2019-05-15 06:52:34--  http://localhost/
Resolving localhost (localhost)... 127.0.0.1, ::1
Connecting to localhost (localhost)|127.0.0.1|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 10918 (11K) [text/html]
Saving to: ‘index.html.1’

index.html.1                                  100%[===============================================================================================>]  10.66K  --.-KB/s    in 0s      

2019-05-15 06:52:34 (258 MB/s) - ‘index.html.1’ saved [10918/10918]
```

...or even "tunnel in" via `kitchen exec`:
```
$ kitchen exec -c "wget localhost"
-----> Execute command on default-ubuntu-1804.
       --2019-05-15 06:56:15--  http://localhost/
       Resolving localhost (localhost)... 127.0.0.1, ::1
       Connecting to localhost (localhost)|127.0.0.1|:80... connected.
       HTTP request sent, awaiting response... 200 OK
       Length: 10918 (11K) [text/html]
       Saving to: ‘index.html.2’
       
index.html.2        100%[===================>]  10.66K  --.-KB/s    in 0s      
       
       2019-05-15 06:56:15 (212 MB/s) - ‘index.html.2’ saved [10918/10918]
```

### Networking: Accessing Test-Kitchen VMs from the Outside

Actually, you might have spotted the IP address of the docker container in the
log when the container was brought up. If not, we can still find out via `kitchen diagnose`:
```
$ kitchen diagnose | grep hostname
      hostname: 172.17.0.19
      vm_hostname: default-ubuntu-1804
```

So opening the browser at http://172.17.0.19 in this case should serve you
"some stuff!" already :-)

If you want it more predictable, you can set up port forwarding via localhost
as well. In that case you need to add that to the [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant)
driver configuration in `.kitchen.yml`:
```yaml
...
platforms:
  - name: ubuntu-14.04
    driver_config:
      box: tknerr/baseimage-ubuntu-14.04
      network:
        - ["forwarded_port", {guest: 80, host: 8080}]
...
```

After a `kitchen destroy` and `kitchen reload` you should finally be able to see
the same result via http://localhost:8080 too!

*Note:* usually we could also pass a "private_network" here, but that is currently
not supported by the underlying vagrant docker provider.

### Let's add some Tests!

Enough played, let's get back to serious work and add some tests now :-)

 * specs can be added in `test/integration/default/serverspec/default_spec.rb`
 * the serverspec matchers are described here: http://serverspec.org/resource_types.html

First, we probably want to check similar things as we did with ChefSpec before,
but *against a real converged system*. In addition, we also want to check if
the expected content is actually being served:
```ruby
require 'spec_helper'

describe 'myapp::default' do
  it 'installs apache2' do
    expect(package('apache2')).to be_installed
  end
  it 'starts the apache2 service' do
    expect(service('apache2')).to be_running
  end
  it 'enables the apache2 service at startup' do
    expect(service('apache2')).to be_enabled
  end

  context 'when no attributes are set' do
    it 'serves just some stuff' do
      expect(command('wget -qO- localhost').stdout).to match('some stuff!')
    end
  end
end
```

Since the docker container is still running from the previous step, we only
want to trigger the verification:
```
$ bundle exec kitchen verify
-----> Starting Kitchen (v1.8.0)
-----> Verifying <default-ubuntu-1404>...
       Preparing files for transfer
-----> Busser installation detected (busser)
       Installing Busser plugins: busser-serverspec
       Plugin serverspec already installed
       Removing /tmp/verifier/suites/serverspec
       Transferring files to <default-ubuntu-1404>
-----> Running serverspec test suite
       /opt/chef/embedded/bin/ruby -I/tmp/verifier/suites/serverspec -I/tmp/verifier/gems/gems/rspec-support-3.3.0/lib:/tmp/verifier/gems/gems/rspec-core-3.3.2/lib /opt/chef/embedded/bin/rspec --pattern /tmp/verifier/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/verifier/suites/serverspec

       myapp::default
         installs apache2
         starts the apache2 service
         enables the apache2 service at startup
         when no attributes are set
          serves just some stuff

       Finished in 0.16236 seconds (files took 0.36505 seconds to load)
       4 examples, 0 failures

       Finished verifying <default-ubuntu-1404> (0m4.60s).
-----> Kitchen is finished. (0m5.08s)
```

### Adding more Platforms and Suites

First, lets add another suite to our `.kitchen.yml`:
```yaml
...
suites:
  - name: default
    run_list:
      - recipe[myapp::default]

  - name: with-content
    run_list:
      - recipe[myapp::default]
    attributes:
      myapp:
        page_content: omg we have suites!
```

We also have to add specific tests for that suite in `test/integration/with-content/serverspec/default_spec.rb`
(note the suite name "with-content" is encoded in that path):
```ruby
require 'spec_helper'

describe 'myapp::default' do
  context 'when the myapp/page_content attribute is set' do
    it 'serves the specified content' do
      expect(command('wget -qO- localhost').stdout).to match('omg we have suites!')
    end
  end
end
```

If we want to run only that suite now, we can do so by specifying a regex that
matches "with-content-ubuntu-1404":
```
$ bundle exec kitchen verify content
-----> Starting Kitchen (v1.8.0)
-----> Creating <with-content-ubuntu-1404>...
       Bringing machine 'default' up with 'docker' provider...

(...snip)

-----> Running serverspec test suite
       /opt/chef/embedded/bin/ruby -I/tmp/verifier/suites/serverspec -I/tmp/verifier/gems/gems/rspec-support-3.3.0/lib:/tmp/verifier/gems/gems/rspec-core-3.3.2/lib /opt/chef/embedded/bin/rspec --pattern /tmp/verifier/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/verifier/suites/serverspec

       myapp::default
         when the myapp/page_content attribute is set
           serves the specified content

       Finished in 0.11231 seconds (files took 0.36913 seconds to load)
       1 example, 0 failures

       Finished verifying <with-content-ubuntu-1404> (0m18.92s).
-----> Kitchen is finished. (0m54.68s)
```

You can see that it only ran the one specific test we defined for that suite,
as I did not want to duplicate the "basic tests" from the default suite here.
These should be extracted into a separate file so they can be included from
all test suites (and that is left as an exercise for the reader ;-))

Finally, we could even add another platform to our `.kitchen.yml`:
```yaml
...
platforms:
  - name: ubuntu-12.04
    driver_config:
      box: tknerr/baseimage-ubuntu-12.04
  - name: ubuntu-14.04
    driver_config:
      box: tknerr/baseimage-ubuntu-14.04
...
```

That now gives us 4 combinations in total:
```
$ bundle exec kitchen list
Instance                  Driver   Provisioner  Verifier  Transport  Last Action
default-ubuntu-1204       Vagrant  ChefZero     Busser    Ssh        <Not Created>
default-ubuntu-1404       Vagrant  ChefZero     Busser    Ssh        <Not Created>
with-content-ubuntu-1204  Vagrant  ChefZero     Busser    Ssh        <Not Created>
with-content-ubuntu-1404  Vagrant  ChefZero     Busser    Ssh        <Not Created>
```

You can also run them in parallel using the `--concurrency` flag:
```
$ bundle exec kitchen test --concurrency=4
...
```

(Caveat: you will run into trouble with parallel testing when vagrant-cachier
is enabled, unless you set the caching to :machine scope instead of :box scope)
