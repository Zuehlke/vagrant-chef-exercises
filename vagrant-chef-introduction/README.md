
## A Minimal Chef (with Vagrant) Introduction

This is the most minimal example to show the Vagrant / Chef integration and
talk a bit about the Chef DSL and resources.

Using the Chef Solo provisioner:

 * https://docs.vagrantup.com/v2/provisioning/chef_solo.html

List of builtin Chef resources:

 * https://docs.chef.io/resources.html


### Adding a Chef Provisioner

The most minimal thing we have to do is creating cookbook with a single recipe
and add it to the `chef_solo` provisioner.

Let's create the cookbook first:
```
$ mkdir -p cookbooks/hello
```

Then we need a `cookbooks/hello/metadata.rb` file with some information about
our glorious new cookbook:
```ruby
name "hello"
description "says hello, what do you expect?"
version "0.1.0"
```

And an actual recipe in `cookbooks/hello/recipes/default.rb` which does things:
```ruby
log "helloooo #zdays chefs! :-)"
```

Finally, we need to tell Vagrant to provision the VM with that Chef recipe.
The easiest we can do is using the `chef_solo` provisioner:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "tknerr/baseimage-ubuntu-14.04"
  config.omnibus.chef_version = "12.4.1"
  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "hello::default"
  end
end
```

Now running `vagrant up`, you should see output similar to this:
```
tkn@dev-box:~/zdays/zdays2015-demo-repo/playground$ vagrant up
Bringing machine 'default' up with 'docker' provider...
==> default: Creating the container...
    default:   Name: playground_default_1442788756
    default:  Image: tknerr/baseimage-ubuntu:14.04
    default: Volume: /home/tkn/zdays/zdays2015-demo-repo/playground:/vagrant
    default: Volume: /home/tkn/.vagrant.d/cache/tknerr/baseimage-ubuntu-14.04:/tmp/vagrant-cache
    default: Volume: /home/tkn/zdays/zdays2015-demo-repo/playground/cookbooks:/tmp/vagrant-chef/8be40333678d1a0e0c860e6f080e65bd/cookbooks
    default:   Port: 127.0.0.1:2222:22
    default:  
    default: Container created: 95d23b38d9135375
==> default: Starting container...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 172.17.0.14:22
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
==> default: Installing Chef 12.4.0 Omnibus package...
==> default: Downloading Chef 12.4.0 for ubuntu...
==> default: downloading https://www.getchef.com/chef/metadata?v=12.4.0&prerelease=false&nightlies=false&p=ubuntu&pv=14.04&m=x86_64
==> default:   to file /tmp/install.sh.279/metadata.txt
==> default: trying wget...
==> default: url	https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/10.04/x86_64/chef_12.4.0-1_amd64.deb
==> default: md5	630a8752be2cb45c69b7880adb2340f1
==> default: sha256	2d66c27884658f851d43cec850b4951b4d540492be521ae16f6941be80e8b1e6
==> default: downloaded metadata file looks valid...
==> default: /tmp/vagrant-cache/vagrant_omnibus/chef_12.4.0-1_amd64.deb already exists, verifiying checksum...
==> default: Comparing checksum with sha256sum...
==> default: checksum compare succeeded, using existing file!
==> default: Installing Chef 12.4.0
==> default: installing with dpkg...
==> default: Selecting previously unselected package chef.
==> default: (Reading database ... 16007 files and directories currently installed.)
==> default: Preparing to unpack .../chef_12.4.0-1_amd64.deb ...
==> default: Unpacking chef (12.4.0-1) ...
==> default: Setting up chef (12.4.0-1) ...
==> default: Thank you for installing Chef!
==> default: Running provisioner: chef_solo...
==> default: Detected Chef (latest) is already installed
Generating chef JSON and uploading...
==> default: Running chef-solo...
==> default: stdin: is not a tty
==> default: [2015-09-20T22:39:30+00:00] INFO: Forking chef instance to converge...
==> default: Starting Chef Client, version 12.4.0
==> default: [2015-09-20T22:39:30+00:00] INFO: *** Chef 12.4.0 ***
==> default: [2015-09-20T22:39:30+00:00] INFO: Chef-client pid: 421
==> default: [2015-09-20T22:39:31+00:00] INFO: Setting the run_list to ["recipe[hello::default]"] from CLI options
==> default: [2015-09-20T22:39:31+00:00] INFO: Run List is [recipe[hello::default]]
==> default: [2015-09-20T22:39:31+00:00] INFO: Run List expands to [hello::default]
==> default: [2015-09-20T22:39:31+00:00] INFO: Starting Chef Run for 95d23b38d913
==> default: [2015-09-20T22:39:31+00:00] INFO: Running start handlers
==> default: [2015-09-20T22:39:31+00:00] INFO: Start handlers complete.
==> default: Compiling Cookbooks...
==> default: Converging 1 resources
==> default: Recipe: hello::default
==> default:   * log[helloooo #zdays chefs! :-)] action write
==> default: [2015-09-20T22:39:31+00:00] INFO: helloooo #zdays chefs! :-)
==> default:
==> default:
==> default:
==> default: [2015-09-20T22:39:31+00:00] INFO: Chef Run complete in 0.007323181 seconds
==> default: [2015-09-20T22:39:31+00:00] INFO: Skipping removal of unused files from the cache
==> default:
==> default: Running handlers:
==> default: [2015-09-20T22:39:31+00:00] INFO: Running report handlers
==> default: Running handlers complete
==> default: [2015-09-20T22:39:31+00:00] INFO: Report handlers complete
==> default: Chef Client finished, 1/1 resources updated in 0.842539789 seconds
==> default: Configuring cache buckets...
```

### Playing Around with Chef Resources

Now that everything works you can go ahead and play around with some more
Chef resources in `cookbooks/hello/recipes/default.rb`.

For example you might want to install a package:
```ruby
package 'apache2' do
  action :install
end
```

Or make sure a service is started:
```ruby
service 'apache2' do
  action [ :enable, :start ]
end
```

Or create a file somewhere:
```ruby
file '/var/www/html/index.html' do
  content '<html>Zdays rocks!</html>'
  action :create
end
```

Or check out how notfications work when a specific resource is updated:
```ruby
file '/var/www/html/index.html' do
  content '<html>Zdays rocks!</html>'
  action :create
  notifies :restart, "service[apache2]"
end
```

So much for now... but you can go ahead and check out more Chef resources to play with here:

 * https://docs.chef.io/resources.html


### Vagrant Docker Provider Caveats

Some things might not be working as expected with the docker provider:

 * synced folders are not created on `vagrant reload` -- you really have to destroy the VM
 * networking: `private_network` settings are ignored, but `forwarded_port` works as expected
