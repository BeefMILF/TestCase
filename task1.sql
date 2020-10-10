-- Mean Average
SELECT
       round(sum(marketing_amount)) / count(*) as mean
FROM orders;


-- Median
WITH cte AS (
    SELECT
           marketing_amount,
           row_number() over () rn,
           count(marketing_amount) over () cnt
    FROM orders )
SELECT marketing_amount
FROM cte
WHERE rn = cnt/2;


-- Mode
with cte AS (
    SELECT
           marketing_amount,
           count(marketing_amount)
    FROM orders
    GROUP BY marketing_amount
    ORDER BY count(*) DESC
    )
SELECT marketing_amount
FROM cte
LIMIT 1;