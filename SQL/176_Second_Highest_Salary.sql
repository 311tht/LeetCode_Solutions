--Write a solution to find the second highest distinct salary from the Employee table.
--If there is no second highest salary, return null (return None in Pandas).

-- The query result format is in the following example.
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

-- Another approach
SELECT
    (CASE WHEN COUNT(DISTINCT salary) < 2 THEN null
         ELSE (
            SELECT salary
            FROM (
                SELECT DISTINCT salary
                FROM Employee
                ORDER BY salary DESC
                LIMIT 2
            )
            ORDER BY salary
            LIMIT 1
         )
         END) AS SecondHighestSalary
FROM Employee