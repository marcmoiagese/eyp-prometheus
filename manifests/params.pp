class prometheus::params {

  $service_name='prometheus'
  $node_exporter_service_name='node_exporter'
  $haproxy_exporter_service_name='haproxy_exporter'
  $alertmanger_service_name='alertmanager'

  case $::architecture
  {
    'x86_64': { $arch='amd64' }
    'amd64':  { $arch='amd64' }
    'armv7l': { $arch='armv7' }
    default:  { $arch='amd64' }
  }

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^[7-8].*$/:
        {
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[68].*$/:
            {
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^10.*$/:
            {
            }
            default: { fail("Unsupported Debian version! - ${::operatingsystemrelease}")  }
          }
        }
        default: { fail("Unsupported Debian flavour! - ${::operatingsystem}")  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
