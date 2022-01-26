#!/bin/sh
set -e


MANIFEST=$(curl --silent -XGET https://artifacts-api.elastic.co/v1/versions/$VERSION-SNAPSHOT/builds)
BUILD_HASH=$(echo $MANIFEST | jq -r '.builds[0]')
KBN_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/kibana/kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
MBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/metricbeat/metricbeat-$VERSION-SNAPSHOT-linux-x86_64.tar.gz

echo "Bootstrapping for Kibana hash: ${BUILD_HASH}"

cat << SCRIPT > /etc/profile.d/custom.sh
echo
echo \# Latest build: $BUILD_HASH
echo \# Manifest updated: $(echo $MANIFEST | jq -r '.manifests["last-update-time"]')
echo \# Latest download URL: $KBN_DOWNLOAD_URL
echo
echo \    Run the setup.sh script to get started.
echo
SCRIPT

cat << SCRIPT > /home/vagrant/setup.sh
set -o verbose
cd /home/vagrant
wget --progress=bar:force:noscroll $KBN_DOWNLOAD_URL
tar xzf kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
cd kibana-$VERSION-SNAPSHOT
rm config/kibana.yml
rm config/node.options
cp -r /vagrant/setup/config/* ./config

cd /home/vagrant
wget --progress=bar:force:noscroll $MBT_DOWNLOAD_URL
tar xzf metricbeat-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
cp /vagrant/setup/config/metricbeat.yml metricbeat-$VERSION-SNAPSHOT
cd metricbeat-$VERSION-SNAPSHOT-linux-x86_64
./metricbeat modules enable linux system
sudo chown root metricbeat.yml
sudo chown root modules.d/system.yml
SCRIPT


cat << SCRIPT > /home/vagrant/start.sh
set -o verbose
cd /home/vagrant/kibana-$VERSION-SNAPSHOT
./bin/kibana
SCRIPT

chmod a+x /home/vagrant/setup.sh
chmod a+x /home/vagrant/start.sh

# Allow access to elasticsearch
echo "10.0.2.2  elasticsearch" >> /etc/hosts
echo "127.0.0.1  kibana" >> /etc/hosts

groupadd -f docker
usermod -aG docker vagrant
