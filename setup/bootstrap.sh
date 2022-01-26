#!/bin/sh
set -e

MANIFEST=$(curl --silent -XGET https://artifacts-api.elastic.co/v1/versions/$VERSION-SNAPSHOT/builds)
BUILD_HASH=$(echo $MANIFEST | jq -r '.builds[0]')
KBN_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/kibana/kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
MBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/metricbeat/metricbeat-$VERSION-SNAPSHOT-docker-image-linux-amd64.tar.gz

echo "Bootstrapping for Kibana hash: ${BUILD_HASH}"

cat << SCRIPT > /etc/profile.d/custom.sh
echo
echo \# Latest build: $BUILD_HASH
echo \# Manifest updated: $(echo $MANIFEST | jq -r '.manifests["last-update-time"]')
echo \# Latest Kibana snapshot URL: $KBN_DOWNLOAD_URL
echo \# Latest Metricbeat snapshot URL: $ME
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
cat metricbeat-$VERSION-SNAPSHOT-docker-image-linux-amd64.tar.gz | docker load
SCRIPT

chmod a+x /home/vagrant/setup.sh

# Set up network
echo "10.0.2.2  elasticsearch" >> /etc/hosts
echo "127.0.0.1  kibana" >> /etc/hosts

# Allow vagrant use to run docker
groupadd -f docker
usermod -aG docker vagrant
