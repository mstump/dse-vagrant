include stdlib
include apt

apt::source { "kissmetrics":
  location          => "https://s3.amazonaws.com/km-ubuntu-repo/repo",
  release           => "wheezy",
  repos             => "main",
  key               => "521144BD",
  key_source        => "https://s3.amazonaws.com/km-ubuntu-repo/repo/conf/521144BD.gpg.key",
  include_src       => false
}

exec { "apt-get update --fix-missing":
  path => "/usr/bin",
}

package { "python-software-properties":
  ensure  => present,
  require => Exec["apt-get update --fix-missing"],
}

apt::ppa { 'ppa:webupd8team/java':
  require => Package["python-software-properties"],
}

exec { "apt-get update":
  path => "/usr/bin",
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
  path => "/usr/sbin",
  require => Package["oracle-java6-installer"],
}

package { "zookeeper":
  ensure  => present,
  require => Exec["apt-get update"],
}

package { "zookeeper-bin":
  ensure  => present,
  require => Exec["apt-get update"],
}

package { "zookeeperd":
  ensure  => present,
  require => Exec["apt-get update"],
}

service { "zookeeper":
  enable => true,
  require => Package["zookeeperd"],
}
