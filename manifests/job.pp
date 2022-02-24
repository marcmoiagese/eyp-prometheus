define prometheus::job(
                        $job_name = $name,
                        $targets  = [],
                        $labels   = {},
                        $order    = '42',
                      ) {
  concat::fragment{ "prometheus.yml: job ${job_name}":
    target  => '/etc/prometheus.yml',
    order   => "01-${order}",
    content => template("${module_name}/prometheus/job.erb"),
  }
}
