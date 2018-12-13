SELECT
  g.season_name,
  SUM(gp.cross_checking_penalties) AS sum_cross_checking_penalties,
  AVG(gp.cross_checking_penalties) AS avg_cross_checking_penalties,
  AVG(gp.cross_checking_penalties_minor) AS avg_cross_checking_penalties_minor,
  AVG(gp.cross_checking_penalties_major) AS avg_cross_checking_penalties_major,
  AVG(gp.roughing_penalties) AS avg_roughing_penalties,
  SUM(gp.roughing_penalties) AS sum_roughing_penalties,
  AVG(gp.roughing_penalties_minor) AS avg_roughing_penalties_minor,
  AVG(gp.roughing_penalties_major) AS avg_roughing_penalties_major
FROM
  hs_hockey_penalty_games AS g
  INNER JOIN
    -- Penalty count for each game
    (
      SELECT
        games.id,
        COUNT(penalties.play_id) AS all_penalties,

        SUM(CASE
          WHEN penalties.penalty IN ('Cross-Checking')
          THEN 1 ELSE 0
        END) AS cross_checking_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Cross-Checking')
          AND penalties.severity = 'minor_penalty'
          THEN 1 ELSE 0
        END) AS cross_checking_penalties_minor,
        SUM(CASE
          WHEN penalties.penalty IN ('Cross-Checking')
          AND penalties.severity = 'major_penalty'
          THEN 1 ELSE 0
        END) AS cross_checking_penalties_major,

        SUM(CASE
          WHEN penalties.penalty IN ('Roughing')
          THEN 1 ELSE 0
        END) AS roughing_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Roughing')
          AND penalties.severity = 'minor_penalty'
          THEN 1 ELSE 0
        END) AS roughing_penalties_minor,
        SUM(CASE
          WHEN penalties.penalty IN ('Roughing')
          AND penalties.severity = 'major_penalty'
          THEN 1 ELSE 0
        END) AS roughing_penalties_major
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
