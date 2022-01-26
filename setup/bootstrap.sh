#!/bin/sh
set -e

MANIFEST=$(curl --silent -XGET https://artifacts-api.elastic.co/v1/versions/$VERSION-SNAPSHOT/builds)
BUILD_HASH=$(echo $MANIFEST | jq -r '.builds[0]')
KBN_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/kibana/kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz

echo "Bootstrapping for Kibana hash: ${BUILD_HASH}"

cat << SCRIPT > /etc/profile.d/custom.sh
echo
echo \# Latest build: $BUILD_HASH
echo \# Manifest updated: $(echo $MANIFEST | jq -r '.manifests["last-update-time"]')
echo \# Latest download URL: $KBN_DOWNLOAD_URL
echo
echo \    1. Run the setup.sh script to get started
echo \    2. Run start-kibana.sh
echo \    3. While Kibana is running, run setup-metricbeat.sh
echo \    4. After that, run start-metricbeat.sh
echo \    5. When Kibana and Metricbeat are running, run the test scripts from the host machine.
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
SCRIPT

cat << SCRIPT > /home/vagrant/start-kibana.sh
set -o verbose
cd /home/vagrant/kibana-$VERSION-SNAPSHOT
./bin/kibana
SCRIPT

chmod a+x /home/vagrant/setup.sh
chmod a+x /home/vagrant/start.sh

# MB
cp /vagrant/setup/setup-metricbeat.sh /home/vagrant
cp /vagrant/setup/start-metricbeat.sh /home/vagrant

# Allow access to elasticsearch
echo "10.0.2.2  elasticsearch" >> /etc/hosts
echo "127.0.0.1  kibana" >> /etc/hosts

# Allow vagrant use to run docker
groupadd -f docker
usermod -aG docker vagrant
