class default_install {
  $packages = $::operatingsystem ? {
    'CentOS' => ['git', 'maven'],
    'Ubuntu' => ['git', 'maven'],
  }
  package { $packages:
    ensure => installed,
  }
 }

class ntp (Array[String] $servers, Boolean $service_enable, Enum['running', 'stopped'] $service_ensure,) {
  package { 'ntp':
    ensure => 'installed',
  }
}

class jenkins {
  $packages = ['java', 'wget']
    package { $packages:
      ensure => installed,
    }
    exec { 'get_repo':
      command => 'wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo',
      path => '/usr/local/bin/:/bin/',
    }
    exec { 'import_rpm':
      command => 'rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
      path => '/usr/local/bin/:/bin/',
    }
    package { 'jenkins':
      ensure => installed,
    }

    service { 'jenkins':
      ensure => 'running',
      enable => true
    }
}

node 'jhagent.puppet' {

  file { '/puppetfile.txt':
    ensure => 'present',
    content => "This was created by the Puppet Master! \n",
  }

  package { 'tree':
    ensure => 'installed',
  }

  class { 'default_install': }

#NTP stuff doesn't work. Install does but settings don't

  class { 'ntp':
    servers => ['0.uk.pool.ntp.org, '1.uk.pool.ntp.org'],
    service_enable => true,
    service_ensure => 'running',
  }

  class { 'jenkins': }
}

