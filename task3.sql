SELECT
       o.customer_email,  -- ТОП 5 имейлов по количеству чарджбеков
       count(o.customer_email) cnt,       -- количество чарджбеков
       sum(o.marketing_amount) / 100 summ -- сумму чарджбеков в долларах
FROM orders o
INNER JOIN chargebacks c on o.id = c.order_id
WHERE c.dispute_date > CURRENT_DATE - interval '1 month' -- последних ~30 дней
GROUP BY o.customer_email
ORDER BY cnt desc
LIMIT 5
;