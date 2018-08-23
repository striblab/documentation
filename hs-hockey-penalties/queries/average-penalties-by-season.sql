SELECT
  g.season_name,
  AVG(gp.all_penalties) AS avg_all_penalties,
  AVG(gp.changed_penalties) AS avg_changed_penalties,
  AVG(gp.not_changed_penalties) AS avg_not_changed_penalties,
  AVG(gp.minor_penalties) AS avg_minor_penalties,
  AVG(gp.major_penalties) AS avg_major_penalties
FROM
  hs_hockey_penalty_games AS g
  INNER JOIN
    -- Penalty count for each game
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
        END) AS double_penalties
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

