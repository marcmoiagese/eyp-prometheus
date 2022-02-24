class prometheus::exporter::haproxy::config inherits prometheus::exporter::haproxy {

  systemd::service { $prometheus::params::haproxy_exporter_service_name:
    description => 'haproxy Exporter',
    after_units => [ 'network-online.target' ],
    user        => $prometheus::exporter::haproxy::username,
    restart     => 'on-failure',
    execstart   => "/opt/haproxy_exporter-${prometheus::exporter::haproxy::version}.linux-${prometheus::params::arch}/haproxy_exporter --haproxy.scrape-uri=${prometheus::exporter::haproxy::scrape_uri}",
  }

}
