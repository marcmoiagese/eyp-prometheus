class { 'prometheus::exporter::node': }

class { 'prometheus':
  prometheus_job_targets => [ 'localhost:9090', 'localhost:9100' ]
}
