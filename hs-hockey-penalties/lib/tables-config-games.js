/**
 * Tables configuration for games table.
 */

const Sequelize = require('Sequelize');

module.exports = {
  models: {
    hs_hockey_penalty_games: {
      tableName: 'hs_hockey_penalty_games',
      modelName: 'games',
      fields: {
        id: { type: Sequelize.STRING(64), primaryKey: true },
        home_team_id: Sequelize.STRING(64),
        home_team_name: Sequelize.STRING(128),
        away_team_id: Sequelize.STRING(64),
        away_team_name: Sequelize.STRING(128),
        location: Sequelize.STRING(128),
        url: Sequelize.STRING(128),
        final_home_score: Sequelize.INTEGER(),
        final_away_score: Sequelize.INTEGER(),
        start: Sequelize.DATE(),
        subseason_id: Sequelize.STRING(64),
        subseason_name: Sequelize.STRING(64),
        season_id: Sequelize.STRING(64),
        season_name: Sequelize.STRING(64),
        league_season: Sequelize.STRING(64)
      },
      options: {
        indexes: [
          { fields: ['home_team_id'] },
          { fields: ['away_team_id'] },
          { fields: ['location'] },
          { fields: ['final_home_score'] },
          { fields: ['final_away_score'] },
          { fields: ['start'] },
          { fields: ['subseason_id'] },
          { fields: ['season_id'] }
        ]
      }
    }
  },
  parser: (parsed, original) => {
    let p = original;
    // This is just the year, but is technically a name
    p.season_name = original.season_name;

    // Convert to date
    p.start = new Date(original.start);

    // Ints
    p.final_home_score = parseInt(original.final_home_score, 10);
    p.final_away_score = parseInt(original.final_away_score, 10);

    return {
      games: p
    };
  }
};
