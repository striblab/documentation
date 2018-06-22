Analysis of MN high school hockey data.

## SportsEngine

Data is gathered from [SportsEngine](https://www.sportsengine.com/) (sportngin.com).

## Data

Gather data from API and load into DataDrop DB.

- Gather penalty data: `node lib/penalty-data-collect.js`
  - Outputs files to the `build-data/` folder.
  - Caches responses in `.sport-engine-cache`
  - Make sure to set `SPORTS_ENGINE_API_KEY` environment variable, can use a `.env` file.
- Load data into database with `tables` with similar commands:
  - `tables -i build-data/games.csv --db="mysql://user:pass@localhost/sports" --config="lib/tables-config-games.js"`
  - `tables -i build-data/penalties.csv --db="mysql://user:pass@localhost/sports" --config="lib/tables-config-penalties.js"`
- Make some adjustments, specifically add penalty counts for games
  - `node lib/table-aggregations.js`
  - To connect to the database, set the `HS_HOCKEY_DATABASE_URI` environment variable

## Data analysis

We do some analysis with [Idyll](https://idyll-lang.org/).

- Prequesistes:
  - `npm install idyll -g`
- Collect data from the database.
  - To connect to the database, set the `HS_HOCKEY_DATABASE_URI` environment variable
  - Run: `node lib/analysis-data.js`
  - This will read all the SQL files in `queries/` and create JSON files in `build-data/`
- To sync up to S3:
  - `aws s3 --profile=profile sync ./build/ s3://bucket/data-notebooks/hs-hockey-penalties/`
