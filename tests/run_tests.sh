#!/usr/bin/bash

if [ -z "$TEST_KIBANA_URL" ]
then
  TEST_KIBANA_URL=http://elastic:changeme@localhost:5777
fi

###
### Define test params
###

DASHBOARD_PARAMS_PDF=(
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2332%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%277adfa750-4c81-11e8-b3d7-01146121b73d%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T22%3A00%3A00.000Z%27%2Cto%3A%272022-01-21T01%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BFlights%5D%20Global%20Flight%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2360%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3Aedf84fe0-e1a0-11e7-b6d5-4dc382ef7f5b%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T23%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T23%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BLogs%5D%20Web%20Traffic%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2052%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%27722b74f0-b882-11e8-a6d9-e546fe2bba5f%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T19%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T19%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BeCommerce%5D%20Revenue%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
)
DASHBOARD_PARAMS_PRINT=(
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2331.990966796875%2Cwidth%3A2320%29%2Cid%3Aprint%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%277adfa750-4c81-11e8-b3d7-01146121b73d%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T22%3A00%3A00.000Z%27%2Cto%3A%272022-01-21T01%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BFlights%5D%20Global%20Flight%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2359.988525390625%2Cwidth%3A2320%29%2Cid%3Aprint%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3Aedf84fe0-e1a0-11e7-b6d5-4dc382ef7f5b%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T23%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T23%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BLogs%5D%20Web%20Traffic%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2051.99072265625%2Cwidth%3A2320%29%2Cid%3Aprint%29%2ClocatorParams%3A%21%28%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%27722b74f0-b882-11e8-a6d9-e546fe2bba5f%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T19%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T19%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BeCommerce%5D%20Revenue%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29

)
DASHBOARD_PARAMS_PNG=(
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2332%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%277adfa750-4c81-11e8-b3d7-01146121b73d%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T22%3A00%3A00.000Z%27%2Cto%3A%272022-01-21T01%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BFlights%5D%20Global%20Flight%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2360%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3Aedf84fe0-e1a0-11e7-b6d5-4dc382ef7f5b%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T23%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T23%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BLogs%5D%20Web%20Traffic%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A2052%2Cwidth%3A3056%29%2Cid%3Apreserve_layout%29%2ClocatorParams%3A%28id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A%28dashboardId%3A%27722b74f0-b882-11e8-a6d9-e546fe2bba5f%27%2CpreserveSavedFilters%3A%21t%2CtimeRange%3A%28from%3A%272022-01-13T19%3A00%3A00.000Z%27%2Cto%3A%272022-01-20T19%3A00%3A00.000Z%27%29%2CuseHash%3A%21f%2CviewMode%3Aview%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%2CobjectType%3Adashboard%2Ctitle%3A%27%5BeCommerce%5D%20Revenue%20Dashboard%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
)
CANVAS_PARAMS=(
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1280%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-a474e74b-aedc-47c3-894a-db77e62c41e0%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27%5BFlights%5D%20Overview%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1280%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-ad72a4e9-b422-480c-be6d-a64a0b79541d%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27%5BLogs%5D%20Web%20Traffic%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1080%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-e08b9bdb-ec14-4339-94c4-063bddfd610e%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%2C%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-e08b9bdb-ec14-4339-94c4-063bddfd610e%2Cpage%3A2%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27%5BeCommerce%5D%20Revenue%20Tracking%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
)
CSV_PARAMS=(
  %28browserTimezone%3AUTC%2Ccolumns%3A%21%28order_date%2Ccategory%2Ctaxful_total_price%2Cproducts.price%2Cproducts.product_name%2Cproducts.manufacturer%2Csku%29%2CobjectType%3Asearch%2CsearchSource%3A%28fields%3A%21%28%28field%3A%27%2A%27%2Cinclude_unmapped%3Atrue%29%29%2Cfilter%3A%21%28%28meta%3A%28field%3Aorder_date%2Cindex%3Aff959d40-b880-11e8-a6d9-e546fe2bba5f%2Cparams%3A%28%29%29%2Cquery%3A%28range%3A%28order_date%3A%28format%3Astrict_date_optional_time%2Cgte%3A%272021-12-31T23%3A56%3A08.624Z%27%2Clte%3A%272022-02-12T00%3A46%3A21.255Z%27%29%29%29%29%2C%28meta%3A%28field%3Aorder_date%2Cindex%3Aff959d40-b880-11e8-a6d9-e546fe2bba5f%2Cparams%3A%28%29%29%2Cquery%3A%28range%3A%28order_date%3A%28format%3Astrict_date_optional_time%2Cgte%3A%272021-12-31T23%3A56%3A08.624Z%27%2Clte%3A%272022-02-12T00%3A46%3A21.255Z%27%29%29%29%29%29%2Cindex%3Aff959d40-b880-11e8-a6d9-e546fe2bba5f%2Cparent%3A%28filter%3A%21%28%29%2ChighlightAll%3A%21t%2Cindex%3Aff959d40-b880-11e8-a6d9-e546fe2bba5f%2Cquery%3A%28language%3Akuery%2Cquery%3A%27%27%29%2Cversion%3A%21t%29%2Csort%3A%21%28%28order_date%3Adesc%29%29%2CtrackTotalHits%3A%21t%29%2Ctitle%3A%27%5BeCommerce%5D%20Orders%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
  %28browserTimezone%3AUTC%2Ccolumns%3A%21%28timestamp%2CCarrier%2COriginCityName%2COriginCountry%2CDestCityName%2CDestCountry%2CFlightTimeMin%2CAvgTicketPrice%2CCancelled%2CFlightDelayType%29%2CobjectType%3Asearch%2CsearchSource%3A%28fields%3A%21%28%28field%3A%27%2A%27%2Cinclude_unmapped%3Atrue%29%29%2Cfilter%3A%21%28%28meta%3A%28field%3Atimestamp%2Cindex%3Ad3d7af60-4c81-11e8-b3d7-01146121b73d%2Cparams%3A%28%29%29%2Cquery%3A%28range%3A%28timestamp%3A%28format%3Astrict_date_optional_time%2Cgte%3A%272021-12-31T23%3A56%3A08.624Z%27%2Clte%3A%272022-02-12T00%3A46%3A21.255Z%27%29%29%29%29%2C%28meta%3A%28field%3Atimestamp%2Cindex%3Ad3d7af60-4c81-11e8-b3d7-01146121b73d%2Cparams%3A%28%29%29%2Cquery%3A%28range%3A%28timestamp%3A%28format%3Astrict_date_optional_time%2Cgte%3A%272021-12-31T23%3A56%3A08.624Z%27%2Clte%3A%272022-02-12T00%3A46%3A21.255Z%27%29%29%29%29%29%2Cindex%3Ad3d7af60-4c81-11e8-b3d7-01146121b73d%2Cparent%3A%28filter%3A%21%28%29%2ChighlightAll%3A%21t%2Cindex%3Ad3d7af60-4c81-11e8-b3d7-01146121b73d%2Cquery%3A%28language%3Akuery%2Cquery%3A%27%27%29%2Cversion%3A%21t%29%2Csort%3A%21%28%28timestamp%3Adesc%29%29%2CtrackTotalHits%3A%21t%29%2Ctitle%3A%27%5BFlights%5D%20Flight%20Log%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29
)

