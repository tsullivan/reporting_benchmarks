# Reporting performance test environment setup

Test setup for benchmarking Dashboard PNG performance.

Benchmark comparisons include the number of panels in the dashboard.


## Run with Vagrant

These steps show how to run a test environment based on 8.1.0, but it should work for any version with available snapshots.

1. Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version (is 8.1.0 at the time of this writing).

1. Edit Vagrantfile to configure the memory size and number of CPUs

1. Run `VERSION=8.1.0 vagrant up --provision`, matching the version with the ES snapshot instance.

1. Run `vagrant ssh -c "/home/vagrant/setup.sh"`

1. Run `vagrant ssh` and start Kibana interactively in the vagrant machine.
   - In vagrant machine, run:
     ```
     cd kibana-8.1.0-SNAPSHOT
     ./bin/kibana
     ```
   - You can browse to Kibana from the host at http://localhost:5777
   - To watch the Kibana logs: `vagrant ssh -c "tail -f kibana-8.1.0-SNAPSHOT/logs/kibana.log"`

1. Run `vagrant ssh -c "/vagrant/metricbeat/metricbeat.sh"` to start Metricbeat within the vagrant machine.
   - To watch the Metricbeat logs: `vagrant ssh -c "docker logs -f metricbeat"`

1. Run `./setup/setup_kibana.sh` in this repo to install the test saved objects and datasets

1. Run `./tests/run_tests.sh` to send a batch of report jobs to Kibana.

1. View Reporting performance results using event log data
