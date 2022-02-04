# Reporting performance test environment setup

This code is used to create benchmark datasets for Kibana Reporting purposes.

Requirements: Kibana 8.1+, Vagrant, command line

## Run with Vagrant

These steps show how to run a test environment based on 8.1.0, but it should work for any version with available snapshots.

## Run Elasticsearch
Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version (is 8.1.0 at the time of this writing).

## Download and Start Kibana
- Edit the Vagrantfile to configure the memory size and number of CPUs.
- Run `VERSION=8.1.0 vagrant up --provision`, matching the version with the ES snapshot instance.

## Set up the cluster for testing
Run `./setup/setup_kibana.sh` to store sample data and saved objects used for testing.

## Run the tests
Run `./tests/run_tests.sh` to send a batch of test report jobs to Kibana.

## What it Does
 - Downloads and installs the latest snapshot of Kibana and Metricbeat into a Vagrant machine
 - Sets the cluster license to Trial.
 - Installs sample data and the Monitoring of Reporting dashboard
 - Runs Reporting tests using the sample data, feeds metrics into Monitoring of Reporting

As reporting jobs run, performance metrics are stored into the
`.kibana-event-log-*` index pattern. The cluster has the "Monitoring of
Reporting" space installed, with a dashboard to visualize the metrics.

## FAQ

- Q: How do I see the Kibana logs?
- A: `vagrant ssh -c "sudo journalctl -u kibana.service -f" `
