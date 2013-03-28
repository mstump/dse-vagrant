Vagrant::Config.run do |config|

  config.ssh.forward_agent = true

  config.vm.define :kafka do |config|
    config.vm.box = "precise64"
    config.vm.network :hostonly, "33.33.33.10"
    config.vm.host_name = "kafka"
    config.vm.forward_port 9092, 9092
    config.ssh.timeout = 300
    config.ssh.max_tries = 300
    config.vm.provision  :puppet do  |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "kafka.pp"
      puppet.module_path  = "puppet/modules"
      puppet.facter = {
        "zookeeper_host" => "33.33.33.20:2181"
      }
    end
  end

  config.vm.define :zookeeper do |config|
    config.vm.box = "precise64"
    config.vm.network :hostonly, "33.33.33.20"
    config.vm.host_name = "zookeeper"
    config.vm.forward_port 2181, 2181
    config.ssh.timeout = 300
    config.ssh.max_tries = 300
    config.vm.provision  :puppet do  |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "zookeeper.pp"
      puppet.module_path  = "puppet/modules"
    end
  end

  config.vm.define :eventstore do |config|
    config.vm.box = "precise64"
    config.vm.network :hostonly, "33.33.33.30"
    config.vm.host_name = "eventstore"
    config.vm.forward_port 2113, 2113
    config.ssh.timeout = 300
    config.ssh.max_tries = 300
    config.vm.provision  :puppet do  |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "eventstore.pp"
      puppet.module_path  = "puppet/modules"
    end
  end

end