###
### Define tests
###

function dashboardPdfTests1() {
  echo
  echo Dashboard PDF tests, Preserve Layout
  for ((i=0;i<${#DASHBOARD_PARAMS_PDF[@]};i++)); 
  do 
    PARAM=${DASHBOARD_PARAMS_PDF[$i]}
    TITLE="Dashboard_PDF_Preserve_Test_$i"
    echo $TITLE $PARAM
    curl --silent -H "kbn-xsrf: reporting" -XPOST "${TEST_KIBANA_URL}/s/reporting-test-fixtures/api/reporting/generate/printablePdfV2?jobParams=${PARAM}"
  done
}

function dashboardPdfTests2() {
  echo
  echo Dashboard PDF tests, Print Layout
  for ((i=0;i<${#DASHBOARD_PARAMS_PDF[@]};i++)); 
  do 
    PARAM=${DASHBOARD_PARAMS_PRINT[$i]}
    TITLE="Dashboard_PDF_Print_Test_$i"
    echo $TITLE $PARAM
    curl --silent -H "kbn-xsrf: reporting" -XPOST "${TEST_KIBANA_URL}/s/reporting-test-fixtures/api/reporting/generate/printablePdfV2?jobParams=${PARAM}"
  done
}

function dashboardPngTests1() {
  echo
  echo Dashboard PNG tests
  for ((i=0;i<${#DASHBOARD_PARAMS_PNG[@]};i++)); 
  do 
    PARAM=${DASHBOARD_PARAMS_PNG[$i]}
    TITLE="Dashboard_PNG_Test_$i"
    echo $TITLE $PARAM
    curl --silent -H "kbn-xsrf: reporting" -XPOST "${TEST_KIBANA_URL}/s/reporting-test-fixtures/api/reporting/generate/pngV2?jobParams=${PARAM}"
  done
}

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

function csvTests1() {
  echo
  echo CSV tests
  for ((i=0;i<${#CSV_PARAMS[@]};i++)); 
  do 
    PARAM=${CSV_PARAMS[$i]}
    TITLE="CSV_Test_$i"
    echo $TITLE $PARAM
    curl --silent -H "kbn-xsrf: reporting" -XPOST "${TEST_KIBANA_URL}/s/reporting-test-fixtures/api/reporting/generate/csv_searchsource?jobParams=${PARAM}"
  done
}

###
### Run tests
###

canvasPdfTests1
csvTests1
dashboardPngTests1
dashboardPdfTests1
dashboardPdfTests2
