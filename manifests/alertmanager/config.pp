# --config.file="alertmanager.yml"
#                            Alertmanager configuration file name.
# --storage.path="data/"     Base path for data storage.
# --data.retention=120h      How long to keep data for.
class prometheus::alertmanager::config inherits prometheus::alertmanager {

  systemd::service { $prometheus::params::alertmanger_service_name:
    description => 'Alert Manager',
    after_units => [ 'network-online.target' ],
    user        => 'alertmanager',
    restart     => 'on-failure',
    execstart   => "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}/alertmanager --config.file=/etc/alertmanager.yml --data.retention=${prometheus::alertmanager::data_retention} --storage.path=${prometheus::alertmanager::storage_path}",
  }

  concat { '/etc/alertmanager.yml':
    ensure => 'present',
    owner  => 'prometheus',
    group  => 'prometheus',
    mode   => '0644',
  }

  concat::fragment{ 'alertmanager.yml base':
    target  => '/etc/alertmanager.yml',
    order   => '00',
    content => template("${module_name}/alertmanager/alertmanageryml.erb"),
  }

  # només per facilitat
  file { "/opt/alertmanager-${prometheus::alertmanager::version}.linux-${prometheus::params::arch}/alertmanager.yml":
    ensure  => 'link',
    target  => '/etc/alertmanager.yml',
    require => Concat['/etc/alertmanager.yml'],
  }

}
