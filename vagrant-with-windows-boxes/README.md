## Vagrant with Windows

If you are keen enough to download a 6GB basebox, you can download one of Stefan Scherer's Windows eval builds here:

 * https://app.vagrantup.com/StefanScherer

### Basic Usage

Start with creating a `Vagrantfile`:
```
$ vagrant init StefanScherer/windows_10 --minimal
```

You can interact with the Windows boxes as usual.

### GUI Mode

Many Windows Baseboxes start without a GUI. So you can either got to the VirtualBox GUI, select the VM, and hit the "-> Show" button, or you can enable GUI mode directly in the `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
  
  config.vm.box = "StefanScherer/windows_10"

  # enable the GUI
  config.vm.provider "virtualbox" do |vbox|
    vbox.gui = true
  end
end
```

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

### Run Remote Commands via WinRM / PowerShell

You might be tempted to run `vagrant ssh` at some point in time, however this will likely not work with Windows boxes.

If you want to drop into a remote *interactive* PowerShell session, you can do so (currently on Windows hosts only) via:
```
$ vagrant powershell
```

If you want to run one-off PowerShell or CMD command, you can use `vagrant winrm` to establish a winrm connection and run the supplied command (this works from Linux hosts, too):
```
$ vagrant winrm -c "Write-Host 'hello from remote powershell'" -s powershell
$ vagrant winrm -c "@echo hello from remote cmd" -s cmd
```

### Log in via RDP

Even though you can access the VMs from the VirtualBox GUI, you can also log in via RDP. This is useful if the Windows VM does not run on a local hypervisor and is only accessible remotely.

Simply run:
```
$ vagrant rdp
```