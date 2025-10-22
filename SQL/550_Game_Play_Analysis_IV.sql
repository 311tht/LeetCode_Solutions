--Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places.
--In other words, you need to determine the number of players who logged in on the day immediately following their initial login,
--and divide it by the number of total players.

--Table: Activity

--+--------------+---------+
--| Column Name  | Type    |
--+--------------+---------+
--| player_id    | int     |
--| device_id    | int     |
--| event_date   | date    |
--| games_played | int     |
--+--------------+---------+

--The table has no primary key and may contain duplicate rows.
SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id
  )

--CTE method
WITH first_logins AS(
    SELECT player_id, MIN(event_date) AS first_login 
    FROM Activity 
    GROUP BY player_id
),
consecutive_logins AS(
    SELECT DISTINCT a.player_id
    FROM Activity AS a
    JOIN first_logins f ON a.player_id = f.player_id
    WHERE a.event_date = DATE_ADD(f.first_login, INTERVAL 1 DAY)
)
SELECT ROUND(COUNT(DISTINCT c.player_id) / COUNT(DISTINCT f.player_id), 2) AS fraction
FROM first_logins AS f
LEFT JOIN consecutive_logins c ON f.player_id = c.player_id

--CTE window function method
WITH player_stats AS (
    SELECT 
        player_id,
        MIN(event_date) OVER (PARTITION BY player_id) as first_login,
        LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) as next_login
    FROM Activity
)
SELECT ROUND(
    COUNT(DISTINCT CASE 
        WHEN DATEDIFF(next_login, first_login) = 1 THEN player_id 
    END) / COUNT(DISTINCT player_id), 2
) AS fraction
FROM player_stats;                 
