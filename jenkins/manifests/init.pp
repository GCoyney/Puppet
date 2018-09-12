class jenkins {
  $packages = ['java', 'wget', 'jenkins']

  exec { 'get_repo':
    command => 'wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo',
    path => '/usr/local/bin/:/bin/',
  }
  exec { 'import_rpm':
    command => 'rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
    path => '/usr/local/bin/:/bin/',
  }
  package { $packages:
    ensure => installed,
  }

  service { 'jenkins':
    ensure => 'running',
    enable => true
  }

}


