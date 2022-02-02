# Reporting performance test environment setup

This code is used to create benchmark datasets for Kibana Reporting purposes.

Requirements: Vagrant, command line

## Run with Vagrant

These steps show how to run a test environment based on 8.1.0, but it should work for any version with available snapshots.

1. Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version (is 8.1.0 at the time of this writing).
1. Edit the Vagrantfile to configure the memory size and number of CPUs
1. Run `VERSION=8.1.0 vagrant up --provision`, matching the version with the ES snapshot instance.
1. Run `./setup/setup_kibana.sh` to store sample data and saved objects used for testing.
1. Run `./tests/run_tests.sh` to send a batch of test report jobs to Kibana.
1. View Reporting performance results using the .kibana-event-log index pattern in the default space.
