#!/usr/bin/bash

HOST="http://localhost:5666/s/report-test"
AUTH="elastic:changeme"
WIDTH=2500

DASHBOARD_IDS=(
7adfa750-4c81-11e8-b3d7-01146121b73d
edf84fe0-e1a0-11e7-b6d5-4dc382ef7f5b
722b74f0-b882-11e8-a6d9-e546fe2bba5f
)

CANVAS_IDS=(
a474e74b-aedc-47c3-894a-db77e62c41e0
ad72a4e9-b422-480c-be6d-a64a0b79541d
e08b9bdb-ec14-4339-94c4-063bddfd610e # 2 page
)

###
### Dashboard PNG tests
###
function dashboardPngTests() {
  echo
  echo Dashboard PNG tests

  for ((i=0;i<${#DASHBOARD_IDS[@]};i++)); 
  do 
    ID=${DASHBOARD_IDS[$i]}
    TITLE="Dashboard_PNG_Test_$i"
    echo $TITLE $ID
    curl --silent \
     -XPOST "${HOST}/api/reporting/generate/pngV2?jobParams=(layout%3A(dimensions%3A(height%3A10%2Cwidth%3A${WIDTH})%2Cid%3Apreserve_layout)%2ClocatorParams%3A(id%3ADASHBOARD_APP_LOCATOR%2Cparams%3A(dashboardId%3A%27${ID}%27%2CpreserveSavedFilters%3A!t%2CuseHash%3A!f%2CviewMode%3Aview)%2Cversion%3A%278.1.0-SNAPSHOT%27)%2CobjectType%3Adashboard%2Ctitle%3A%27${TITLE}%27%2Cversion%3A%278.1.0-SNAPSHOT%27)" \
     -H "kbn-xsrf: reporting" \
     -u ${AUTH}
  done
}
dashboardPngTests

###
### Dashboard PDF tests, Preserve Layout
###
function dashboardPdfTests1() {
  echo
  echo Dashboard PDF tests, Preserve Layout

  for ((i=0;i<${#DASHBOARD_IDS[@]};i++)); 
  do 
    ID=${DASHBOARD_IDS[$i]}
    TITLE="Dashboard_PDF_Preserve_Test_$i"
    echo $TITLE $ID
  done
}
dashboardPdfTests1

###
### Dashboard PDF tests, Print Layout
###
function dashboardPdfTests2() {
  echo
  echo Dashboard PDF tests, Print Layout

  for ((i=0;i<${#DASHBOARD_IDS[@]};i++)); 
  do 
    ID=${DASHBOARD_IDS[$i]}
    TITLE="Dashboard_PDF_Print_Test_$i"
    echo $TITLE $ID
  done
}
dashboardPdfTests2


###
### Canvas PDF tests
###
function canvasPdfTests() {
  echo
  echo Canvas PDF tests

  for ((i=0;i<${#CANVAS_IDS[@]};i++)); 
  do 
    ID=${CANVAS_IDS[$i]}
    TITLE="Canvas_Test_$i"
    echo $TITLE $ID

    # All are just 1 page
    curl --silent \
     -XPOST "${HOST}/api/reporting/generate/printablePdfV2?jobParams=%28browserTimezone%3AAmerica%2FPhoenix%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1280%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-${ID}%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27${TITLE}%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29" \
     -H "kbn-xsrf: reporting" \
     -u ${AUTH}
  done
}
canvasPdfTests


###
### Canvas PDF 2-Page test
###
function canvasPdfTests2() {

  ID=e08b9bdb-ec14-4339-94c4-063bddfd610e
  TITLE="Canvas_Test_2Page"
  echo $TITLE $ID

  # All are just 1 page
  curl --silent \
   -XPOST "${HOST}/api/reporting/generate/printablePdfV2?jobParams=%28browserTimezone%3AAmerica%2FPhoenix%2Clayout%3A%28dimensions%3A%28height%3A720%2Cwidth%3A1080%29%2Cid%3Acanvas%29%2ClocatorParams%3A%21%28%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-${ID}%2Cpage%3A1%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%2C%28id%3ACANVAS_APP_LOCATOR%2Cparams%3A%28id%3Aworkpad-${ID}%2Cpage%3A2%2Cview%3AworkpadPDF%29%2Cversion%3A%278.1.0-SNAPSHOT%27%29%29%2CobjectType%3A%27canvas%20workpad%27%2Ctitle%3A%27${TITLE}%27%2Cversion%3A%278.1.0-SNAPSHOT%27%29" \
   -H "kbn-xsrf: reporting" \
   -u ${AUTH}
}
canvasPdfTests2
