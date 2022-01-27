# png_benchmarks

Test setup for benchmarking Dashboard PNG performance.

Benchmark comparisons include the number of panels in the dashboard.


## Run with Vagrant

These steps show how to run a test environment based on 8.1.0, but it should work for any version with available snapshots.

1. Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version (is 8.1.0 at the time of this writing).

1. Edit Vagrantfile to configure the memory size and number of CPUs

1. Run `VERSION=8.1.0 vagrant up --provision`, matching the version with the ES snapshot instance.

1. Run `vagrant ssh -c "sudo systemctl start kibana"`

1. Run `vagrant ssh -c "/vagrant/metricbeat/metricbeat.sh"` to start Metricbeat within the vagrant machine.
   - To watch the Metricbeat logs: `vagrant ssh -c "docker logs -f metricbeat"`

1. Run `./setup/setup_kibana.sh` to install the test saved objects and datasets.

1. Run `./tests/run_tests.sh` to send a batch of report jobs to Kibana.

1. View Reporting performance results using the .kibana-event-log index pattern in the default space.
