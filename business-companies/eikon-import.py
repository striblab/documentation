"""
Gets list of MN companies from database, then gets financies data
from Eikon for those companies.
"""

# Dependencies
import sys
import os
import re
from dotenv import load_dotenv, find_dotenv
import _mysql
import eikon
import json
import argparse
import csv
import inspect
from pprint import pprint

# From last year that should still be good
tickers_2016 = [
    "UNH", "TGT", "BBY", "MMM", "MDT", "USB", "GIS", "SVU", "ECL", "CHRW",
    "AMP", "XEL", "HRL", "MOS", "PDCO", "PNR", "PII", "VAL", "FAST", "TTC",
    "DCI", "FUL", "BWLD", "DLX", "RGS", "ALE", "GGG", "TCB", "SCSS", "OB",
    "APOG", "GKSR", "TNC", "OTTR", "PJC", "MTSC", "SSYS", "VVTV", "TECH",
    "ACAT", "HWKN", "CPLA", "CBK", "TTS", "PRLB", "DGII", "SPSC", "CSII",
    "NOG", "ANIP"
]

tickers_2017 = [
    "ACAT.OQ", "UNH.N", "TGT.N", "TGT ", "BBY.N", "BBY", "MMM.N", "MDT.N",
    "MDT", "USB.N", "GIS.N", "GIS", "CHRW.OQ", "ECL.N", "AMP.N", "XEL.OQ",
    "HRL.N", "HRL", "MOS.N", "PDCO.OQ", "PDCO", "PII.N", "PNR.N", "FAST.OQ",
    "DCI.N", "DCI", "TTC.N", "TTC", "FUL.N", "FUL", "DLX.N", "WGO.N", "WGO",
    "GGG.N", "RGS.N", "SNBR.OQ", "ALE.N", "TCF.N", "APOG.OQ", "APOG", "TNC.N",
    "PJC.N", "OTTR.OQ", "MTSC.OQ", "SSYS.OQ", "EVLV.OQ", "EVLV", "TECH.OQ",
    "HWKN.OQ", "CPLA.OQ", "CBK.N", "CBK", "TTS.OQ", "PRLB.N", "SPSC.OQ",
    "NOG.A", "CSII.OQ", "DGII.OQ", "ANIP.OQ", "ASV.OQ", "NSYS.OQ", "TCMD.OQ",
    "IIN.OQ", "JCS.OQ", "CLFD.OQ", "SRDX.OQ", "WINA.OQ", "DAVE.OQ", "GWGH.OQ",
    "CPHC.OQ", "BWB.OQ", "CGNT.OQ", "CYBE.OQ", "NTIC.OQ", "HMNF.OQ", "WSCI.OQ",
    "NVEC.OQ", "QUMU.OQ", "ELMD.A", "ISIG.OQ", "IKNX.OQ", "ISNS.OQ", "ELSE.OQ",
    "CHFS.OQ", "CLXT.OQ", "CVON.OQ", "ARCI.OQ", "BWLD.OQ", "DAKP.Z", "HTCH.OQ",
    "MGCD.W", "MOCO.OQ", "OB", "SVU.N", "SVU"
]

# Global for argparers
args = {}


# Main execution
def main():
    # Load environment variables from a `.env` file.
    load_dotenv(find_dotenv())

    # Set App ID for Eikon
    eikon.set_app_id(os.environ.get("EIKON_APP_ID"))

    # Load up cache file
    cache_data = load_cache()

    # If single lookup
    if args.lookup:
        lookup_data(args.lookup, cache_data)
    else:
        # Mysql client docs
        # https://mysqlclient.readthedocs.io/
        db = _mysql.connect(
            os.environ.get("MYSQL_HOST"), os.environ.get("MYSQL_USER"),
            os.environ.get("MYSQL_PASS"), os.environ.get("MYSQL_DB"))

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
        if not args.skip_lookup or args.skip_lookup is False or args.skip_lookup is None:
            for r in results:
                coid = r["COID"]

                # In theory the stock symbol should work, but maybe we
                # need a specific ID for Reuters which may have the exchange
                # suffix, such as ABC.N
                reuters = r["ReutersID"].decode(
                    "utf-8") if "ReutersID" in r else None
                stock = r["StockSymbol"].decode(
                    "utf-8") if "StockSymbol" in r else None
                lookup = reuters if reuters is not None else stock

                # Try default and modifiers
                suffixes = ["", ".OQ", ".O", ".N", ".A"]
                suffixIndex = 0
                found = False
                while not found:
                    try:
                        found = lookup_data(lookup + suffixes[suffixIndex],
                                            cache_data)
                        suffixIndex = suffixIndex + 1
                    except KeyError:
                        break
                    except IndexError:
                        break

    # Combine data
    combined = {}
    for symbol, rows in cache_data['set1'].items():
        for i in range(len(rows)):
            combined["%s-%s" % (symbol, i)] = rows[i]
    for symbol, rows in cache_data['set2'].items():
        for i in range(len(rows)):
            if "%s-%s" % (symbol, i) in combined:
                combined["%s-%s" % (symbol, i)] = {
                    **combined["%s-%s" % (symbol, i)],
                    **rows[i]
                }
    for symbol, rows in cache_data['set3'].items():
        for i in range(len(rows)):
            if "%s-%s" % (symbol, i) in combined:
                combined["%s-%s" % (symbol, i)] = {
                    **combined["%s-%s" % (symbol, i)],
                    **rows[i]
                }

    combined = list(combined.values())

    output_file = 'eijon-data.csv'
    # If single lookup, change output
    if args.lookup:
        output_file = 'eijon-data.%s.csv' % (args.lookup)

    # Output CSV
    with open(output_file, 'w') as csvfile:
        fieldnames = list(combined[0].keys())
        csvwrite = csv.DictWriter(csvfile, fieldnames=fieldnames)
        csvwrite.writeheader()

        for i in range(len(combined)):
            csvwrite.writerow(combined[i])


