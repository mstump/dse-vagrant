include stdlib
include apt

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

apt::source { "kissmetrics":
  location          => "https://s3.amazonaws.com/km-ubuntu-repo/repo",
  release           => "wheezy",
  repos             => "main",
  key               => "521144BD",
  key_source        => "https://s3.amazonaws.com/km-ubuntu-repo/repo/conf/521144BD.gpg.key",
  include_src       => false
}

exec { "apt-get update --fix-missing":
}

package { "python-software-properties":
  ensure  => present,
  require => Exec["apt-get update --fix-missing"],
}

apt::ppa { 'ppa:webupd8team/java':
  require => Package["python-software-properties"],
}

exec { "apt-get update":
  require => Apt::Ppa['ppa:webupd8team/java']
}

exec { "echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections":
  path => "/bin",
  require => Exec["apt-get update"],
}

package { "oracle-java6-installer":
  ensure  => present,
  require => Exec["echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"],
}

exec { "update-java-alternatives -s java-6-oracle":
  require => Package["oracle-java6-installer"],
}


package { "curl":
  ensure  => present,
  require => Exec["apt-get update"],
}

package { "mono-complete":
  ensure  => present,
  require => Package["curl"]
}

package { "duende":
  ensure  => present,
  require => Package["mono-complete"]
}

exec { "create_duende_logger_dir":
  command     => "mkdir -p /etc/maradns/logger",
  require     => Package["duende"]
}

exec { "create_event_store_dir":
  command     => "mkdir -p /opt/eventstore",
  require     => Exec["create_duende_logger_dir"]
}

exec { "install_event_store":
  command     => "curl http://download.geteventstore.com/binaries/eventstore-mono-2.0.0.tgz|tar -xz -C /opt/eventstore",
  require     => Exec["create_event_store_dir"]
}

exec { "start_event_store":
  command     => "duende mono-sgen EventStore.SingleNode.exe --db /tmp/eventstore",
  cwd         => "/opt/eventstore/",
  require     => Exec["install_event_store"]
}
