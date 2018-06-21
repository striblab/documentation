/**
 * Getting penalty data from Sports Engine
 */
const querystring = require('querystring');
const fetch = require('node-fetch');
const _ = require('lodash');
const fs = require('fs-extra');
const path = require('path');
const crypto = require('crypto');
const csv = require('fast-csv');
require('dotenv').load();

// Cache location
let cacheDir = path.join(__dirname, '..', '.sports-engine-cache');

// CSV streams
let outputDir = path.join(__dirname, '..', 'build-data');
fs.ensureDirSync(outputDir);
let penaltyOutput = fs.createWriteStream(path.join(outputDir, 'penalties.csv'));
let penaltyStream = csv.createWriteStream({ headers: true });
penaltyStream.pipe(penaltyOutput);
let gameOutput = fs.createWriteStream(path.join(outputDir, 'games.csv'));
let gameStream = csv.createWriteStream({ headers: true });
gameStream.pipe(gameOutput);

// Need to wrap asyncs
async function main() {
  // Make sure cache dir is there
  try {
    await fs.mkdirp(cacheDir);
  }
  catch (e) {
    throw e;
  }

  // Get list of leagues for a site? to get league ID
  //let leagues = await nginFetch('leagues', { site_id: 268 });
  //console.log(leagues);
  let leagueID = 301;

  // Get seasons for league
  let seasons = await nginFetch('league_instances', { league_id: leagueID });

  // Odd season with name 1944-1945
  seasons = _.filter(seasons, s => {
    return s.season_name.match(/^20.*/);
  });

  // Get IDs
  let seasonIDs = seasons.map(s => s.season_id);

  // Go through each season
  for (const seasonID of seasonIDs) {
    // Get season details to get list of subseasons (regular, playoffs, ...)
    let seasonInfo = await nginFetch(`seasons/${seasonID}`);
    for (const season of seasonInfo.subseasons) {
      // Get games.  This call can take a while.
      let games = await nginFetchPages('games', {
        subseason_id: season.id,
        per_page: 100
      });
      if (!games || !games.length) {
        console.error(`No games for season ${seasonInfo.name}`);
      }

      // Go through each game
      for (const game of games) {
        // Write game rows
        gameStream.write(gameRow(game, season, seasonInfo));

        // Then get the plays for each game
        let plays = await nginFetch('plays', {
          game_id: game.id
        });

        // Get plays that are penalty.  Note that play_actions
        // have more of the details
        // TODO: Find time of penalty, might be just based on type
        // and severity
        let penalties = _.filter(plays, { play_type: 'Penalty' });

        // Write rows
        penalties.forEach(p => {
          if (!p.play_actions) {
            console.error('No play actions found.');
          }
          let r = penaltyRow(p, game, season, seasonInfo);
          if (r) {
            penaltyStream.write(r);
          }
        });
      }
    }
  }

  // Stop streams
  penaltyStream.end();
  gameStream.end();

  // Keep open for debugger
  //console.error('Keeping open for debugger ... (ctrl+c)');
  //setTimeout(() => null, 9999999);
}

// Go
main();

// Create penalty row
function penaltyRow(penalty, game, subseason, season) {
  let p = _.find(penalty.play_actions, { type: 'penalty' });
  let severity = _.find(penalty.play_actions, a => a.type.match(/.*_penalty/i));
  let powerPlay = _.find(penalty.play_actions, a =>
    a.type.match(/.*power_play/i)
  );

  if (!p) {
    console.error(`Unable to find penalty details for ${penalty.id}`);
    return false;
  }

  let row = {
    game_id: game.id,

    // Penalty
    play_id: penalty.id,
    penalty: p.infraction_type,
    severity: severity ? severity.type : null,
    power_play: powerPlay ? powerPlay.type : null,
    period: p.time_interval,
    clock_time: p.clock_time,
    // This is the value that is showed in the web page
    clock_time_string: penalty.clock_time_string,
    offensive_team_id: p.off_team_id,
    defensive_team_id: p.def_team_id,
    skater_id: p.skater_id

    // This doesn't seem to be the actual time of the incident
    //created: penalty.created_at,

    // These don't seem to be populated
    //at_time_home_team_score: penalty.home_team_score,
    //at_time_away_team_score: penalty.away_team_score,
  };

  return row;
}

