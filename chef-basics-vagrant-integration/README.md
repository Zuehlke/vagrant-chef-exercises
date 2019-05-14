
## Chef Basics: Vagrant Integration

When you are playing around with Chef you will most likely want to try that
in a VM as a "clean playground" rather than on your host system.

This is where Vagrant comes into play and provides several ways to run Chef
during the provisioning step. The following Chef provisioners are available: 

 * https://www.vagrantup.com/docs/provisioning/chef_apply.html
 * https://www.vagrantup.com/docs/provisioning/chef_zero.html
 * https://www.vagrantup.com/docs/provisioning/chef_solo.html
 * https://www.vagrantup.com/docs/provisioning/chef_client.html

Also consider the common configuration options for all of the above provisioners:

 * https://www.vagrantup.com/docs/provisioning/chef_common.html

### Chef Apply Provisioner

Chef Apply is the easiest way to get started with Chef and essentially applies a single
Chef recipe (no cookbooks or whatsoever) to the current system.

To run Chef Apply within a Vagrant VM, using an inline Chef recipe using HEREDOC syntax:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "tknerr/baseimage-ubuntu-18.04"
  config.vm.provision "chef_apply" do |chef|
    chef.recipe = <<~RECIPE
      package "apache2" do
        action :install
      end
    RECIPE
  end
end
```

If you want to run it with an existing recipe file, remember that the Vagrantfile is Ruby code
and thus you can simply read the file contents:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "tknerr/baseimage-ubuntu-18.04"
  config.vm.provision "chef_apply" do |chef|
    chef.recipe = File.read("/path/to/my/recipe.rb")
  end
end
```

### Chef Zero Provisioner

Chef Zero (a.k.a. local mode) is the recommended way if you have a full cookbook structure
(i.e. including recipes, attributes, templates, files, etc...) that you want to provision,
but no centralized Chef server in your infrastructure. Essentially it spawns a local / in-memory
Chef server during provisioning and thus behaves very similar to a Chef client / server setup.

Assuming you have a cookbook structure already (see also [chef-basics-creating-cookbooks](../chef-basics-creating-cookbooks)),
you can provision the VM using Chef Zero like this:



### Chef Solo Provisioner

Since Chef Solo has been deprecated in favor of Chef Zero, we will not provide
any examples here. Please take a look at the [chef_solo provisioner docs](https://www.vagrantup.com/docs/provisioning/chef_solo.html)
instead if you want to use this nevertheless.

### Chef Client Provisioner

The Chef Client provisioner expects a centralized Chef Server instance which is hosting all the
cookbooks that you need for provisioning. I consider this an advanced setup, as it needs a central
infrastructure component to be hosted (the Chef server) and also complicates the provisionig
process a bit (i.e. the extra step for uploading the cookbook to Chef server).

We won't handle it in the current version of this workshop, but you should be aware that it exists
and in case you need it you will find your way via the [chef_client provisioner docs](https://www.vagrantup.com/docs/provisioning/chef_client.html)