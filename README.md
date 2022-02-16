# Reporting performance test environment setup

This code is used to create benchmark datasets for Kibana Reporting purposes.

Requirements: Vagrant, command line

## Run with Vagrant

These steps show how to run a test environment based on 8.2.0, but it should work for any version with available snapshots.

## Run Elasticsearch
Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version (is 8.2.0 at the time of this writing).

## Download and Start Kibana
- Edit the Vagrantfile to configure the memory size and number of CPUs.
- Run `VERSION=8.2.0 vagrant up --provision`, matching the version with the ES snapshot instance.

Simply bringing the machine up and provisioning does the following:

 - Downloads and installs the latest snapshot of Kibana, Filebeat, and Metricbeat
 - Starts Kibana and the other Stack processes in the machine
 - Runs Filebeat to stream JSON-formatted logs from /var/log/kibana.log to Elasticsearch
 - Runs Metricbeat to stream the machine stats to ES

## Set up the cluster for testing
Run `./setup/setup_kibana.sh` to store sample data and saved objects used for testing.

 - Sets the cluster's license to Trial.
 - Installs sample data for testing reports, and a dashboard for monitoring reports.

## Run the tests
The `./tests/run_tests.sh` is provided to send a batch of test report jobs to Kibana. These are for
benchmarking: determining how much CPU, RAM is consumed for different kinds of reports, and how long it takes
for them to run.

You can also just go to Kibana's UI at http://localhost:5777 and create reports for your own tests.

## Monitoring Reports
As reporting jobs run, performance metrics are stored into the `filebeat-reporting-{version}` data stream. The
cluster has the "Monitoring of Reporting" space installed, with a dashboard to visualize the metrics.

## FAQ

- Q: How do I see the Kibana logs?
- A: `vagrant ssh -c "sudo journalctl -u kibana.service -f"` or `vagrant ssh -c "tail -f /var/log/kibana.log"`
