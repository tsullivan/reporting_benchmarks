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

KBN_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/kibana/kibana-$VERSION-SNAPSHOT-linux-x86_64.tar.gz
FBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/filebeat/filebeat-$VERSION-SNAPSHOT-amd64.deb
MBT_DOWNLOAD_URL=https://snapshots.elastic.co/$BUILD_HASH/downloads/beats/metricbeat/metricbeat-$VERSION-SNAPSHOT-amd64.deb


# Set up network
echo "10.0.2.2  elasticsearch" >> /etc/hosts
echo "127.0.0.1  kibana" >> /etc/hosts

cat << HELLO > /etc/profile.d/custom.sh
echo
echo \# Latest build: $BUILD_HASH
echo \# Manifest updated: $(echo $MANIFEST | jq -r '.manifests["last-update-time"]')
echo \# Latest Kibana snapshot URL: $KBN_DOWNLOAD_URL
echo \# Latest Metricbeat snapshot URL: $MBT_DOWNLOAD_URL
echo \# Latest Filebeat snapshot URL: $FBT_DOWNLOAD_URL
echo
HELLO

cd $VHOME
mkdir $VHOME/$BUILD_HASH

cat << KBN_DOWNLOAD > $VHOME/setup-kibana.sh
set -o verbose
wget --progress=bar:force:noscroll $KBN_DOWNLOAD_URL -P $BUILD_HASH
KBN_DOWNLOAD

cat << BEATS_INSTALL > $VHOME/setup-beats.sh
set -o verbose
cd $VHOHME/$BUILD_HASH
wget --progress=bar:force:noscroll $MBT_DOWNLOAD_URL -P $BUILD_HASH
wget --progress=bar:force:noscroll $FBT_DOWNLOAD_URL -P $BUILD_HASH
dpkg -i $BUILD_HASH/metricbeat-$VERSION-SNAPSHOT-amd64.deb
dpkg -i $BUILD_HASH/filebeat-$VERSION-SNAPSHOT-amd64.deb
cp $VCONFIG/metricbeat.yml /etc/metricbeat/
cp $VCONFIG/filebeat.yml /etc/filebeat/
BEATS_INSTALL

chmod a+x $VHOME/setup-kibana.sh
chmod a+x $VHOME/setup-beats.sh

$VHOME/setup-kibana.sh
$VHOME/setup-beats.sh

/bin/systemctl daemon-reload
/bin/systemctl enable metricbeat.service
/bin/systemctl enable filebeat.service
/bin/systemctl start metricbeat.service
/bin/systemctl start filebeat.service

touch /var/log/kibana.log
chown vagrant:vagrant /var/log/kibana.log
chown vagrant:vagrant $VHOME/$BUILD_HASH
