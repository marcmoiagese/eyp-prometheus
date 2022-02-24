class prometheus::exporter::haproxy::service inherits prometheus::exporter::haproxy {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $prometheus::exporter::haproxy::manage_docker_service)
  {
    if($prometheus::exporter::haproxy::manage_service)
    {
      service { $prometheus::params::haproxy_exporter_service_name:
        ensure => $prometheus::exporter::haproxy::service_ensure,
        enable => $prometheus::exporter::haproxy::service_enable,
      }
    }
  }
}