# Lookup data for symbol.  Unfortunately, the API only allows for limited
# number of fields, so we have to make multiple requests
def lookup_data(symbol, cache_data):

    # {"Methodology": "InterimSum"}
    found = lookup_set(
        'set1', [
            "TR.TotalRevenue.date",
            eikon.TR_Field("TR.TotalRevenue"), "TR.BankTotalRevenue.date",
            eikon.TR_Field("TR.BankTotalRevenue"),
            "TR.NetIncomeBeforeExtraItems.date",
            eikon.TR_Field("TR.NetIncomeBeforeExtraItems")
        ], symbol, {
            "SDate": 0,
            "EDate": -10,
            "Period": "LTM",
            "Curn": "USD",
            "CONVERTCODE": "YES"
        }, cache_data)

    if found:
        lookup_set(
            'set2', [
                "TR.NetIncome.date",
                eikon.TR_Field("TR.NetIncome"), "TR.TotalAssetsReported.date",
                eikon.TR_Field("TR.TotalAssetsReported"),
                "TR.CompanyMarketCap.date",
                eikon.TR_Field("TR.CompanyMarketCap")
            ], symbol, {
                "SDate": 0,
                "EDate": -10,
                "Period": "LTM",
                "Curn": "USD",
                "CONVERTCODE": "YES"
            }, cache_data)

        # lookup_set('set3', [
        #     "TR.TotalOperatingExpense", "TR.TotalAssetsReported",
        #     "TR.TotalEquity", "TR.CompanyMarketCap",
        #     "TR.CompanyMarketCap.date", "TR.EPSMean", "TR.EffectiveTaxRate"
        # ], symbol, cache_data)

        # Unsure how to get previous numbers
        lookup_set('set3', [
            "TR.CompanyName", "TR.CommonName", "TR.CompanyNumEmploy",
            "TR.CompanyNumEmployDate"
        ], symbol, {"CONVERTCODE": "YES"}, cache_data)

    return found


# Lookup.  Return true if found, otherise false
def lookup_set(set, fields, symbol, options, cache_data):
    symbol = symbol.upper()
    options = {
        "SDate": 0,
        "EDate": -12,
        "FRQ": "FQ",
        "Period": "LTM",
        "Curn": "USD",
        "CONVERTCODE": "YES"
    } if options is None else options

    # Check the cache
    non_found_cache = cache_data.get("not_found", [])
    if symbol in non_found_cache:
        print("[cache] Not found %s" % (symbol))
        return False

    if set not in cache_data:
        cache_data[set] = {}
    if symbol in cache_data[set]:
        print("[cache] Found %s" % (symbol))
        return True

    # Do lookup
    try:
        print("[lookup] %s for %s ..." % (set, symbol))
        dataframe, error = eikon.get_data(
            [symbol], fields, options, debug=True)

    except Exception as e:
        print(e)
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

        #inspect.getmembers(dataframe)
        #pprint(dataframe, indent=2)
        #pprint(dataframe.columns)

        # Rename columns
        columns = ["ticker"]
        for f in fields:
            if type(f) is dict:
                columns.append(next(iter(f)))
            else:
                columns.append(f)
        dataframe.columns = columns

        cache_data[set][symbol] = json.loads(
            dataframe.to_json(orient="records"))

        # Debug
        if args.debug:
            # pprint(dataframe)
            pprint(cache_data[set][symbol])

        save_cache(cache_data)
        return True


# Save cache
def save_cache(data):
    # If single look up dont save
    if args.lookup:
        return data

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

    # Reset the data cache (not the not_found)
    if args.reset_cache:
        print("Reseting data cache.")
        data = {"not_found": data["not_found"]}

    # If single look up dont use cache
    if args.lookup:
        data = {"not_found": []}

    return data


# Run main
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--debug", help="Helpful debugging", action="store_true")
    parser.add_argument(
        "--reset-cache", help="Reset cache of data.", action="store_true")
    parser.add_argument(
        "--skip-lookup", help="Skip lookup data step.", action="store_true")
    parser.add_argument("--lookup", help="Lookup a single symbol.")
    args = parser.parse_args()

    main()