// Create game row
function gameRow(game, subseason, season) {
  let row = {
    id: game.id,
    home_team_id: game.home_team_id,
    home_team_name: game.home_team_name,
    away_team_id: game.away_team_id,
    away_team_name: game.away_team_name,
    // This seems to always be the same
    //game_host: game.host_name,
    location: game.location,
    url: game.game_show_url,
    final_home_score: game.home_team_score_api,
    final_away_score: game.away_team_score_api,
    start: game.start_date_time,

    // Season
    subseason_id: subseason.id,
    subseason_name: subseason.name,
    season_id: season.id,
    season_name: season.name,

    // League
    league_season: game.league_info
  };

  return row;
}

// Fetch multiple pages
async function nginFetchPages(...args) {
  args[1] = args[1] || {};
  args[1].page = 1;
  let collected = [];

  try {
    // TODO: There should be a better way
    while (args[1].page < 100) {
      let r = await nginFetch(...args);
      if (!r || !r.length) {
        break;
      }

      collected = collected.concat(r);
      args[1].page++;
    }
  }
  catch (e) {
    // Not sure exactly how pages are managed, but for now just
    // assuming if we are not page one, then we are done
    if (args[1] === 1) {
      throw e;
    }
  }

  return collected;
}

// Wrapper around sports engine call
// curl -X GET -H "NGIN-API-VERSION: 0.1" -H "Authorization: Bearer ACCESS_TOKEN" -H "Accept: application/json" "https://api.sportngin.com/games?subseason_id=291621&page=1"
async function nginFetch(endpoint, query = {}, method = 'GET', cache = true) {
  let url = `https://api.sportngin.com/${endpoint}?${querystring.stringify(
    query
  )}`;
  let responseCache = await getCache(url);

  // If cache, serve that
  if (responseCache && cache) {
    return responseCache;
  }

  // Fetch
  let response;
  try {
    response = await fetch(url, {
      method: method,
      headers: {
        'NGIN-API-VERSION': '0.1',
        'NGIN-API-TOKEN': `${process.env.SPORTS_ENGINE_API_KEY}`,
        //Authorization: `Bearer ${process.env.SPORTS_ENGINE_API_KEY}`,
        Accept: 'application/json'
      }
    })
      .then(response => {
        if (response.status >= 300) {
          throw new Error(
            `Issue making request, received a ${response.status} from ${url}`
          );
        }

        return response.json();
      })
      .catch(error => {
        throw error;
      });
  }
  catch (e) {
    console.error('Error with nginFetch');
    console.error(url);
    console.error(e);
  }

  // Save cache if there was a response
  if (response) {
    saveCacheFile(response, url);
    return response;
  }
}

// Get cache
async function getCache(id) {
  let name = crypto
    .createHash('md5')
    .update(id)
    .digest('hex');
  let filePath = path.join(cacheDir, name);

  try {
    if (await fs.exists(filePath)) {
      return JSON.parse(await fs.readFile(filePath, 'utf-8'));
    }
    else {
      return false;
    }
  }
  catch (e) {
    console.error(e);
    return false;
  }
}

// Save cache file
async function saveCacheFile(data, id) {
  let name = crypto
    .createHash('md5')
    .update(id)
    .digest('hex');
  let filePath = path.join(cacheDir, name);

  console.error(`Caching ${id}`);
  try {
    return await fs.writeFile(filePath, JSON.stringify(data));
  }
  catch (e) {
    throw e;
  }
}
