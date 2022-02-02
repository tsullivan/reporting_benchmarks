#!/bin/bash

set -o verbose

cd $(dirname "$0")

export TEST_KIBANA_URL=http://elastic:changeme@localhost:5777
export TEST_ES_URL=http://elastic:changeme@localhost:9200

XSRF="kbn-xsrf: great-software"
CONTENT_TYPE="Content-Type: application/json"

curl $TEST_KIBANA_URL/api/license/start_trial \
  -H "$XSRF" -X "POST"
echo

curl $TEST_KIBANA_URL/api/spaces/space \
  -H "$CONTENT_TYPE" -H "$XSRF" \
  --data-raw '{"name":"test fixtures","id":"reporting-test-fixtures","description":"This space contains variously sized dashboard for Reporting benchmark test running.","initials":"r","color":"#CA8EAE","disabledFeatures":["siem","securitySolutionCases","enterpriseSearch","advancedSettings","savedObjectsTagging","osquery","actions","stackAlerts","fleet"],"imageUrl":""}'
echo

curl $TEST_KIBANA_URL/api/spaces/space \
  -H "$CONTENT_TYPE" -H "$XSRF" \
  --data-raw '{"name":"Monitoring of Reporting","id":"reporting-monitoring","description":"This space contains the index patterns and dashboard used for monitoring the activities of Kibana Reporting in the cluster.","initials":"R","color":"#DA8B45","disabledFeatures":[],"imageUrl":""}'
echo

curl -XPOST $TEST_KIBANA_URL/s/reporting-test-fixtures/api/saved_objects/_import?createNewCopies=false \
  -H "$XSRF" --form file=@archives/sample_data.ndjson
echo

ROOT=$HOME/elastic/kibana
CONFIG="--config $ROOT/x-pack/test/functional/config.js"
node $ROOT/scripts/es_archiver $CONFIG load archives/sample_data

curl $TEST_KIBANA_URL/s/reporting-monitoring/api/saved_objects/index-pattern/kibana-system-event-log \
  -H "$CONTENT_TYPE" -H "$XSRF" \
  --data-raw '{"attributes":{"fieldAttrs":"{}","title":".kibana-event-log*","timeFieldName":"@timestamp","fields":"[]","typeMeta":"{}","runtimeFieldMap":"{}"}}'
echo
