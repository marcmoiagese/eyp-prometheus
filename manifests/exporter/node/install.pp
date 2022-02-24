class prometheus::exporter::node::install inherits prometheus::exporter::node {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  user { 'node_exporter':
    ensure     => 'present',
    home       => "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}",
    shell      => '/bin/false',
    managehome => false,
    system     => true,
  }

  if($prometheus::exporter::node::manage_package)
  {
    exec { 'node_exporter mkdir srcdir':
      command => "mkdir -p ${prometheus::exporter::node::srcdir}",
      creates => $prometheus::exporter::node::srcdir,
    }

    # https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-${prometheus::params::arch}.tar.gz
    exec { 'wget node_exporter':
      command => "wget https://github.com/prometheus/node_exporter/releases/download/v${prometheus::exporter::node::version}/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}.tar.gz -O ${prometheus::exporter::node::srcdir}/node_exporter-${prometheus::exporter::node::version}.tgz",
      creates => "${prometheus::exporter::node::srcdir}/node_exporter-${prometheus::exporter::node::version}.tgz",
      require => Exec['node_exporter mkdir srcdir'],
    }

    exec { 'extract node_exporter':
      command => "tar xf ${prometheus::exporter::node::srcdir}/node_exporter-${prometheus::exporter::node::version}.tgz -C /opt",
      creates => "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}/node_exporter",
      require => Exec['wget node_exporter'],
    }
  }

  file { '/opt/node_exporter':
    ensure  => 'link',
    target  => "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}",
    require => [ Exec['extract node_exporter'], User['node_exporter']],
  }

  file { "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}":
    ensure  => 'directory',
    owner   => 'node_exporter',
    group   => 'node_exporter',
    mode    => '0755',
    recurse => true,
    require => [ Exec['extract node_exporter'], User['node_exporter']],
  }

  file { "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}/node_exporter":
    ensure  => 'present',
    owner   => 'node_exporter',
    group   => 'node_exporter',
    mode    => '0755',
    require => [ Exec['extract node_exporter'], User['node_exporter']],
  }

}
