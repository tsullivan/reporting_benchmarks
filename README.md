# png_benchmarks


Test setup for benchmarking Dashboard PNG performance.

Benchmark comparisons include the number of panels in the dashboard.


## Run with Vagrant
1. Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version.
2. Edit Vagrantfile to configure the memory size and number of CPUs
3. Run `VERSION=8.1.0 vagrant up --provision`, matching the version with the ES snapshot instance.
4. Run `vagrant ssh -c "/home/vagrant/setup-kibana.sh"`
5. ((Start Kibana in the vagrant instance))
6. Run `vagrant ssh -c "/home/vagrant/setup-metricbeat.sh"`
7. Run the scripts to send report jobs to Kibana
8. View Reporting performance results in Kibana Event Log
