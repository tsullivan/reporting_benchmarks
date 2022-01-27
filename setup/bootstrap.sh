#!/bin/sh
set -e

if [ -z "$VERSION" ]; then
  echo "Must provide VERSION in environment" 1>&2
  exit 1
fi

MANIFEST=$(curl --silent -XGET https://artifacts-api.elastic.co/v1/versions/$VERSION-SNAPSHOT/builds)
BUILD_HASH=$(echo $MANIFEST | jq -r '.builds[0]')
KBN_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/kibana/kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
MBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/metricbeat/metricbeat-$VERSION-SNAPSHOT-amd64.deb

echo "Bootstrapping for Kibana hash: ${BUILD_HASH}"

# Set up network
echo "10.0.2.2  elasticsearch" >> /etc/hosts
echo "127.0.0.1  kibana" >> /etc/hosts

cat << HELLO > /etc/profile.d/custom.sh
echo
echo \# Latest build: $BUILD_HASH
echo \# Manifest updated: $(echo $MANIFEST | jq -r '.manifests["last-update-time"]')
echo \# Latest Kibana snapshot URL: $KBN_DOWNLOAD_URL
echo \# Latest Metricbeat snapshot URL: $MBT_DOWNLOAD_URL
echo
HELLO

cat << KBN_INSTALL > /home/vagrant/setup-kibana.sh
set -o verbose
cd /home/vagrant
wget --progress=bar:force:noscroll $KBN_DOWNLOAD_URL
tar xzf kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
ln -s kibana-$VERSION-SNAPSHOT kibana-SNAPSHOT
cd kibana-SNAPSHOT
rm config/kibana.yml
rm config/node.options
cp -r /vagrant/setup/config/* ./config
KBN_INSTALL
sudo -u vagrant /home/vagrant/setup-kibana.sh # install kibana as normal user

# set up systemd services
cp /vagrant/setup/kibana.service /etc/systemd/system/kibana.service

/bin/systemctl daemon-reload
/bin/systemctl start kibana

cat << MBT_INSTALL > /home/vagrant/setup-metricbeat.sh
set -o verbose
cd /home/vagrant
wget --progress=bar:force:noscroll $MBT_DOWNLOAD_URL
MBT_INSTALL
