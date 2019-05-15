
## Chef Basics: Intro to Cookbooks

In Chef, cookbooks are the reusable pieces grouping together recipes, attributes,
templates and files.

### A very minimal Helloworld Cookbook

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

And an actual recipe in `cookbooks/hello/recipes/default.rb` which simply logs something:
```ruby
log "Hello Chefs!"
```

To learn something new, let's right away add `cookbooks/hello/attributes/default.rb` which
allows us to parameterize the cookbook later on:
```ruby
node.default['hello']['name'] = 'you'
```

In `recipes/default.rb` you can then access it like that:
```ruby
log "Hello #{node['hello']['name']}!"
```

*Note that cookbooks must reside in a "cookbooks" directory so that all the chef commands work without
additional configuration changes*.

### Running the Helloworld Cookbook with Chef Zero locally

To apply the cookbook that we just created to your local machine you need
run `chef-client` with `-z` option (short for `--local-mode`) and provide it
with an `--override-runlist` (or `-o` in short):
```
$ chef-client -z -o hello
```

As expected, you should see that the cookbook is being uploaded ("synchronized") to Chef zero
and you the log resource prints the log statement during convergence:
```
$ chef-client -z -o hello
[2019-05-14T19:46:16+02:00] WARN: No config file found or specified on command line, using command line options.
Starting Chef Client, version 14.12.3
[2019-05-14T19:46:19+02:00] WARN: Run List override has been provided.
[2019-05-14T19:46:19+02:00] WARN: Original Run List: []
[2019-05-14T19:46:19+02:00] WARN: Overridden Run List: [recipe[hello]]
resolving cookbooks for run list: ["hello"]
Synchronizing Cookbooks:
  - hello (0.1.0)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 1 resources
Recipe: hello::default
  * log[Hello you!] action write
  
[2019-05-14T19:46:19+02:00] WARN: Skipping final node save because override_runlist was given

Running handlers:
Running handlers complete
Chef Client finished, 1/1 resources updated in 02 seconds
```

### Running the Helloworld Cookbook via Chef Zero Provisioner in a Vagrant VM

In order to run the same cookbook in a Vagrant VM, you can simply use the "chef_zero"
provisioner and add the "hello::default" recipe to the runlist:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "tknerr/baseimage-ubuntu-18.04"
  config.vm.provision "chef_zero" do |chef|
    chef.version = "14.12.3"
    chef.installer_download_path = "/tmp/vagrant-cache/"
    chef.nodes_path = "."
    chef.add_recipe "hello::default"
  end
end
```

Now running `vagrant up`, you should see output similar to this:
```
$ vagrant up --provider docker
Bringing machine 'default' up with 'docker' provider...
==> default: Auto-generating node name for Chef...
==> default: Creating the container...
    default:   Name: chef-basics-intro-to-cookbooks_default_1557860143
    default:  Image: tknerr/baseimage-ubuntu:18.04
    default: Volume: /home/user/vagrant-chef-exercises/chef-basics-intro-to-cookbooks:/vagrant
    default: Volume: /home/user/.vagrant.d/cache/tknerr/baseimage-ubuntu-18.04:/tmp/vagrant-cache
    default: Volume: /home/user/vagrant-chef-exercises/chef-basics-intro-to-cookbooks/cookbooks:/tmp/vagrant-chef/ed6eeb903057d777f24710fe17699656/cookbooks
    default: Volume: /home/user/vagrant-chef-exercises/chef-basics-intro-to-cookbooks/nodes:/tmp/vagrant-chef/5983ca51ee885cedbb77b4efeb37bc9c/nodes
    default:   Port: 127.0.0.1:2222:22
    default:  
    default: Container created: bb5f1699d784a628
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
==> default: Running provisioner: chef_zero...
    default: Installing Chef (14.12.3)...
==> default: Generating chef JSON and uploading...
==> default: Running chef-client (local-mode)...
==> default: [2019-05-14T18:56:19+00:00] INFO: Started chef-zero at chefzero://localhost:1 with repository at /tmp/vagrant-chef/ed6eeb903057d777f24710fe17699656, /tmp/vagrant-chef
==> default:   One version per cookbook
==> default:   nodes at /tmp/vagrant-chef/5983ca51ee885cedbb77b4efeb37bc9c/nodes
==> default: Starting Chef Client, version 14.12.3
==> default: [2019-05-14T18:56:19+00:00] INFO: *** Chef 14.12.3 ***
==> default: [2019-05-14T18:56:19+00:00] INFO: Platform: x86_64-linux
==> default: [2019-05-14T18:56:19+00:00] INFO: Chef-client pid: 809
==> default: [2019-05-14T18:56:19+00:00] INFO: The plugin path /etc/chef/ohai/plugins does not exist. Skipping...
==> default: [2019-05-14T18:56:20+00:00] WARN: Plugin Network: unable to detect ipaddress
==> default: [2019-05-14T18:56:20+00:00] INFO: Setting the run_list to ["recipe[hello::default]"] from CLI options
==> default: [2019-05-14T18:56:20+00:00] INFO: Run List is [recipe[hello::default]]
==> default: [2019-05-14T18:56:20+00:00] INFO: Run List expands to [hello::default]
==> default: [2019-05-14T18:56:20+00:00] INFO: Starting Chef Run for vagrant-cebb9d45
==> default: [2019-05-14T18:56:20+00:00] INFO: Running start handlers
==> default: [2019-05-14T18:56:20+00:00] INFO: Start handlers complete.
==> default: resolving cookbooks for run list: ["hello::default"]
==> default: [2019-05-14T18:56:20+00:00] INFO: Loading cookbooks [hello@0.1.0]
==> default: Synchronizing Cookbooks:
==> default:   - hello (0.1.0)
==> default: Installing Cookbook Gems:
==> default: Compiling Cookbooks...
==> default: Converging 1 resources
==> default: Recipe: hello::default
==> default:   
==> default: * log[Hello you!] action write
==> default: [2019-05-14T18:56:20+00:00] INFO: Hello you!
==> default: 
==> default:   
==> default: 
==> default: [2019-05-14T18:56:20+00:00] INFO: Chef Run complete in 0.043384193 seconds
==> default: 
==> default: Running handlers:
==> default: [2019-05-14T18:56:20+00:00] INFO: Running report handlers
==> default: Running handlers complete
==> default: 
==> default: [2019-05-14T18:56:20+00:00] INFO: Report handlers complete
==> default: Chef Client finished, 1/1 resources updated in 01 seconds
==> default: Configuring cache buckets...
```
