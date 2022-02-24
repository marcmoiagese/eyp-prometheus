class prometheus(
                            $manage_package         = true,
                            $package_ensure         = 'installed',
                            $manage_service         = true,
                            $manage_docker_service  = true,
                            $service_ensure         = 'running',
                            $service_enable         = true,
                            $srcdir                 = '/usr/local/src',
                            $version                = '2.12.0',
                            $include_prometheus_job = true,
                            $prometheus_job_targets = [ 'localhost:9090' ],
                            $alertmanagers          = [],
                            $alert_rules            = [ '/etc/prometheus/rules.d/*.rules' ],
                            $scrape_interval        = '15s',
                            $evaluation_interval    = '15s',
                            $scrape_timeout         = '10s',
                          ) inherits prometheus::params{

  class { '::prometheus::install': }
  -> class { '::prometheus::config': }
  ~> class { '::prometheus::service': }
  -> Class['::prometheus']

}
