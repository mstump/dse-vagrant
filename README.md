backend-dev-env
===============

The canonical enviroment for back-end development. We use [Puppet] [1] for provisioning, and [Vagrant](http://www.vagrantup.com/) for orchastrating the virtual enviroment.

## Usage

1. Clone this git repo, and cd to the directory.
1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Download and install [Vagrant](http://downloads.vagrantup.com/)
1. Install the virtual machine image
```
vagrant box add precise64 http://files.vagrantup.com/precise64.box
```
1. Launch the cluster
```
vagrant up
```

### SSH to a Machine
```
vagrant ssh <machine_name>
```
Consult the current [Vagrantfile](./Vagrantfile) and look for the ```host_name``` attributes for the names to use in the above ```machine_name```.

Or, you can run something like: 

```
vagrant status
```

...and you'll be a listing of the current machines within the Vagrant cluster

```
Current machine states:

kafka                    running (virtualbox)
zookeeper                running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

### Shutdown the cluster
```
vagrant destroy
```

### Re-provision the cluster
```
vagrant provision
```

## Available Machine Images

* zookeeper - A single node zookeeper instance. Zookeeper port forwarded to ```localhost:2181```.
* kafka - A single node kafka instance. Kafka port forwarded to ```localhost:9092```. Requires a running instance of the zookeeper image.

[1]: https://puppetlabs.com/resources/overview-2/ (note: you don't have to install Puppet to use this Vagrant setup)
