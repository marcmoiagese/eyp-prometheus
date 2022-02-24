class prometheus::exporter::node::service inherits prometheus::exporter::node {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $prometheus::exporter::node::manage_docker_service)
  {
    if($prometheus::exporter::node::manage_service)
    {
      service { $prometheus::params::node_exporter_service_name:
        ensure => $prometheus::exporter::node::service_ensure,
        enable => $prometheus::exporter::node::service_enable,
      }
    }
  }
}
