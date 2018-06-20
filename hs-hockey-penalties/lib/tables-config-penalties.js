/**
 * Tables configuration for penalties table.
 */

const Sequelize = require('Sequelize');

module.exports = {
  models: {
    hs_hockey_penalty_penalties: {
      tableName: 'hs_hockey_penalty_penalties',
      modelName: 'penalties',
      fields: {
        play_id: { type: Sequelize.STRING(64), primaryKey: true },
        game_id: Sequelize.STRING(64),
        penalty: Sequelize.STRING(64),
        severity: Sequelize.STRING(64),
        power_play: Sequelize.STRING(64),
        period: Sequelize.STRING(4),
        clock_time: Sequelize.STRING(16),
        clock_time_minutes: Sequelize.DECIMAL(10, 3),
        clock_time_string: Sequelize.STRING(16),
        clock_time_string_minutes: Sequelize.DECIMAL(10, 3),
        offensive_team_id: Sequelize.STRING(64),
        defensive_team_id: Sequelize.STRING(64),
        skater_id: Sequelize.STRING(64)
      },
      options: {
        indexes: [
          { fields: ['game_id'] },
          { fields: ['penalty'] },
          { fields: ['severity'] },
          { fields: ['power_play'] },
          { fields: ['period'] },
          { fields: ['clock_time'] },
          { fields: ['clock_time_minutes'] },
          { fields: ['period', 'clock_time_minutes'] },
          { fields: ['clock_time_string'] },
          { fields: ['clock_time_string_minutes'] },
          { fields: ['period', 'clock_time_string_minutes'] },
          { fields: ['offensive_team_id'] },
          { fields: ['defensive_team_id'] },
          { fields: ['skater_id'] }
        ]
      }
    }
  },
  parser: (parsed, original) => {
    let p = original;

    // Parse minutes
    if (original.clock_time) {
      p.clock_time_minutes =
        parseInt(original.clock_time.split(':')[0], 10) +
        parseInt(original.clock_time.split(':')[1], 10) / 60;
    }
    if (original.clock_time_string) {
      p.clock_time_string_minutes =
        parseInt(original.clock_time_string.split(':')[0], 10) +
        parseInt(original.clock_time_string.split(':')[1], 10) / 60;
    }

    // General clean up of penalty name
    p.penalty = p.penalty
      .replace(/[^a-z/()]+/im, ' ')
      .replace(/\s+/m, ' ')
      .trim();

    // Standardize some penalty names
    // if (p.penalty === 'Blows to the Head') {
    //   p.penalty = 'Head Contact';
    // }
    if (p.penalty === 'High Sticking') {
      p.penalty = 'High-Sticking';
    }
    if (p.penalty === 'Too Many Men') {
      p.penalty = 'Too Many Men on the Ice';
    }
    if (p.penalty === 'Cross Checking') {
      p.penalty = 'Cross-Checking';
    }
    if (p.penalty === 'Goalkeeper Interference') {
      p.penalty = 'Goaltender Interference';
    }

    return {
      penalties: p
    };
  }
};
