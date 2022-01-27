#!/bin/bash

export TEST_KIBANA_URL=http://elastic:changeme@localhost:5777
export TEST_ES_URL=http://elastic:changeme@localhost:9200

curl $TEST_KIBANA_URL/api/license/start_trial \
  -X 'POST' \
  -H 'kbn-xsrf: great-software'

curl $TEST_KIBANA_URL/api/spaces/space \
  -H 'Content-Type: application/json' \
  -H 'kbn-xsrf: great-software' \
  --data-raw '{"name":"reporting-test-fixtures","id":"reporting-test-fixtures","description":"This space contains variously sized dashboard for Reporting benchmark test running.","initials":"r","color":"#CA8EAE","disabledFeatures":["siem","securitySolutionCases","enterpriseSearch","advancedSettings","savedObjectsTagging","osquery","actions","stackAlerts","fleet"],"imageUrl":""}'
echo

curl -XPOST $TEST_KIBANA_URL/s/reporting-test-fixtures/api/saved_objects/_import?createNewCopies=false \
  -H "kbn-xsrf: true" \
  --form file=@archives/sample_dataoids.ndjson
echo

ROOT=$HOME/elastic/kibana
CONFIG="--config $ROOT/x-pack/test/functional/config.js"
node $ROOT/scripts/es_archiver $CONFIG load archives/sample_dataoids
