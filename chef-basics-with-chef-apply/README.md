
## Chef Basics: Chef Apply

Chef Apply is the easiest and most minimal way to get started with the Chef DSL.
It essentially applies single recipe (no cookbooks or whatsoever) to your local machine.

### Goals

* [ ] create and apply your first chef recipe locally
* [ ] understand how Chef is idempotent
* [ ] know the documentation for Chef resources
* [ ] use the chef_apply provisioner in a `Vagrantfile`

### Playing around with Chef Apply locally

We will start with exploring some of the builtin Chef resources from here:

 * https://docs.chef.io/resources.html

Let's create our first Chef recipe (let's call it `recipe.rb`) that installs something
utterly useful like cowsay:
```ruby
package "cowsay" do
  action :install
end
```

Now run `chef-apply` to apply that recipe to your current system:
```
$ sudo chef-apply recipe.rb --color
```

You should see that is actually installs the package in the output:
```
$ sudo chef-apply recipe.rb --color
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * apt_package[cowsay] action install
    - install version 3.03+dfsg2-4 of package cowsay
```

Once you run it again, you will notice how idempotence comes into play
(it's already "up to date"):
```
$ sudo chef-apply recipe.rb --color
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * apt_package[cowsay] action install (up to date)
```

Not to forget, we can now actually cowsay things ;-)
```
$ cowsay hello
 _______
< hello >
 -------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Let's add some more resources to play around with:
```ruby
package "cowsay" do
  action :install
end

service "ufw" do
  action :start
end

file "/tmp/some-file" do
  content <<~EOF
    some content
  EOF
  mode "0644"
end
```

Feel free to play with the resources in the recipe, run `chef-apply` again,
and watch the effects.


### Using Chef Apply with Vagrant VMs

Now let's use the "chef_apply" provisioner so we can safely play in a Vagrant VM:

* https://www.vagrantup.com/docs/provisioning/chef_apply.html


The most basic example for Vagrant / Chef integration is via the "chef_apply" provisioner,
which lets you define an inline Chef recipe:
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

Note that you can control the Chef version installed in the Vagrant VM as well.
Also, in case you are using [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier),
you should configure the download path so that it ends up being cached:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "tknerr/baseimage-ubuntu-18.04"
  config.vm.provision "chef_apply" do |chef|
    chef.version = "14.12.3"
    chef.installer_download_path = "/tmp/vagrant-cache/"
    chef.recipe = <<~RECIPE
      # ...your recipe goes here
    RECIPE
  end
end
```

### Setting up an Apache Webserver via Chef Apply

To make the above example more complete, lets add a port-forwarding and ensure that the apache2 service is actually running:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "tknerr/baseimage-ubuntu-18.04"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision "chef_apply" do |chef|
    chef.version = "14.12.3"
    chef.installer_download_path = "/tmp/vagrant-cache/"
    chef.recipe = <<~RECIPE
      package "apache2" do
        action :install
      end

      service "apache2" do
        action [:enable, :start]
      end

      file "/var/www/html/index.html" do
        content "hello world!"
      end

      log "open your browser at http://localhost:8080 to see it running"
    RECIPE
  end
end
```

Finally, we can open our browser again and see apache webserver running on http://localhost:8080
