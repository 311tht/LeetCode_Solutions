--Find all numbers that appear at least three times consecutively.

-- Solution: JOIN the table to itself multiple times to check for consecutive entries
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l2.id = l1.id + 1 AND l2.num = l1.num
JOIN Logs l3 ON l3.id = l1.id + 2 AND l3.num = l1.num;

-- Alternative Solution: Use window functions to access previous rows
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT 
        num,
        LAG(num, 1) OVER (ORDER BY id) as prev_num,
        LAG(num, 2) OVER (ORDER BY id) as prev_prev_num
    FROM Logs
) t
WHERE num = prev_num AND num = prev_prev_num;

-- Another Alternative Solution: Use difference between row number and id to identify groups
WITH grouped_logs AS (
    SELECT 
        num,
        id - ROW_NUMBER() OVER (PARTITION BY num ORDER BY id) as group_id
    FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM grouped_logs
GROUP BY num, group_id
HAVING COUNT(*) >= 3;


