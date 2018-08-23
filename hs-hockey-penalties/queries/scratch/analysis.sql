-- Just some random queries


-- Count games by sub-season and start and end dates of games
SELECT
  g.season_name,
	g.subseason_name,
	COUNT(*) AS game_count,
	MIN(g.start) AS first_game,
	MAX(g.start) AS last_game
FROM
	hs_hockey_penalty_games AS g
GROUP BY
  g.season_name,
	g.subseason_name
ORDER BY
  g.season_name,
	g.subseason_name
;

-- Review penalty names
SELECT
  p.penalty,
  COUNT(*) AS penalty_count
FROM
  hs_hockey_penalty_penalties AS p
GROUP BY
  p.penalty
ORDER BY
  p.penalty
;

-- Severity penalty names
SELECT
  p.severity,
  COUNT(*) AS severity_count
FROM
  hs_hockey_penalty_penalties AS p
GROUP BY
  p.severity
ORDER BY
  p.severity
;

-- Number of the changed penalties by sub season group
SELECT
  g.season_name,
	g.subseason_group,
	COUNT(DISTINCT g.id) AS game_count,

  -- All penalties
	COUNT(p.play_id) AS penalty_count,
  COUNT(p.play_id) / COUNT(DISTINCT g.id) AS penalties_per_game,

  -- Change penalties
  SUM(CASE
    WHEN p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact') THEN 1
    ELSE 0
  END) AS changed_penalty_count,
  SUM(CASE
    WHEN p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact') THEN 1
    ELSE 0
  END) / COUNT(DISTINCT g.id) AS changed_penalties_per_game,

  -- Minor penalties
  SUM(CASE
    WHEN p.severity = 'minor_penalty' THEN 1
    ELSE 0
  END) AS minor_penalty_count,
  SUM(CASE
    WHEN p.severity = 'minor_penalty' THEN 1
    ELSE 0
  END) / COUNT(DISTINCT g.id) AS minor_penalties_per_game,

  -- Major penalties
  SUM(CASE
    WHEN p.severity = 'major_penalty' THEN 1
    ELSE 0
  END) AS major_penalty_count,
  SUM(CASE
    WHEN p.severity = 'major_penalty' THEN 1
    ELSE 0
  END) / COUNT(DISTINCT g.id) AS major_penalties_per_game
FROM
	hs_hockey_penalty_games AS g
    LEFT JOIN hs_hockey_penalty_penalties AS p
      ON g.id = p.game_id
GROUP BY
  g.season_name,
  g.subseason_group
ORDER BY
  g.subseason_name,
  g.subseason_group
;


SELECT
  g.season_name,
	COUNT(DISTINCT g.id) AS game_count,

  -- All penalties
	COUNT(p.play_id) AS all_penalty_count,
  COUNT(p.play_id) / COUNT(DISTINCT g.id) AS all_penalties_per_game,

  -- Change penalties
  SUM(CASE
    WHEN p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact') THEN 1
    ELSE 0
  END) AS all_changed_penalty_count,
  SUM(CASE
    WHEN p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact') THEN 1
    ELSE 0
  END) / COUNT(DISTINCT g.id) AS all_changed_penalties_per_game,

  -- Change penalties for regular
  SUM(CASE
    WHEN g.subseason_group = 'regular'
      AND p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
      THEN 1
    ELSE 0
  END) AS regular_changed_penalty_count,
  SUM(CASE
    WHEN g.subseason_group = 'regular'
      AND p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
      THEN 1
    ELSE 0
  END) / SUM(CASE
    WHEN g.subseason_group = 'regular' THEN 1
    ELSE 0
  END) AS regular_changed_penalties_per_game,

  -- Change penalties for playoffs
  SUM(CASE
    WHEN g.subseason_group = 'playoffs'
      AND p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
      THEN 1
    ELSE 0
  END) AS playoffs_changed_penalty_count,
  SUM(CASE
    WHEN g.subseason_group = 'playoffs'
      AND p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
      THEN 1
    ELSE 0
  END) / SUM(CASE
    WHEN g.subseason_group = 'playoffs' THEN 1
    ELSE 0
  END) AS playoffs_changed_penalties_per_game,

  -- Change penalties for tournament
  SUM(CASE
    WHEN g.subseason_group = 'tournament'
      AND p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
      THEN 1
    ELSE 0
  END) AS tournament_changed_penalty_count,
  SUM(CASE
    WHEN g.subseason_group = 'tournament'
      AND p.penalty IN ('Checking from Behind', 'Boarding', 'Head contact')
      THEN 1
    ELSE 0
  END) / SUM(CASE
    WHEN g.subseason_group = 'tournament' THEN 1
    ELSE 0
  END) AS tournament_changed_penalties_per_game
FROM
	hs_hockey_penalty_games AS g
    LEFT JOIN hs_hockey_penalty_penalties AS p
      ON g.id = p.game_id
GROUP BY
  g.season_name
ORDER BY
  g.season_name
;
