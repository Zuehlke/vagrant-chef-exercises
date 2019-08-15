
## Vagrant Basics

Covering the essential Vagrant basics. You can find more documentation here:

 * https://www.vagrantup.com/docs/

### Goals

 * [ ] find the vagrant docs
 * [ ] get familiar with the vagrant CLI
 * [ ] know where to find baseboxes
 * [ ] understand the value of `Vagrantfile`

### Some commands to exercise

Creating a Vagrantfile:
```
$ vagrant init ubuntu/bionic64 --minimal
```

Interacting with the Vagrant VM:
```
$ vagrant up
$ vagrant ssh
$ vagrant ssh -c "cat /etc/lsb-release"
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
  config.vm.box = "ubuntu/bionic64"
end
```

Setting name, CPU & memory for Virtualbox provider:
```ruby
Vagrant.configure(2) do |config|

  # name of the basebox to be used
  config.vm.box = "ubuntu/bionic64"

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
$ vagrant box add ubuntu/bionic64 --provider=virtualbox
```

You can find baseboxes here:

 * https://app.vagrantup.com/boxes/search


### Synced Folders

The current directory where the `Vagrantfile` resides is always shared as `/vagrant` within the VM.

If you want to turn that off:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
```

Or, if you want to add an additional synced folder:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.synced_folder "/some/path/on/host/", "/var/www/"
end
```

### Snapshots

You can easily take and restore VM snapshots via vagrant (given the underlying provider supports it):
```
$ vagrant snapshot save "initial-state"
$ vagrant snapshot list
```

Let's assume you just borked the VM and want to restore to the earlier state:
```
$ vagrant snapshot restore "initial-state"
```

Once you no longer need that snapshot, you can also delete it:
```
$ vagrant snapshot delete "initial-state"
```
