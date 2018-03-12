"""
Gets list of MN companies from database, then gets financies data
from Eikon for those companies.
"""

# Dependencies
import os
import re
from dotenv import load_dotenv, find_dotenv
import _mysql
import eikon
import json

# From last year that should still be good
tickers_2016 = [
    "UNH", "TGT", "BBY", "MMM", "MDT", "USB", "GIS", "SVU", "ECL", "CHRW",
    "AMP", "XEL", "HRL", "MOS", "PDCO", "PNR", "PII", "VAL", "FAST", "TTC",
    "DCI", "FUL", "BWLD", "DLX", "RGS", "ALE", "GGG", "TCB", "SCSS", "OB",
    "APOG", "GKSR", "TNC", "OTTR", "PJC", "MTSC", "SSYS", "VVTV", "TECH",
    "ACAT", "HWKN", "CPLA", "CBK", "TTS", "PRLB", "DGII", "SPSC", "CSII",
    "NOG", "ANIP"
]


# Main execution
def main():
    # Load environment variables from a `.env` file.
    load_dotenv(find_dotenv())

    # Mysql client docs
    # https://mysqlclient.readthedocs.io/
    db = _mysql.connect(
        os.environ.get("MYSQL_HOST"), os.environ.get("MYSQL_USER"),
        os.environ.get("MYSQL_PASS"), os.environ.get("MYSQL_DB"))

    # Set App ID for Eikon
    eikon.set_app_id(os.environ.get("EIKON_APP_ID"))

    # Load up cache file
    cache_data = load_cache()

    # Get commpanies
    db.query("""
        SELECT *
        FROM Companies AS c
        WHERE
          c.CompanyType NOT LIKE "nonprofit%"
          AND c.CompanyType NOT LIKE "charity%"
          AND c.CompanyType NOT LIKE "trust%"
          AND c.CompanyType NOT LIKE "%drop%"
          AND c.State = "MN"
          AND c.StockSymbol IS NOT NULL
        ORDER BY c.StockSymbol
        """)
    results = db.store_result()
    results = results.fetch_row(maxrows=0, how=1)
    print("Found %s rows from the database." % (len(results)))

    # Go through each row
    for r in results:
        coid = r["COID"]

        # In theory the stock symbol should work, but maybe we
        # need a specific ID for Reuters which may have the exchange
        # suffix, such as ABC.N
        reuters = r["ReutersID"].decode("utf-8") if "ReutersID" in r else None
        stock = r["StockSymbol"].decode(
            "utf-8") if "StockSymbol" in r else None
        lookup = reuters if reuters is not None else stock

        # Try default and modifiers
        lookup_symbol(lookup, cache_data)
        lookup_symbol(lookup + '.O', cache_data)
        lookup_symbol(lookup + '.N', cache_data)
        lookup_symbol(lookup + '.A', cache_data)


# Lookup.  Return true if found, otherise false
def lookup_symbol(symbol, cache_data):
    symbol = symbol.upper()

    # Check the cache
    non_found_cache = cache_data.get('not_found', [])
    if symbol in non_found_cache:
        print("[cache] Not found %s" % (symbol))
        return False

    if symbol in cache_data:
        print("[cache] Found %s" % (symbol))
        return True

    # Do lookup
    try:
        dataframe, error = eikon.get_data(
            [symbol],
            [
                # Revenue date
                "TR.Revenue.date",
                # Revenue
                "TR.Revenue",
                # Income
                "TR.NetIncome",
                # Profit
                "TR.GrossProfit",
                # Assets
                "TR.TotalAssetsReported",
                # Equity
                "TR.TotalEquity",

                # Average earnings per share
                "TR.EPSMean",

                # ?
                # "TR.AnalyticSalaryGap",

                # CEO.  This doesn't seem to always be available.
                #"TR.OfficerName",
                # CEO title
                #"TR.OfficerTitle",
                # CEO pay?

                # Number of part time employees
                #"TR.PartTimeEmployees"
            ],
            {
                "SDate": 0,
                "EDate": -10,
                "FRQ": "FY",
                "Curn": "USD"
            },
        )
    except Exception as e:
        print("Exception occured when looking up %s: %s" % (symbol, e))
        return False

    # Check error
    # 413: Unable to resolve all requested identifiers.
    if error and len(error) > 0 and error[0]["code"] == 413:
        print("Not found %s" % (symbol))

        # Update cache
        cache_data['not_found'].append(symbol)
        save_cache(cache_data)
        return False
    elif error:
        print("Other error for %s" % (symbol))
        print(error)
        return False
    else:
        print("Found %s" % (symbol))
        cache_data[symbol] = json.loads(dataframe.to_json(orient='records'))
        save_cache(cache_data)
        return True


# Save cache
def save_cache(data):
    with open(".cache-eikon-data.json", "w") as data_file:
        json.dump(data, data_file)

    return data


# Load or initialize cache
def load_cache():
    data = {}
    if os.path.isfile(".cache-eikon-data.json"):
        with open(".cache-eikon-data.json") as data_file:
            data = json.load(data_file)

    if "not_found" not in data:
        data["not_found"] = []

    if "found" not in data:
        data[""] = {}

    return data


# Run main
if __name__ == "__main__":
    main()
