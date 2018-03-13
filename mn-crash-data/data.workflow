; /usr/bin/drake
;
; This file describes and performs the data processing
; workflow using Drake, a Make-like format focused on data.
; https://github.com/Factual/drake
;
; Full documentation (suggested to switch to Viewing mode)
; https://docs.google.com/document/d/1bF-OKNLIG10v_lMes_m4yyaJtAaJKtdK0Jizvi_MNsg/
;
; Suggested groups/tags of tasks:
; Download, Convert, Combine, Analysis, and Export
;
; Run with: drake -w data.workflow
;
; If you have mutliple inputs and outputs, then you can do $INPUT,
; $INPUT2, $OUTPUT, $OUTPUT2, etc


; Base directory for all inputs and output.  Note that the $BASE variable
; is not used in the task definition (first line), but for the commands,
; it is needed.
; BASE=.


; Make database
sources/database-created, %setup <-
  mkdir -p sources
  createdb $POSTGRES_DB
  psql -d $POSTGRES_DB -c "CREATE EXTENSION postgis"
  psql -d $POSTGRES_DB -c "CREATE EXTENSION postgis_topology"
  touch $OUTPUT


; Get road data from MN GIS
; https://gisdata.mn.gov/dataset/trans-roads-mndot-tis
sources/shp_trans_roads_mndot_tis.zip, %download <- [-timecheck]
  mkdir -p sources
  wget -O $OUTPUT "ftp://ftp.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_dot/trans_roads_mndot_tis/shp_trans_roads_mndot_tis.zip"

sources/shp_trans_roads_mndot_tis/STREETS_LOAD.shp, %download <- sources/shp_trans_roads_mndot_tis.zip
  unzip -o $INPUT -d sources/shp_trans_roads_mndot_tis
  touch $OUTPUT

; Get data from database
sources/mn-crashes-2010-2015.msql, %download <- [-timecheck]
  mkdir -p sources
  [ -e $OUTPUT ] && rm $OUTPUT
  eval "mysqldump --compatible=postgres --user=$DATA_DROP_USER --host=$DATA_DROP_HOST -p$DATA_DROP_PASS $DATA_DROP_DB crash_acc_10_15 > $OUTPUT"


; Convert roads to 4326/lat,lon
sources/shp_trans_roads_mndot_tis-4326/STREETS_LOAD-4326.shp, %convert <- sources/shp_trans_roads_mndot_tis/STREETS_LOAD.shp
  mkdir -p sources/shp_trans_roads_mndot_tis-4326
  [ -e $OUTPUT ] && rm $OUTPUT
  ogr2ogr -f "ESRI Shapefile"  -t_srs "EPSG:4326" $OUTPUT $INPUT

; Convert data dump from mysql to postgres
; NOTE: This seems to want an Enter input
sources/mn-crashes-2010-2015.psql, %convert <- sources/mn-crashes-2010-2015.msql
  mkdir -p sources
  pipenv install --two
  [ -e $OUTPUT ] && rm $OUTPUT
  python lib/mysql-to-psql.py $INPUT $OUTPUT



; Load roads into database
sources/database-roads-loaded, %load <- sources/shp_trans_roads_mndot_tis-4326/STREETS_LOAD-4326.shp, sources/database-created
  mkdir -p sources
  shp2pgsql -s 4326 $INPUT mn_roads | psql -d $POSTGRES_DB
  touch $OUTPUT

; Load crash data
sources/database-crashes-loaded, %load <- sources/mn-crashes-2010-2015.psql
  mkdir -p sources
  psql -d $POSTGRES_DB -L $OUTPUT.log -f $INPUT
  touch $OUTPUT

; Add indexes for faster processing
sources/database-indexes, %load <- sources/database-crashes-loaded, sources/database-roads-loaded
  mkdir -p sources
  psql -d $POSTGRES_DB -L $OUTPUT.log -f lib/mn-crashes-indexes.psql
  touch $OUTPUT


; Cleanup tasks
%sources.cleanup, %cleanup, %WARNING <-
  rm -rv sources/*
%build.cleanup, %cleanup, %WARNING <-
  rm -rv build/*
