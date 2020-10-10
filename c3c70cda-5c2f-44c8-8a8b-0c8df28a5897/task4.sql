WITH cte AS (
    SELECT
           count(*) over () total_cnt,
           o.customer_email ce,
           p.cardnumber cn
    FROM orders o
        LEFT JOIN "Payment_credentials" p
            ON o.payment_credentials_id = p.id

)
SELECT
       row_number() over () rn, -- номер заказа в рамках email, card
       cast(count(*) as numeric) / total_cnt ratio
FROM cte
GROUP BY ce, cn, total_cnt;