
## Vagrant with Shell Provisioner

### Basic Usage

Create a Vagrantfile:
```
$ vagrant init ubuntu/bionic64 --minimal
```

Add an inline shell provisioner:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell", inline: "echo hello infracoders!"
end
```

The provisioners will run at the first `vagrant up`. Once the VM is up and running, you trigger the provisioners like that:
```
$ vagrant provision
```

Or, if want them to trigger on a subsequent `vagrant up` too:
```
$ vagrant up --provision
```

### Using Heredocs

Use [heredocs](https://infinum.co/the-capsized-eight/multiline-strings-ruby-2-3-0-the-squiggly-heredoc) for more multiline scripts:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell", inline: <<~EOF
    echo "I am $(whoami) in $(pwd)"
    echo "this is running on: $(cat /etc/lsb-release)"

    # let's say hello to Chuck
    echo "Hello, Chuck Norris" > /tmp/hello.txt
    cat /tmp/hello.txt
  EOF
end
```

### Using Script Files

But you can also use a script file (e.g. `say_hello.sh`):
```bash
#!/bin/bash
echo "hello $1"
```

...and in your `Vagrantfile`:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell", path: "say_hello.sh", args: "infracoders!"
end
```
