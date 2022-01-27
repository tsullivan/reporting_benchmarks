# png_benchmarks


Test setup for benchmarking Dashboard PNG performance.

Benchmark comparisons include the number of panels in the dashboard.


## Run with Vagrant
1. Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version.
1. Edit Vagrantfile to configure the memory size and number of CPUs
1. Run `VERSION=8.1.0 vagrant up --provision`, matching the version with the ES snapshot instance.
1. Run `vagrant ssh -c "/home/vagrant/setup.sh"`
1. Run `vagrant ssh` and start Kibana interactively in the vagrant machine. You can browse to it from the host at http://localhost:5777
   - `cd kibana-8.1.0-SNAPSHOT`
   - `./bin/kibana`
   - Run `vagrant ssh -c "tail -f kibana-8.1.0-SNAPSHOT/logs/kibana.log"` to watch the Kibana logs
1. Run `vagrant ssh -c "/vagrant/metricbeat/metricbeat.sh"` to start Metricbeat within the vagrant machine.
   - Run `vagrant ssh -c "docker logs -f metricbeat"` to watch the Metricbeat logs
1. Run `./setup/setup_kibana.sh` in this repo to install the test saved objects and datasets
1. Run the test scripts to send report jobs to Kibana.
1. View Reporting performance results using event log data
