const Sequelize = require('sequelize');
const tablesUtil = require('tables/lib/utils.js');

if (!process.env.NICE_RIDE_YEAR) {
  throw 'Make sure to set NICE_RIDE_YEAR environment variable';
}

let datetimeFormat = [
  'MM/DD/YYYY HH:mm',
  'MM/DD/YYYY H:mm',
  'M/D/YYYY HH:mm',
  'M/D/YYYY H:mm'
  //'M/D/YY HH:mm',
  //'MM/DD/YYYY HH:mm',
  //'MM/DD/YY HH:mm'
];

module.exports = {
  datetimeFormat: datetimeFormat,
  parser: (parsed, original) => {
    let t = 'niceRideTrips';
    parsed = parsed || {};
    parsed[t] = parsed[t] || {};

    parsed[t].year = process.env.NICE_RIDE_YEAR;
    parsed[t].row_id = original.line_number;
    // These should be auto parsed ?
    parsed[t].start = tablesUtil.toDateTime(
      original['Start date'],
      datetimeFormat
    );
    parsed[t].end = tablesUtil.toDateTime(original['End date'], datetimeFormat);
    parsed[t].start_id =
      original['Start station number'] || original['Start terminal'];
    parsed[t].end_id =
      original['End station number'] || original['End terminal'];
    parsed[t].account = original['Account type'];
    parsed[t].duration_seconds = original['Total duration (ms)']
      ? original['Total duration (ms)'] / 1000
      : original['Total duration (Seconds)'] ||
        original['Total duration (seconds)'];

    if (!parsed[t].start) {
      console.log(parsed, original);
    }

    return parsed;
  },
  models: {
    nice_ride_trips: {
      modelName: 'niceRideTrips',
      tableName: 'nice_ride_trips',
      fields: {
        year: {
          name: 'year',
          type: new Sequelize.INTEGER(),
          primaryKey: true
        },
        row_id: {
          name: 'row_id',
          type: new Sequelize.INTEGER(),
          primaryKey: true
        },
        start: {
          name: 'start',
          type: new Sequelize.DATE()
        },
        start_id: {
          name: 'start_id',
          type: new Sequelize.STRING(16)
        },
        end: {
          name: 'end',
          type: new Sequelize.DATE()
        },
        end_id: {
          name: 'end_id',
          type: new Sequelize.STRING(16)
        },
        account: {
          name: 'account',
          type: new Sequelize.STRING(32)
        },
        duration_seconds: {
          name: 'duration_seconds',
          type: new Sequelize.FLOAT()
        },
        notes: {
          name: 'notes',
          type: new Sequelize.TEXT()
        }
      },
      options: {
        indexes: [
          {
            fields: ['year', 'row_id'],
            unique: true
          },
          {
            fields: ['year']
          },
          {
            fields: ['row_id']
          },
          {
            fields: ['start']
          },
          {
            fields: ['start_id']
          },
          {
            fields: ['end']
          },
          {
            fields: ['end_id']
          },
          {
            fields: ['account']
          }
        ]
      }
    }
  }
};
