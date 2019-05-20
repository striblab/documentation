The `business-companies` database is a collection of tables on information about Minnesota companies and non-profits, specifically for the yearly top business lists. This data is managed by the Business department.

The main outputs of this data are the following:

* [Top 50 businesses](http://apps.startribune.com/top_100_business/revenueView.php)
* [Top 100 CEOs](http://apps.startribune.com/top_100_exec_comp/topCeoView.php)
* [Top 100 Nonprofits](http://www.startribune.com/nonprofit-100/460547793/)
  * Previously [Top 100 Nonprofits](http://apps.startribune.com/top_100_nonprofits/revenueView.php)

## Migration

Migration from Microsoft Access files into the Data Drop database was [managed in this repo](https://github.com/MinneapolisStarTribune/newsroom-migrations).

## Reuters

In 2018, we started using Reuters/Eikon data to populate the some of the financial parts of the Top 50.

**Note**: Getting data programattically was too dofficult, so the Business Department will pull data into an Excel sheet and that is important.  See [most recent project](https://github.com/striblab/2019-business-strib-50) for how that gets used.

### Dependencies

To access the Eikon API, you need to be running the Eikon application (Windows only) or there is a [Eikon API Proxy](https://developers.thomsonreuters.com/eikon-data-apis/downloads) application that can work on multiple platforms such as Mac. You will need an Eikon account to run the application.

Once the application is open, you can create an App ID to use with API client. Note that this has already been done.

Note that you need to create a free developer account to access the [Eikon API documentation](https://developers.thomsonreuters.com/eikon-data-apis).

There is one [API client written in Python](https://pypi.python.org/pypi/eikon). This is what we use to get our data. Note that it outputs [Pandas Dataframes](https://pandas.pydata.org/pandas-docs/stable/dsintro.html#dataframe).

Note that all commands are assumed from this directory.

* Python 3. Unsure if this is necessary or not, but so far, all of this has only been done with Python 3.
* Install `pipenv`
* Run `pipenv install && pipenv shell`
* Set environment variables in a `.env` file in this directory, should have lines like `VAR=value`.
  * `MYSQL_USER`
  * `MYSQL_PASS`
  * `MYSQL_HOST`

## Get data

To get data, run: `python eikon-import.py`
