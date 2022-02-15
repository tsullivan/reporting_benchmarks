#!/bin/sh
set -e

if [ -z "$VERSION" ]; then
  echo "Must provide VERSION in environment" 1>&2
  exit 1
fi

VCONFIG=/vagrant/setup/config
VHOME=/home/vagrant

MANIFEST=$(curl --silent -XGET https://artifacts-api.elastic.co/v1/versions/$VERSION-SNAPSHOT/builds)
BUILD_HASH=$(echo $MANIFEST | jq -r '.builds[0]')

if [ -z "$BUILD_HASH" ] || [ "$BUILD_HASH" = "null" ]; then
  echo "BUILD_HASH could not be retrieved!" 1>&2
  exit 1
fi

echo "Bootstrapping for Kibana hash: ${BUILD_HASH}"

KBN_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/kibana/kibana-$VERSION-SNAPSHOT-amd64.deb
MBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/metricbeat/metricbeat-$VERSION-SNAPSHOT-amd64.deb
JBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/journalbeat/journalbeat-$VERSION-SNAPSHOT-amd64.deb


# Set up network
echo "10.0.2.2  elasticsearch" >> /etc/hosts
echo "127.0.0.1  kibana" >> /etc/hosts

cat << HELLO > /etc/profile.d/custom.sh
echo
echo \# Latest build: $BUILD_HASH
echo \# Manifest updated: $(echo $MANIFEST | jq -r '.manifests["last-update-time"]')
echo \# Latest Kibana snapshot URL: $KBN_DOWNLOAD_URL
echo \# Latest Metricbeat snapshot URL: $MBT_DOWNLOAD_URL
echo \# Latest Journalbeat snapshot URL: $JBT_DOWNLOAD_URL
echo
HELLO

cat << KBN_INSTALL > $VHOME/setup-kibana.sh
set -o verbose
cd $VHOME
mkdir $BUILD_HASH ; cd $BUILD_HASH
wget --progress=bar:force:noscroll $KBN_DOWNLOAD_URL
dpkg -i kibana-$VERSION-SNAPSHOT-amd64.deb
cp $VCONFIG/kibana.yml /etc/kibana
cp $VCONFIG/node.options /etc/kibana
KBN_INSTALL

cat << MBT_INSTALL > $VHOME/setup-metricbeat.sh
set -o verbose
cd $VHOME
mkdir $BUILD_HASH ; cd $BUILD_HASH
wget --progress=bar:force:noscroll $MBT_DOWNLOAD_URL
dpkg -i metricbeat-$VERSION-SNAPSHOT-amd64.deb
cp $VCONFIG/metricbeat.yml /etc/metricbeat/
MBT_INSTALL

chmod a+x $VHOME/setup-kibana.sh
chmod a+x $VHOME/setup-metricbeat.sh

$VHOME/setup-kibana.sh
$VHOME/setup-metricbeat.sh

/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
/bin/systemctl enable metricbeat.service

/bin/systemctl start kibana.service
/bin/systemctl start metricbeat.service
