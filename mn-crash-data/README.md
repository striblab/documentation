**Note**, this data was not loaded into the Data Drop DB with this script.  The information below and code here was a beginning at trying to geocode the data, but was not fully realized.

# MN crash data

_Data obtained from ?? <need to fill in>_

## Strib data

Data is loaded into the `newsroomdata` database in the following tables:

* `crash_acc_10_15`
* `crash_acc_2015`
* `crash_pers_10_15`
* `crash_veh_10_15`

## Processing

### Location

Data from 2015 and prior has location data that is based on road routes and the place along those roads. This means we need to transform it to get a latitude and longitude. We general idea is to load the data into a Postgres (PostGIS) database along with the road data to do the calculations.

#### Prerequisites

* Access to the "Data drop" database.
* Install Postgres and the PostGIS extensions.
  * On a Mac, it is suggested to use the [Postgres App](https://postgresapp.com/)
* Install [drake](https://github.com/Factual/drake)
  * On a Mac, `brew install drake`
* Install `shp2pgsql`
  * This is actually installed with PostGIS. On a Mac, you can install with `brew install postgis`, though we aren't going to use this version of PostGIS.
* Install `pipenv`
  * On a Mac, `brew install pipenv`
  * OR just: `pip install pipenv`

#### Run

* Make sure your environment variables are set. This could be done with a `.env` file and `source ./.env`
* Run the drake workflow: `drake -w data.workflow`
