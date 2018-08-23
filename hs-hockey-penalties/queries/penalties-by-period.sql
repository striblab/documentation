SELECT
  g.season_name,
  g.subseason_group,
  COUNT(g.id) AS game_count,
  SUM(g.all_penalty_count) AS penalty_count,
  SUM(g.all_penalty_count) / COUNT(g.id) AS penalty_per_game,

  SUM(g.first_period_penalty_count) AS first_period_penalty_count,
  SUM(g.first_period_penalty_count) / COUNT(g.id) AS first_period_penalty_per_game,

  SUM(g.second_period_penalty_count) AS second_period_penalty_count,
  SUM(g.second_period_penalty_count) / COUNT(g.id) AS second_period_penalty_per_game,

  SUM(g.third_period_penalty_count) AS third_period_penalty_count,
  SUM(g.third_period_penalty_count) / COUNT(g.id) AS third_period_penalty_per_game,

  SUM(g.overtime_penalty_count) AS overtime_penalty_count,
  SUM(CASE
    WHEN g.overtime_penalty_count > 0 THEN 1 ELSE 0
  END) AS overtime_penalty_game_count,
  SUM(g.overtime_penalty_count) /
    SUM(CASE
      WHEN g.overtime_penalty_count > 0 THEN 1 ELSE 0
    END)
    AS overtime_penalty_per_game
FROM
  hs_hockey_penalty_games AS g
GROUP BY
  g.season_name,
  g.subseason_group
ORDER BY
  g.season_name,
  g.subseason_group
;
