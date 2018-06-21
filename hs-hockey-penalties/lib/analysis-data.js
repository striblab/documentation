/**
 * Read files from queries and create JSON for output
 */

// Dependencies
const path = require('path');
const fs = require('fs-extra');
const mysql = require('mysql');
const glob = require('glob');
require('dotenv').load();

// Connect to DB
const db = mysql.createConnection(process.env.HS_HOCKEY_DATABASE_URI);
db.connect();

// Output directory
let outputDir = path.join(__dirname, '..', 'build-data');
fs.ensureDirSync(outputDir);

// Find SQL files
glob(path.join(__dirname, '..', 'queries', '*.sql'), async (error, files) => {
  if (error) {
    db.end();
    throw new Error(error);
  }
  if (!files || !files.length) {
    db.end();
    throw new Error('Unable to find any SQL files.');
  }

  // Go through files
  await Promise.all(
    files.map(f => {
      let sql = fs.readFileSync(f, 'utf-8');
      let output = path.join(outputDir, `${path.basename(f, '.sql')}.json`);
      console.error(`Reading and executing: ${f}`);

      return new Promise((resolve, reject) => {
        db.query(sql, function(error, results) {
          if (error) {
            return reject(error);
          }

          console.error(`Writing: ${output}`);
          fs.writeFileSync(output, JSON.stringify(results));
          resolve();
        });
      });
    })
  ).catch(error => {
    db.end();
    throw new Error(error);
  });

  db.end();
});
