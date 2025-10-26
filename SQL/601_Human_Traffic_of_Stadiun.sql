-- Write a solution to display the records with three or more rows with consecutive id's, 
-- and the number of people is greater than or equal to 100 for each.

--Table: Stadium
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | visit_date    | date    |
-- | people        | int     |
-- +---------------+---------+
-- visit_date is the column with unique values for this table.
-- Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
-- As the id increases, the date increases as well.

WITH q1 AS(
    SELECT s1.id, s1.visit_date, s1.people,
        COUNT(*) OVER (ORDER BY s1.id RANGE BETWEEN CURRENT ROW AND 2 FOLLOWING) AS following_cnt,
        COUNT(*) OVER (ORDER BY s1.id RANGE BETWEEN 2 PRECEDING AND CURRENT ROW) AS preceding_cnt,
        COUNT(*) OVER (ORDER BY s1.id RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS middle_cnt
    FROM Stadium s1
    WHERE s1.people >= 100
)
SELECT q.id, q.visit_date, q.people
FROM q1 q
WHERE q.following_cnt = 3 OR q.preceding_cnt = 3 OR q.middle_cnt = 3
ORDER BY q.id;

-- Another method using self-join
WITH consecutive_groups AS (
    SELECT id, visit_date, people,
           id - ROW_NUMBER() OVER (ORDER BY id) as group_id
    FROM Stadium 
    WHERE people >= 100
)
SELECT id, visit_date, people
FROM consecutive_groups
WHERE group_id IN (
    SELECT group_id
    FROM consecutive_groups
    GROUP BY group_id
    HAVING COUNT(*) >= 3
);
