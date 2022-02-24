class prometheus::install inherits prometheus {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  user { 'prometheus':
    ensure     => 'present',
    home       => "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}",
    shell      => '/bin/false',
    managehome => false,
    system     => true,
  }

  if($prometheus::manage_package)
  {
    exec { 'prometheus mkdir srcdir':
      command => "mkdir -p ${prometheus::srcdir}",
      creates => $prometheus::srcdir,
    }

    exec { 'wget prometheus':
      command => "wget https://github.com/prometheus/prometheus/releases/download/v${prometheus::version}/prometheus-${prometheus::version}.linux-${prometheus::params::arch}.tar.gz -O ${prometheus::srcdir}/prometheus-${prometheus::version}.tgz",
      creates => "${prometheus::srcdir}/prometheus-${prometheus::version}.tgz",
      require => Exec['prometheus mkdir srcdir'],
    }

    exec { 'extract prometheus':
      command => "tar xf ${prometheus::srcdir}/prometheus-${prometheus::version}.tgz -C /opt",
      creates => "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}/prometheus",
      require => Exec['wget prometheus'],
    }
  }

  file { '/opt/prometheus':
    ensure  => 'link',
    target  => "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}",
    require => [ Exec['extract prometheus'], User['prometheus']],
  }

  file { "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}":
    ensure  => 'directory',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0755',
    recurse => true,
    require => [ Exec['extract prometheus'], User['prometheus']],
  }

  file { "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}/prometheus":
    ensure  => 'present',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0755',
    require => [ Exec['extract prometheus'], User['prometheus']],
  }

  file { '/opt/prometheus-data':
    ensure  => 'directory',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0755',
    require => User['prometheus'],
  }

  file { '/etc/prometheus':
    ensure  => 'directory',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0755',
    require => User['prometheus'],
  }

  file { '/etc/prometheus/rules.d':
    ensure  => 'directory',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0755',
    require => File['/etc/prometheus'],
  }

}
