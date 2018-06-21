/**
 * Run some random table aggregations, to hard-code some data
 * in the table
 */

// Dependencies
const path = require('path');
const mysql = require('mysql');
require('dotenv').load();

// Connect to DB
const db = mysql.createConnection(process.env.HS_HOCKEY_DATABASE_URI);
db.connect();

// Go through files
async function main() {
  await Promise.all(
    [
      `
  UPDATE
    hs_hockey_penalty_games AS g
    INNER JOIN
      (
        SELECT
          games.id,
          COUNT(penalties.play_id) AS all_penalties,

          SUM(CASE
            WHEN penalties.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
            THEN 1 ELSE 0
          END) AS changed_penalties,
          SUM(CASE
            WHEN penalties.penalty NOT IN ('Checking from Behind', 'Boarding', 'Head contact')
            THEN 1 ELSE 0
          END) AS not_changed_penalties,

          SUM(CASE
            WHEN penalties.severity = 'minor_penalty'
            THEN 1 ELSE 0
          END) AS minor_penalties,
          SUM(CASE
            WHEN penalties.severity = 'major_penalty'
            THEN 1 ELSE 0
          END) AS major_penalties,
          SUM(CASE
            WHEN penalties.severity = 'misconduct_penalty'
            THEN 1 ELSE 0
          END) AS misconduct_penalties,
          SUM(CASE
            WHEN penalties.severity = 'double_minor_penalty'
            THEN 1 ELSE 0
          END) AS double_minor_penalties,

          SUM(CASE
            WHEN penalties.period = '1'
            THEN 1 ELSE 0
          END) AS first_period_penalties,
          SUM(CASE
            WHEN penalties.period = '2'
            THEN 1 ELSE 0
          END) AS second_period_penalties,
          SUM(CASE
            WHEN penalties.period = '3'
            THEN 1 ELSE 0
          END) AS third_period_penalties,
          SUM(CASE
            WHEN penalties.period IN ('4', '5', '6', '7', '8', '9')
            THEN 1 ELSE 0
          END) AS overtime_penalties,

          SUM(CASE
            WHEN penalties.period = '1'
              AND penalties.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
            THEN 1 ELSE 0
          END) AS first_period_changed_penalties,
          SUM(CASE
            WHEN penalties.period = '2'
            AND penalties.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
            THEN 1 ELSE 0
          END) AS second_period_changed_penalties,
          SUM(CASE
            WHEN penalties.period = '3'
            AND penalties.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
            THEN 1 ELSE 0
          END) AS third_period_changed_penalties,
          SUM(CASE
            WHEN penalties.period IN ('4', '5', '6', '7', '8', '9')
            AND penalties.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
            THEN 1 ELSE 0
          END) AS overtime_changed_penalties
        FROM
          hs_hockey_penalty_games AS games
            LEFT JOIN hs_hockey_penalty_penalties AS penalties
              ON games.id = penalties.game_id
        GROUP BY
          games.id
      ) AS gp
      ON g.id = gp.id
  SET
    g.all_penalty_count = gp.all_penalties,
    g.changed_penalty_count = gp.changed_penalties,
    g.not_changed_penalty_count = gp.not_changed_penalties,
    g.minor_penalty_count = gp.minor_penalties,
    g.major_penalty_count = gp.major_penalties,
    g.misconduct_penalty_count = gp.misconduct_penalties,
    g.double_minor_penalty_count = gp.double_minor_penalties,
    g.first_period_penalty_count = gp.first_period_penalties,
    g.second_period_penalty_count = gp.second_period_penalties,
    g.third_period_penalty_count = gp.third_period_penalties,
    g.overtime_penalty_count = gp.overtime_penalties,
    g.first_period_changed_penalty_count = gp.first_period_changed_penalties,
    g.second_period_changed_penalty_count = gp.second_period_changed_penalties,
    g.third_period_changed_penalty_count = gp.third_period_changed_penalties,
    g.overtime_changed_penalty_count = gp.overtime_changed_penalties
    `
    ].map(sql => {
      return new Promise((resolve, reject) => {
        db.query(sql, function(error, results) {
          if (error) {
            return reject(error);
          }

          console.error(`Finished running: \n${sql}\n\n`);
          resolve();
        });
      });
    })
  ).catch(error => {
    db.end();
    throw new Error(error);
  });

  db.end();
}

main();
