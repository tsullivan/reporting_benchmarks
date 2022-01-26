#!/bin/bash

HOST="http://localhost:5666"
AUTH="elastic:changeme"


curl --silent -XPOST "${HOST}/api/spaces/space" \
 -H "kbn-xsrf: reporting" \
 -u ${AUTH} \
 --data '{
  "name": "report-test",
  "id": "report-test",
  "description": "This space is for saved objects used for Reporting benchmark tests!",
  "initials": "r",
  "color": "#9170B8",
  "disabledFeatures": [
    "enterpriseSearch",
    "logs",
    "infrastructure",
    "apm",
    "uptime",
    "observabilityCases",
    "siem",
    "securitySolutionCases",
    "advancedSettings",
    "indexPatterns",
    "osquery",
    "actions",
    "stackAlerts",
    "fleet",
    "monitoring",
    "savedObjectsTagging"
  ],
  "imageUrl": ""
}'
