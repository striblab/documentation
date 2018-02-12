const Sequelize = require('sequelize');

if (!process.env.NICE_RIDE_YEAR) {
  throw 'Make sure to set NICE_RIDE_YEAR environment variable';
}

module.exports = {
  datetimeFormat: ['MM/DD/YYYY', 'M/D/YYYY', 'MM/DD/YYYY HH:mm:ss a'],
  parser: (parsed, original) => {
    let t = 'niceRideTerminals';
    parsed = parsed || {};
    parsed[t] = parsed[t] || {};

    parsed[t].year = process.env.NICE_RIDE_YEAR;
    parsed[t].terminal =
      original.terminal ||
      original.Terminal ||
      original.number ||
      original.Number ||
      original.id;
    parsed[t].station =
      original.Station || original.station || original.Name || original.name;
    parsed[t].latitude = original.Latitude || original.Lat || original.latitude;
    parsed[t].longitude =
      original.Longitude || original.Long || original.longitude;
    parsed[t].docks =
      original['NB docks'] ||
      original['Nb docks'] ||
      original['Nb Docks'] ||
      original['NB Docks'] ||
      original['Total docks'] ||
      original.NbDocks ||
      original.docks;
    parsed[t].notes = original.Notes || original.notes;

    return parsed;
  },
  models: {
    nice_ride_terminals: {
      modelName: 'niceRideTerminals',
      tableName: 'nice_ride_terminals',
      fields: {
        year: {
          input: 'additive-field',
          name: 'year',
          type: new Sequelize.INTEGER(),
          primaryKey: true
        },
        terminal: {
          input: 'Terminal',
          name: 'terminal',
          type: new Sequelize.STRING(16),
          primaryKey: true
        },
        station: {
          input: 'Station',
          name: 'station',
          type: new Sequelize.STRING()
        },
        latitude: {
          input: 'Lat',
          name: 'latitude',
          type: new Sequelize.FLOAT()
        },
        longitude: {
          input: 'Long',
          name: 'longitude',
          type: new Sequelize.FLOAT()
        },
        install_date: {
          input: 'Install date',
          name: 'install_date',
          type: new Sequelize.DATE()
        },
        docks: {
          input: 'Nb docks',
          name: 'docks',
          type: new Sequelize.INTEGER()
        },
        notes: {
          name: 'notes',
          type: new Sequelize.TEXT()
        }
      },
      // Options for defining a Sequelize model
      // See: http://sequelize.readthedocs.org/en/latest/docs/models-definition/#configuration
      options: {
        indexes: [
          {
            fields: ['year', 'terminal'],
            unique: true
          },
          {
            fields: ['terminal']
          },
          {
            fields: ['station']
          },
          {
            fields: ['latitude']
          },
          {
            fields: ['longitude']
          },
          {
            fields: ['install_date']
          },
          {
            fields: ['docks']
          }
        ]
      }
    }
  }
};
