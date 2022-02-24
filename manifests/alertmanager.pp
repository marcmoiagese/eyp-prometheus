# --config.file="alertmanager.yml"
#                            Alertmanager configuration file name.
# --storage.path="data/"     Base path for data storage.
# --data.retention=120h      How long to keep data for.
class prometheus::alertmanager(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'running',
                            $service_enable        = true,
                            $srcdir                = '/usr/local/src',
                            $version               = '0.18.0',
                            $data_retention        = '120h',
                            $storage_path          = '/opt/alertmanager-data',
                            $smtp_smarthost        = 'localhost:587',
                            $smtp_from             = "AlertManager <alertmanager@${::fqdn}>",
                            $smtp_require_tls      = true,
                            $smtp_hello            = $::fqdn,
                            $smtp_auth_username    = undef,
                            $smtp_auth_password    = undef,
                          ) inherits prometheus::params{

  class { '::prometheus::alertmanager::install': }
  -> class { '::prometheus::alertmanager::config': }
  ~> class { '::prometheus::alertmanager::service': }
  -> Class['::prometheus::alertmanager']

}
