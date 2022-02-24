class prometheus::alertmanager::service inherits prometheus::alertmanager {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $prometheus::alertmanager::manage_docker_service)
  {
    if($prometheus::alertmanager::manage_service)
    {
      service { $prometheus::params::alertmanger_service_name:
        ensure => $prometheus::alertmanager::service_ensure,
        enable => $prometheus::alertmanager::service_enable,
      }
    }
  }
}
