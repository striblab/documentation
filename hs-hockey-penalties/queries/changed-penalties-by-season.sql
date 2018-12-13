SELECT
  g.season_name,
  COUNT(gp.id) AS game_count,
  SUM(gp.all_penalties) AS total_penalties,
  AVG(gp.all_penalties) AS avg_penalties,
  SUM(gp.boarding_penalties) AS total_boarding_penalties,
  AVG(gp.boarding_penalties) AS avg_boarding_penalties,
  SUM(gp.checking_penalties) AS total_checking_penalties,
  AVG(gp.checking_penalties) AS avg_checking_penalties,
  SUM(gp.head_penalties) AS total_head_penalties,
  AVG(gp.head_penalties) AS avg_head_penalties,
  SUM(gp.nonhead_penalties) AS total_nonhead_penalties,
  AVG(gp.nonhead_penalties) AS avg_nonhead_penalties
FROM
  hs_hockey_penalty_games AS g
  INNER JOIN
    -- Penalty count for each game
    (
      SELECT
        games.id,
        COUNT(penalties.play_id) AS all_penalties,

        SUM(CASE
          WHEN penalties.penalty IN ('Boarding')
          THEN 1 ELSE 0
        END) AS boarding_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Checking from Behind')
          THEN 1 ELSE 0
        END) AS checking_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Head contact')
          THEN 1 ELSE 0
        END) AS head_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Boarding', 'Checking from Behind')
          THEN 1 ELSE 0
        END) AS nonhead_penalties
      FROM
        hs_hockey_penalty_games AS games
          LEFT JOIN hs_hockey_penalty_penalties AS penalties
            ON games.id = penalties.game_id
      GROUP BY
        games.id
    ) AS gp
    ON g.id = gp.id
GROUP BY
  g.season_name
ORDER BY
  g.season_name
;
