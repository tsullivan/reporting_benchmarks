# Reporting performance test environment setup

This code is used to create benchmark datasets for Kibana Reporting purposes.

Requirements: Vagrant, command line

## Setup
This repo must be cloned into a folder that is under the same parent folder as the kibana repo, with the `main` branch
checked out.

## Run with Vagrant

### 1: Run Elasticsearch
Run `yarn es snapshot` in the Kibana repo on the host machine. Note the snapshot version (is 8.2.0 at the time of this writing).

### 2: Start the Vagrant machine
- The provided Vagrantfile defines a machine with **8GB RAM**, and **4 CPU**s.
- Run `VERSION=8.2.0 vagrant up --provision`, matching the version with the ES snapshot instance.

Simply bringing the machine up and provisioning does the following:

 - Downloads and installs the latest snapshot of Kibana, Filebeat, and Metricbeat
 - Starts Kibana and the other Stack processes in the machine
 - Runs Filebeat to stream JSON-formatted logs from /var/log/kibana.log to Elasticsearch
 - Runs Metricbeat to stream the machine stats to ES

### 3. Set up the cluster for testing
Run `./setup/setup_kibana.sh` to store sample data and saved objects used for testing.

 - Sets the cluster's license to Trial.
 - Installs sample data for testing reports, and a dashboard for monitoring reports.

### 4. Run the tests
The `./tests/run_tests.sh` is provided to send a batch of test report jobs to Kibana. These are for
benchmarking: determining how much CPU, RAM is consumed for different kinds of reports, and how long it takes
for them to run.

You can also just go to Kibana's UI at http://localhost:5777 and create reports for your own tests.

## Monitoring Reports
As reporting jobs run, performance metrics are stored into the `filebeat-reporting-{version}` data stream. The
cluster has the "Monitoring of Reporting" space installed, with a dashboard to visualize the metrics.

After running the setup_kibana script, the Monitoring of Reporting dashboard is accessible from this link: 
http://localhost:5777/s/reporting-monitoring/app/dashboards#/view/25767be0-8f8f-11ec-a200-0156d462ae71

When the machine has been set up and tests have been run, the Monitoring of Reporting dashboard should look something like this:
![image](https://user-images.githubusercontent.com/908371/155586625-dbc5f91a-bc26-40ce-b812-f988b93f20e4.png)

## Cleanup
When you are done testing, shut down the VM using `vagrant halt` or delete the VM using `vagrant destroy`.
## FAQ

- Q: How do I see the Kibana logs?
- A: `vagrant ssh -c "sudo journalctl -u kibana.service -f"` or `vagrant ssh -c "tail -f /var/log/kibana.log"`
