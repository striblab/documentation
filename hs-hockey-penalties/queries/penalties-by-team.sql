SELECT
  g.season_name,
  teams.name,
  COUNT(p.play_id) AS penalty_count,
  COUNT(DISTINCT g.id) AS game_count,
  COUNT(p.play_id) / COUNT(DISTINCT g.id) AS penalties_per_game
FROM
  hs_hockey_penalty_penalties AS p
	  LEFT JOIN hs_hockey_penalty_games AS g
      ON g.id = p.game_id
    LEFT JOIN (
      SELECT
        t.home_team_id AS id,
        t.home_team_name AS name
      FROM
        hs_hockey_penalty_games AS t
      GROUP BY
        t.home_team_id
    ) AS teams
      ON teams.id = p.offensive_team_id
GROUP BY
  g.season_name,
  teams.name
HAVING
  COUNT(DISTINCT g.id) > 10
ORDER BY
  g.season_name,
  penalties_per_game DESC
;
