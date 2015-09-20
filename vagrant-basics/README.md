
## Vagrant Basics

You can find the official documentation here:

 * https://docs.vagrantup.com/v2/

Below are just some

### Some commands to exercise

Creating a Vagrantfile:
```
$ vagrant init
$ vagrant init bento/ubuntu-14.04 --minimal
```

Interacting with the Vagrant VM:
```
$ vagrant up
$ vagrant ssh
$ vagrant ssh -c "pwd"
$ vagrant halt
$ vagrant reload
$ vagrant destroy -f
```

Getting help:
```
$ vagrant help
```

Working with plugins:
```
$ vagrant plugin list
$ vagrant plugin install vagrant-cachier --plugin-version 1.2.1
```

Showing global status (of all known VMs):
```
$ vagrant global-status
```

### Vagrantfile Examples

Most simple one:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-14.04"
end
```

Setting name, CPU & memory for Virtualbox provider:
```ruby
Vagrant.configure(2) do |config|

  # name of the basebox to be used
  config.vm.box = "bento/ubuntu-14.04"

  # setting the display name shown in the VirtualBox GUI
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id,
      "--name", "vagrant-basics",
      "--memory", 512,
      "--cpus", 4
    ]
  end
end
```

### Baseboxes

Listing the locally available baseboxes:
```
$ vagrant box list
```

Manually download a basebox (without a Vagrantfile):
```
$ vagrant box add bento/ubuntu-14.04 --provider=virtualbox
```

You can find baseboxes here:

 * https://atlas.hashicorp.com/boxes/search


### Synced Folders

The current directory where the `Vagrantfile` resides is always shared as `/vagrant` within the VM.

If you want to turn that off:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-14.04"
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
```

Or, if you want to add an additional synced folder:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-14.04"
  config.vm.synced_folder "/some/path/on/host/", "/var/www/"
end
```
