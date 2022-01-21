#!/bin/bash

# Use a 7.16.3 build to load sample data, and then export it using this tool.
#
export TEST_KIBANA_URL=http://elastic:changeme@localhost:5601
export TEST_ES_URL=http://elastic:changeme@localhost:9200

ROOT=$HOME/elastic/kibana
CONFIG="--config $ROOT/x-pack/test/functional/config.js"

# Save Elasticsearch Data
node $ROOT/scripts/es_archiver $CONFIG save test "kibana_sample_data_ecommerce,kibana_sample_data_logs,kibana_sample_data_flights"

# Save Kibana Saved Objects
curl 'http://elastic:changeme@localhost:5601/api/saved_objects/_export' \
  -H 'Content-Type: application/json' \
  -d '{"type":["dashboard","canvas-workpad"],"includeReferencesDeep":true}'
