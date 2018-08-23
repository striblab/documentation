SELECT
  g.season_name,
  AVG(gp.head_penalties) AS avg_head_penalties,
  AVG(gp.head_penalties_minor) AS avg_head_penalties_minor,
  AVG(gp.head_penalties_major) AS avg_head_penalties_major,
  AVG(gp.focused_head_penalties) AS avg_focused_head_penalties,
  AVG(gp.focused_head_penalties_minor) AS avg_focused_head_penalties_minor,
  AVG(gp.focused_head_penalties_major) AS avg_focused_head_penalties_major
FROM
  hs_hockey_penalty_games AS g
  INNER JOIN
    -- Penalty count for each game
    (
      SELECT
        games.id,
        COUNT(penalties.play_id) AS all_penalties,

        SUM(CASE
          WHEN penalties.penalty IN ('Blows to the Head', 'Head contact', 'Checking to Head/Neck', 'Head Butting', 'Illegal Check to the Head')
          THEN 1 ELSE 0
        END) AS head_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Blows to the Head', 'Head contact', 'Checking to Head/Neck', 'Head Butting', 'Illegal Check to the Head')
          AND penalties.severity = 'minor_penalty'
          THEN 1 ELSE 0
        END) AS head_penalties_minor,
        SUM(CASE
          WHEN penalties.penalty IN ('Blows to the Head', 'Head contact', 'Checking to Head/Neck', 'Head Butting', 'Illegal Check to the Head')
          AND penalties.severity = 'major_penalty'
          THEN 1 ELSE 0
        END) AS head_penalties_major,

        SUM(CASE
          WHEN penalties.penalty IN ('Head contact', 'Checking to Head/Neck', 'Illegal Check to the Head')
          THEN 1 ELSE 0
        END) AS focused_head_penalties,
        SUM(CASE
          WHEN penalties.penalty IN ('Head contact', 'Checking to Head/Neck', 'Illegal Check to the Head')
          AND penalties.severity = 'minor_penalty'
          THEN 1 ELSE 0
        END) AS focused_head_penalties_minor,
        SUM(CASE
          WHEN penalties.penalty IN ('Head contact', 'Checking to Head/Neck', 'Illegal Check to the Head')
          AND penalties.severity = 'major_penalty'
          THEN 1 ELSE 0
        END) AS focused_head_penalties_major
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
