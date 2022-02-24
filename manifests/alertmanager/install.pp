class prometheus::alertmanager::install inherits prometheus::alertmanager {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  user { 'alertmanager':
    ensure     => 'present',
    home       => "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}",
    shell      => '/bin/false',
    managehome => false,
    system     => true,
  }

  if($prometheus::alertmanager::manage_package)
  {
    exec { 'alertmanager mkdir srcdir':
      command => "mkdir -p ${prometheus::alertmanager::srcdir}",
      creates => $prometheus::alertmanager::srcdir,
    }

    # https://github.com/prometheus/alertmanager/releases/download/v0.18.1/alertmanager-0.18.1.linux-${prometheus::params::arch}.tar.gz
    exec { 'wget alertmanager':
      command => "wget https://github.com/prometheus/alertmanager/releases/download/v${prometheus::alertmanager::version}/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}.tar.gz -O ${prometheus::alertmanager::srcdir}/alertmanager-${prometheus::alertmanager::version}.tgz",
      creates => "${prometheus::alertmanager::srcdir}/alertmanager-${prometheus::alertmanager::version}.tgz",
      require => Exec['alertmanager mkdir srcdir'],
    }

    exec { 'extract alertmanager':
      command => "tar xf ${prometheus::alertmanager::srcdir}/alertmanager-${prometheus::alertmanager::version}.tgz -C /opt",
      creates => "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}/alertmanager",
      require => Exec['wget alertmanager'],
    }
  }

  file { '/opt/alertmanager':
    ensure  => 'link',
    target  => "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}",
    require => [ Exec['extract alertmanager'], User['alertmanager']],
  }

  file { "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}":
    ensure  => 'directory',
    owner   => 'alertmanager',
    group   => 'alertmanager',
    mode    => '0755',
    recurse => true,
    require => [ Exec['extract alertmanager'], User['alertmanager']],
  }

  file { $typoprometheus::alertmanager::storage_path:
    ensure  => 'directory',
    owner   => 'alertmanager',
    group   => 'alertmanager',
    mode    => '0755',
    require => User['alertmanager'],
  }

  file { "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}/alertmanager":
    ensure  => 'present',
    owner   => 'alertmanager',
    group   => 'alertmanager',
    mode    => '0755',
    require => [ Exec['extract alertmanager'], User['alertmanager']],
  }

}
