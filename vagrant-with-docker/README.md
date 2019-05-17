## Vagrant with Docker

Testing with "fat" VirtualBox VM can become quite time consuming if you create / destroy VMs frequently.

Thanks to the docker provider we can speed up things quite a bit by using one of the [Vagrant-friendly Docker Base Images](https://github.com/tknerr/vagrant-docker-baseimages).

### CAVEAT: Containers are not VMs

Please not that [containers are not VMs](https://phusion.github.io/baseimage-docker/)! There might be differences in behaviour, e.g. the init process will not start services, etc...

So while docker baseimages don't behave exactly like a VM would do, it is most often a ***good enough approximation*** and gives you fast feedback while developing / testing your automation code.

### Creating your first Vagrant VM with the docker provider

Create a new Vagrantfile, this time using the [`tknerr/baseimage-ubuntu-18.04` basebox](https://github.com/tknerr/vagrant-docker-baseimages):
```
$ vagrant init tknerr/baseimage-ubuntu-18.04 --minimal
```

Now, bring up the VM using the docker provider:
```
$ vagrant up --provider docker
```

(that should have been very very fast compared to virtualbox ;-))

### Docker Commands

You can check the status as usual via `vagrant status`, but you could also take a look directly to what docker says:
```
$ docker ps
```

You will also find the underlying docker image representing the basebox:
```
$ docker images
```

### Known Issues with the Vagrant Docker Provider

Some things might not be working as expected with the docker provider:

 * synced folders are not created on `vagrant reload` -- you really have to destroy the VM
 * networking: `private_network` settings are ignored, but `forwarded_port` works as expected

