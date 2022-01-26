#!/bin/bash

export TEST_KIBANA_URL=http://elastic:changeme@localhost:5777
export TEST_ES_URL=http://elastic:changeme@localhost:9200

ROOT=$HOME/elastic/kibana
CONFIG="--config $ROOT/x-pack/test/functional/config.js"
node $ROOT/scripts/es_archiver $CONFIG load archives/sample_dataoids

curl -XPOST $TEST_KIBANA_URL/api/saved_objects/_import?createNewCopies=true \
  -H "kbn-xsrf: true" \
  --form file=@archives/sample_dataoids.ndjson
echo

