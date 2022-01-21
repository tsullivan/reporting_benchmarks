export TEST_KIBANA_URL=http://elastic:changeme@localhost:5666
export TEST_ES_URL=http://elastic:changeme@localhost:9200
ROOT=$HOME/elastic/kibana
CONFIG="--config $ROOT/x-pack/test/functional/config.js"


NODE_TLS_REJECT_UNAUTHORIZED=0 node --no-warnings $ROOT/scripts/es_archiver $CONFIG load sample_dataoids
