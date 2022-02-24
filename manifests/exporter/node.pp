class prometheus::exporter::node(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'running',
                            $service_enable        = true,
                            $srcdir                = '/usr/local/src',
                            $version               = '0.18.1',
                          ) inherits prometheus::params{

  class { '::prometheus::exporter::node::install': }
  -> class { '::prometheus::exporter::node::config': }
  ~> class { '::prometheus::exporter::node::service': }
  -> Class['::prometheus::exporter::node']

}
