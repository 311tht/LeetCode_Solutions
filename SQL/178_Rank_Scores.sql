-- Write a solution to find the rank of the scores.
-- The ranking should be calculated according to the following rules:

-- 1. The scores should be ranked from the highest to the lowest.
-- 2. If there is a tie between two scores, both should have the same ranking.
-- 3. After a tie, the next ranking number should be the next consecutive integer value.
--    In other words, there should be no holes between ranks.

-- Solution using DENSE_RANK()
SELECT score, DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores;

-- Alternative solution without using DENSE_RANK()
-- Run subquery for each row so can slow down large datasets
SELECT s1.score, 
       (SELECT COUNT(DISTINCT s2.score) 
        FROM Scores s2 
        WHERE s2.score >= s1.score) AS 'rank'
FROM Scores s1
ORDER BY s1.score DESC;

-- Another alternative solution using CTE
with cte as (
select s2.score ,count(distinct s1.score) as rk
from scores s1 ,scores s2 
where s1.score >=s2.score 
group by s2.score )

select s.score,rk as 'rank'
from cte c ,scores s 
where c.score =s.score 
order by score desc 
