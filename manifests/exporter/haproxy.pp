class prometheus::exporter::haproxy(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'running',
                            $service_enable        = true,
                            $srcdir                = '/usr/local/src',
                            $version               = '0.10.0',
                            $scrape_uri            = 'http://localhost/;csv',
                            $username              = 'haproxy_exporter',
                          ) inherits prometheus::params{

  class { '::prometheus::exporter::haproxy::install': }
  -> class { '::prometheus::exporter::haproxy::config': }
  ~> class { '::prometheus::exporter::haproxy::service': }
  -> Class['::prometheus::exporter::haproxy']

}
