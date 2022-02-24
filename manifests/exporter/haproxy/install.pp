class prometheus::exporter::haproxy::install inherits prometheus::exporter::haproxy {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if ($prometheus::exporter::haproxy::username=='haproxy_exporter')
  {
    user { 'haproxy_exporter':
      ensure     => 'present',
      home       => "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}",
      shell      => '/bin/false',
      managehome => false,
      system     => true,
      before     => File[ [ '/opt/haproxy_exporter', "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}", "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}/haproxy_exporter" ] ],
    }
  }

  if($prometheus::exporter::haproxy::manage_package)
  {
    exec { 'haproxy_exporter mkdir srcdir':
      command => "mkdir -p ${prometheus::exporter::haproxy::srcdir}",
      creates => $prometheus::exporter::haproxy::srcdir,
    }

    # https://github.com/prometheus/haproxy_exporter/releases/download/v0.18.1/haproxy_exporter-0.18.1.linux-${prometheus::params::arch}.tar.gz
    exec { 'wget haproxy_exporter':
      command => "wget https://github.com/prometheus/haproxy_exporter/releases/download/v${prometheus::exporter::haproxy::version}/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}.tar.gz -O ${prometheus::exporter::haproxy::srcdir}/haproxy_exporter-${prometheus::exporter::haproxy::version}.tgz",
      creates => "${prometheus::exporter::haproxy::srcdir}/haproxy_exporter-${prometheus::exporter::haproxy::version}.tgz",
      require => Exec['haproxy_exporter mkdir srcdir'],
    }

    exec { 'extract haproxy_exporter':
      command => "tar xf ${prometheus::exporter::haproxy::srcdir}/haproxy_exporter-${prometheus::exporter::haproxy::version}.tgz -C /opt",
      creates => "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}/haproxy_exporter",
      require => Exec['wget haproxy_exporter'],
    }
  }

  file { '/opt/haproxy_exporter':
    ensure  => 'link',
    target  => "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}",
    require => Exec['extract haproxy_exporter'],
  }

  file { "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}":
    ensure  => 'directory',
    owner   => $prometheus::exporter::haproxy::username,
    group   => $prometheus::exporter::haproxy::username,
    mode    => '0755',
    recurse => true,
    require => Exec['extract haproxy_exporter'],
  }

  file { "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}/haproxy_exporter":
    ensure  => 'present',
    owner   => $prometheus::exporter::haproxy::username,
    group   => $prometheus::exporter::haproxy::username,
    mode    => '0755',
    require => Exec['extract haproxy_exporter'],
  }

}
