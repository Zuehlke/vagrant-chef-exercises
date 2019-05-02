## Vagrant with Windows

If you are keen enough to download a 6GB basebox, you can download one of Stefan Scherer's Windows eval builds here:

 * https://app.vagrantup.com/StefanScherer

### Basic Usage

Start with creating a `Vagrantfile`:
```
$ vagrant init StefanScherer/windows_10 --minimal
```

You can interact with the Windows boxes as usual.


### PowerShell Provisioning

The shell provisioner uses PowerShell, and for sure you can write inline scripts as well:
```ruby
Vagrant.configure("2") do |config|
  
  config.vm.box = "StefanScherer/windows_10"

  # add inline powershell script
  config.vm.provision "shell", inline: <<~EOF
    Write-Host 'Hello world from inline powershell script!'
  EOF
end
```

If you reference them as scripts, they can be either .bat or .ps1 files:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "StefanScherer/windows_10"

  # add a simple .bat and .ps1 file
  config.vm.provision "shell", path: "helloworld.bat"
  config.vm.provision "shell", path: "helloworld.ps1"
end
```

### Run Remote Commands via WinRM

You might be tempted to run `vagrant ssh` at some point in time, however this will likely not work with Windows boxes.

Instead you can run `vagrant winrm` which establishes a winrm connection and drops you into a remote PowerShell session:
```
$ vagrant winrm
```

### Log in via RDP

Even though you can access the VMs from the VirtualBox GUI, you can also log in via RDP. This is useful if the Windows VM does not run on a local hypervisor and is only accessible remotely.

Simply run:
```
$ vagrant rdp
```