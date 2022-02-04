#!/usr/bin/bash

if [ -z "$TEST_KIBANA_URL" ]
then
  TEST_KIBANA_URL=http://elastic:changeme@localhost:5777
fi

###
### Dashboard PDF tests, Preserve Layout
###
DASHBOARD_PARAMS=(
%28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2332%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%277adfa750-4c81-11e8-b3d7-01146121b73d%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T22%3A00%3A00.000Z%27%2Cto%3A%272022-01-21T01%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BFlights%5D%20Global%20Flight%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
%28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2360%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3Aedf84fe0-e1a0-11e7-b6d5-4dc382ef7f5b%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T23%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T23%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BLogs%5D%20Web%20Traffic%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
%28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2052%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%27722b74f0-b882-11e8-a6d9-e546fe2bba5f%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T19%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T19%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BeCommerce%5D%20Revenue%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
)

function dashboardPdfTests1() {
  echo
  echo Dashboard PDF tests, Preserve Layout
  for ((i=0;i<${#DASHBOARD_PARAMS[@]};i++)); 
  do 
    PARAM=${DASHBOARD_PARAMS[$i]}
    TITLE="Dashboard_PDF_Preserve_Test_$i"
    echo $TITLE $PARAM
    curl --silent -H "kbn-xsrf: reporting" -XPOST "${TEST_KIBANA_URL}/s/reporting-test-fixtures/api/reporting/generate/printablePdfV2?jobParams=${PARAM}"
  done
}

###
### Canvas PDF tests, Canvas Layout
###
CANVAS_PARAMS=(
%28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1280%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-a474e74b-aedc-47c3-894a-db77e62c41e0%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27%5BFlights%5D%20Overview%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
%28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1280%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-ad72a4e9-b422-480c-be6d-a64a0b79541d%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27%5BLogs%5D%20Web%20Traffic%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
%28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1080%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-e08b9bdb-ec14-4339-94c4-063bddfd610e%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%2C%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-e08b9bdb-ec14-4339-94c4-063bddfd610e%2Cpage%3A2%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27%5BeCommerce%5D%20Revenue%20Tracking%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
)
function canvasPdfTests1() {
  echo
  echo Canvas PDF tests, Canvas Layout
  for ((i=0;i<${#CANVAS_PARAMS[@]};i++)); 
  do 
    PARAM=${CANVAS_PARAMS[$i]}
    TITLE="Canvas_PDF_Test_$i"
    echo $TITLE $PARAM
    curl --silent -H "kbn-xsrf: reporting" -XPOST "${TEST_KIBANA_URL}/s/reporting-test-fixtures/api/reporting/generate/printablePdfV2?jobParams=${PARAM}"
  done
}

dashboardPdfTests1
canvasPdfTests1
