# Nice Ride

[Nice Ride](https://www.niceridemn.org/) is the Twin Cities bike share program. They [release data](https://www.niceridemn.org/data/) each year.

The data is imported into the `transportation` database with the following tables:

* `nice_ride_terminals`: The bike stations. Each year is loaded in, so the primary key is the terminal ID and the year.
* `nice_ride_trip`: Each trip taken. The primary key is the row ID from the original dataset and the year.

## Importing

### Dependencies

Assumes running commands from this directory.

* `npm install`
* `wget`
* `unzip`
* `tables`: `npm install -g tables`

### Download data

They use some other service to host the data files.

```
mkdir -p downloads;

wget -O downloads/nice-ride-2010.zip "https://niceridemn.egnyte.com/dd/byJLtGzvHM/";
unzip downloads/nice-ride-2010.zip -d downloads/nice-ride-2010;

wget -O downloads/nice-ride-2011.zip "https://niceridemn.egnyte.com/dd/8xAYjDuS3L/";
unzip downloads/nice-ride-2011.zip -d downloads/nice-ride-2011;

wget -O downloads/nice-ride-2012.zip "https://niceridemn.egnyte.com/dd/GlYmbU2Bh0/";
unzip downloads/nice-ride-2012.zip -d downloads/nice-ride-2012;

wget -O downloads/nice-ride-2013.zip "https://niceridemn.egnyte.com/dd/kdJ4WP0mHC/";
unzip downloads/nice-ride-2013.zip -d downloads/nice-ride-2013;

wget -O downloads/nice-ride-2014.zip "https://niceridemn.egnyte.com/dd/MZxvOEELWQ/";
unzip downloads/nice-ride-2014.zip -d downloads/nice-ride-2014;

wget -O downloads/nice-ride-2015.zip "https://niceridemn.egnyte.com/dd/9nSKfEfxQ8/";
unzip downloads/nice-ride-2015.zip -d downloads/nice-ride-2015;

wget -O downloads/nice-ride-2016.zip "https://niceridemn.egnyte.com/dd/gYLZtGrwEk/";
unzip downloads/nice-ride-2016.zip -d downloads/nice-ride-2016;

wget -O downloads/nice-ride-2017.zip "https://niceridemn.egnyte.com/dd/QrR5Ih5Xeq/";
unzip downloads/nice-ride-2017.zip -d downloads/nice-ride-2017;
```

### Import into database

Update `export NICE_RIDE_TABLES_IMPORT_DB` as needed.

```
export NICE_RIDE_TABLES_IMPORT_DB='sqlite://./testing-nice-ride.sql';

export NICE_RIDE_TABLES_IMPORT_DB='mysql://alanp:hqbQvhKhmgtKpE9d@news-data-core-cluster.cluster-c2rw15kieaez.us-east-2.rds.amazonaws.com/transportation';

NICE_RIDE_YEAR=2010 tables -i downloads/nice-ride-2010/Nice_Ride_data_2010_season/Nice_Ride_2010_station_locations.csv --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

NICE_RIDE_YEAR=2011 tables -i downloads/nice-ride-2011/Nice_Ride_data_2011_season/Nice_Ride_2011_station_locations.csv --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

NICE_RIDE_YEAR=2012 tables -i "downloads/nice-ride-2012/Nice_Ride_data_2012_season/Nice_Ride_2012-station_locations .csv" --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

sed 's/Nb docks,/Nb docks,notes/g' downloads/nice-ride-2013/Nice_Ride_data_2013_season/Nice_Ride_2013-station-locations.csv > downloads/nice-ride-2013/Nice_Ride_data_2013_season/Nice_Ride_2013-station-locations.altered.csv;
NICE_RIDE_YEAR=2013 tables -i downloads/nice-ride-2013/Nice_Ride_data_2013_season/Nice_Ride_2013-station-locations.altered.csv --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

NICE_RIDE_YEAR=2014 tables -i "downloads/nice-ride-2014/Nice_Ride_data_2014_season/Nice_Ride_2014_station_locations.csv" --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

NICE_RIDE_YEAR=2015 tables -i "downloads/nice-ride-2015/Nice_Ride_data_2015_season/Nice_Ride_2015_station_locations.csv" --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

sed 's/Nb Docks,/Nb Docks,notes/g' downloads/nice-ride-2016/Nice_ride_data_2016_season/Nice_Ride_2016_Station_Locations.csv > downloads/nice-ride-2016/Nice_ride_data_2016_season/Nice_Ride_2016_Station_Locations.altered.csv;
NICE_RIDE_YEAR=2016 tables -i "downloads/nice-ride-2016/Nice_ride_data_2016_season/Nice_Ride_2016_Station_Locations.altered.csv" --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

NICE_RIDE_YEAR=2017 tables -i "downloads/nice-ride-2017/Nice_Ride_data_2017_season/Nice_Ride_2017_station_locations.csv" --config=tables-config-terminals.js --db="$NICE_RIDE_TABLES_IMPORT_DB";
```

Import trips. This will take some time. We add a line number to each CSV so that we can create a compound priamry key of year and line number; this allows us to re-do the import with updating instead of adding the dame data.

```
csvcut -l "downloads/nice-ride-2010/Nice_Ride_data_2010_season/Nice_Ride_trip_history_2010_season.csv" > "downloads/nice-ride-2010/Nice_Ride_data_2010_season/Nice_Ride_trip_history_2010_season.lines.csv";
NICE_RIDE_YEAR=2010 tables -i "downloads/nice-ride-2010/Nice_Ride_data_2010_season/Nice_Ride_trip_history_2010_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvcut -l "downloads/nice-ride-2011/Nice_Ride_data_2011_season/Nice_Ride_trip_history_2011_season.csv" > "downloads/nice-ride-2011/Nice_Ride_data_2011_season/Nice_Ride_trip_history_2011_season.lines.csv";
NICE_RIDE_YEAR=2011 tables -i "downloads/nice-ride-2011/Nice_Ride_data_2011_season/Nice_Ride_trip_history_2011_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvcut -l "downloads/nice-ride-2012/Nice_Ride_data_2012_season/Nice_Ride_trip_history_2012_season.csv" > "downloads/nice-ride-2012/Nice_Ride_data_2012_season/Nice_Ride_trip_history_2012_season.lines.csv";
NICE_RIDE_YEAR=2012 tables -i "downloads/nice-ride-2012/Nice_Ride_data_2012_season/Nice_Ride_trip_history_2012_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvcut -l "downloads/nice-ride-2013/Nice_Ride_data_2013_season/Nice_Ride_trip_history_2013_season.csv" > "downloads/nice-ride-2013/Nice_Ride_data_2013_season/Nice_Ride_trip_history_2013_season.lines.csv";
NICE_RIDE_YEAR=2013 tables -i "downloads/nice-ride-2013/Nice_Ride_data_2013_season/Nice_Ride_trip_history_2013_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvcut -l "downloads/nice-ride-2014/Nice_Ride_data_2014_season/Nice_Ride_trip_history_2014_season.csv" > "downloads/nice-ride-2014/Nice_Ride_data_2014_season/Nice_Ride_trip_history_2014_season.lines.csv";
NICE_RIDE_YEAR=2014 tables -i "downloads/nice-ride-2014/Nice_Ride_data_2014_season/Nice_Ride_trip_history_2014_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvcut -l "downloads/nice-ride-2015/Nice_Ride_data_2015_season/Nice_ride_trip_history_2015_season.csv" > "downloads/nice-ride-2015/Nice_Ride_data_2015_season/Nice_ride_trip_history_2015_season.lines.csv";
NICE_RIDE_YEAR=2015 tables -i "downloads/nice-ride-2015/Nice_Ride_data_2015_season/Nice_ride_trip_history_2015_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvgrep -c 1,7  -r "^(0|)$" -i "downloads/nice-ride-2016/Nice_Ride_data_2016_season/Nice_ride_trip_history_2016_season.csv" | csvcut -l > "downloads/nice-ride-2016/Nice_Ride_data_2016_season/Nice_ride_trip_history_2016_season.lines.csv";
NICE_RIDE_YEAR=2016 tables -i "downloads/nice-ride-2016/Nice_Ride_data_2016_season/Nice_ride_trip_history_2016_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";

csvcut -l "downloads/nice-ride-2017/Nice_Ride_data_2017_season/Nice_ride_trip_history_2017_season.csv" > "downloads/nice-ride-2017/Nice_Ride_data_2017_season/Nice_ride_trip_history_2017_season.lines.csv";
NICE_RIDE_YEAR=2017 tables -i "downloads/nice-ride-2017/Nice_Ride_data_2017_season/Nice_ride_trip_history_2017_season.lines.csv" --config=tables-config-trips.js --db="$NICE_RIDE_TABLES_IMPORT_DB";
```
