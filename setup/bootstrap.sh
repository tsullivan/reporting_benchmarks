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

cat << STACK > $VHOME/install.sh
#!/bin/sh
set -o verbose

mkdir $VHOME/$BUILD_HASH
chown vagrant:vagrant $VHOME/$BUILD_HASH

wget --progress=bar:force:noscroll \
  $MBT_DOWNLOAD_URL \
  $FBT_DOWNLOAD_URL \
  $KBN_DOWNLOAD_URL \
  -P $BUILD_HASH

dpkg -i $BUILD_HASH/metricbeat-$VERSION-SNAPSHOT-amd64.deb
dpkg -i $BUILD_HASH/filebeat-$VERSION-SNAPSHOT-amd64.deb
dpkg -i $BUILD_HASH/kibana-$VERSION-SNAPSHOT-amd64.deb

cp $VCONFIG/metricbeat.yml /etc/metricbeat/
cp $VCONFIG/filebeat.yml /etc/filebeat/
cp $VCONFIG/kibana.yml /etc/kibana/

/bin/systemctl daemon-reload
/bin/systemctl enable metricbeat.service
/bin/systemctl enable filebeat.service
/bin/systemctl enable kibana.service
/bin/systemctl start metricbeat.service
/bin/systemctl start filebeat.service
/bin/systemctl start kibana.service
STACK

chmod a+x $VHOME/install.sh
$VHOME/install.sh

touch /var/log/kibana.log
chown kibana:kibana /var/log/kibana.log
