class prometheus::service inherits prometheus {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $prometheus::manage_docker_service)
  {
    if($prometheus::manage_service)
    {

      # config check:
      # ./promtool check config prometheus.yml

      service { $prometheus::params::service_name:
        ensure => $prometheus::service_ensure,
        enable => $prometheus::service_enable,
      }
    }
  }
}
