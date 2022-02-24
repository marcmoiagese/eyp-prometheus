class prometheus::exporter::node::config inherits prometheus::exporter::node {

  systemd::service { $prometheus::params::node_exporter_service_name:
    description => 'Node Exporter',
    after_units => [ 'network-online.target' ],
    user        => 'node_exporter',
    restart     => 'on-failure',
    execstart   => "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}/node_exporter",
  }

  # file { "/opt/node_exporter-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}/node_exporter.yml":
  #   ensure  => 'present',
  #   owner   => 'prometheus',
  #   group   => 'prometheus',
  #   mode    => '0644',
  #   content => template("${module_name}/prometheus/prometheusyml.erb"),
  # }
  #
  # file { "/etc/prometheus.yml":
  #   ensure  => 'link',
  #   target  => "/opt/prometheus-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}/prometheus.yml",
  #   require => File["/opt/prometheus-${prometheus::exporter::node::version}.linux-${prometheus::params::arch}/prometheus.yml"],
  # }

}
