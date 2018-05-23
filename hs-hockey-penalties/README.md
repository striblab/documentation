Analysis of MN high school hockey data.

## SportsEngine

Data is gathered from [SportsEngine](https://www.sportsengine.com/) (sportngin.com).

## Data

Gather data from API and load into DataDrop DB.

* Gather penalty data: `node lib/penalty-data-collect.js`
  * Outputs files to the `build/` folder.
  * Caches responses in `.sport-engine-cache`
  * Make sure to set `SPORTS_ENGINE_API_KEY` environment variable, can use a `.env` file.
* Load data into database with `tables` with similar commands:
  * `tables -i build/games.csv --db="mysql://user:pass@localhost/sports" --config="lib/tables-config-games.js"`
  * `tables -i build/penalties.csv --db="mysql://user:pass@localhost/sports" --config="lib/tables-config-penalties.js"`
