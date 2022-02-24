require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'prometheus class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'prometheus::exporter::node': }

      class { 'prometheus':
        prometheus_job_targets => [ 'localhost:9090', 'localhost:9100' ]
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

  end
end
