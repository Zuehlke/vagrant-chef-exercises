
## Multi-VM Environments in Vagrant

### Creating Multi-VM Environments

Use a `config.vm.define` block for defining multiple VMs within a single `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-14.04"
  # web server VM
  config.vm.define "web" do |web|
    web.vm.provision "shell", inline: "apt-get install apache2 -y"
  end
  # database VM
  config.vm.define "db" do |db|
    db.vm.provision "shell", inline: "apt-get install postgresql -y"
  end
end
```

You can then interact with the VMs by passing the VM name to the vagrant commands:
```
$ vagrant up web
$ vagrant up db
...
```

If you don't specify a name, it will apply to *all* VMs in the Vagrantfile:
```
$ # oh-oh, this will destroy ALL of the VMs!
$ vagrant destroy -f
...
```

### Networking

You can either do port-forwarding or set up a private host-only network for communicating with the VMs from your host.

Configure port-forwarding like this:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-14.04"
  config.vm.define "web" do |web|
    web.vm.provision "shell", inline: "apt-get install apache2 -y"
    web.vm.vm.network "forwarded_port", guest: 80, host: 8080
  end
end
```

Now you should be able to access your VM like via the forwarded port: http://localhost:8080/

Using host-only networks is similarly easy:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-14.04"
  config.vm.define "web" do |web|
    web.vm.provision "shell", inline: "apt-get install apache2 -y"
    config.vm.network "private_network", ip: "172.16.40.80"
  end
end
```
And you can access the VM now via it's private IP address: http://172.16.40.80/


### A complete Example (LB + Web Server)

The example below shows a multi-vm example with one load balancer and two web server VMs. All VMs are accessible via their dedicated IP address on a private host-only network.

It also adds some "Ruby magic" to reduce code duplication (the Vagrantfile is just plain Ruby code after all).

```ruby
Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-14.04"

  # load balancer VM
  config.vm.define "lb" do |lb_config|
    lb_config.vm.network "private_network", ip: "192.168.40.90"
    lb_config.vm.provision "shell", inline: <<-EOF
      sudo apt-get update
      sudo apt-get install nginx -y
      cat << CONF > /etc/nginx/sites-available/default
upstream backend  {
  server 192.168.40.91;
  server 192.168.40.92;
}
server {
  location / {
    proxy_pass  http://backend;
  }
}
CONF
      sudo service nginx restart
    EOF
  end

  # web server VMs
  (1..2).each do |i|
    config.vm.define "web-#{i}" do |web_config|
      web_config.vm.network "private_network", ip: "192.168.40.9#{i}"
      web_config.vm.provision "shell", inline: <<-EOF
        sudo apt-get update
        sudo apt-get install apache2 -y
        cat << HTML > /var/www/html/index.html
<html>
  <body>Web server #{i}</body>
</html>
HTML
      EOF
    end
  end
end
```

First bring up all the VMs:
```
$ vagrant up
```

Check their status if you want:
```
$ vagrant status
Current machine states:

lb                        running (virtualbox)
web-1                     running (virtualbox)
web-2                     running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

And now you should see the load-balancer on http://192.168.40.90/ dispatching the requests to either web-1 or web-2.
