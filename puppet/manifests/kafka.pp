include stdlib
include apt

apt::source { "kissmetrics":
  location    => "https://s3.amazonaws.com/km-ubuntu-repo/repo",
  release     => "wheezy",
  repos       => "main",
  key         => "521144BD",
  key_source  => "https://s3.amazonaws.com/km-ubuntu-repo/repo/conf/521144BD.gpg.key",
  include_src => false
}

exec { "apt-get update --fix-missing":
  path        => "/usr/bin",
}

package { "python-software-properties":
  ensure      => present,
  require     => Exec["apt-get update --fix-missing"],
}

apt::ppa { 'ppa:webupd8team/java':
  require     => Package["python-software-properties"],
}

exec { "apt-get update":
  path        => "/usr/bin",
  require     => Apt::Ppa['ppa:webupd8team/java']
}

exec { "accept_oracle_license":
  command     => "echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections",
  path        => "/bin",
  require     => Exec["apt-get update"],
}

package { "oracle-java6-installer":
  ensure      => present,
  require     => Exec["accept_oracle_license"],
}

exec { "enable_oracle_java":
  command     => "update-java-alternatives -s java-6-oracle",
  path        => "/usr/sbin",
  require     => Package["oracle-java6-installer"],
}

package { "kafka":
  ensure      => present,
  require     => Exec["enable_oracle_java"],
}

exec { "set_zookeeper_host":
  path        => "/bin",
  command     => "sed -i 's/^zk.connect/#zk.connect/g' /opt/kafka/config/server.properties; echo \"zk.connect=$zookeeper_host\" >> /opt/kafka/config/server.properties",
  unless      => "grep -Fxq '^zk.connect=$zookeeper_host' /opt/kafka/config/server.properties",
  require     => Package["kafka"],
}

service { "kafka":
  ensure      => running,
  provider    => 'upstart',
  require     => Exec["set_zookeeper_host"],
}
