class prometheus::config inherits prometheus {

  systemd::service { $prometheus::params::service_name:
    description   => 'Prometheus Server',
    documentation => 'https://prometheus.io/docs/introduction/overview/',
    after_units   => [ 'network-online.target' ],
    user          => 'prometheus',
    restart       => 'on-failure',
    execstart     => "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}/prometheus --config.file=/etc/prometheus.yml --storage.tsdb.path=/opt/prometheus-data",
  }

  concat { '/etc/prometheus.yml':
    ensure => 'present',
    owner  => 'prometheus',
    group  => 'prometheus',
    mode   => '0644',
  }

  concat::fragment{ 'prometheus.yml header':
    target  => '/etc/prometheus.yml',
    order   => '00',
    content => template("${module_name}/prometheus/prometheusyml.erb"),
  }

  # només per facilitat
  file { "/opt/prometheus-${prometheus::version}.linux-${prometheus::params::arch}/prometheus.yml":
    ensure  => 'link',
    target  => '/etc/prometheus.yml',
    require => Concat['/etc/prometheus.yml'],
  }

}
