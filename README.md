# TestCase
*sql test scripts*

*All tables for tests were generated with [**mockaroo**](https://www.mockaroo.com/)*
In order to generate repeated data, used **pandas** resampling strategy. 

---

## task 1 - test result

```sql
-- Mean Average
SELECT
       round(sum(marketing_amount)) / count(*) as mean
FROM orders;
```

![](https://github.com/BeefMILF/solidTestCase/blob/master/res/task1.1.jpg?raw=true)

```sql
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
```

![](https://github.com/BeefMILF/solidTestCase/blob/master/res/task1.2jpg?raw=true)

```sql
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
```

![](https://github.com/BeefMILF/solidTestCase/blob/master/res/task1.3.jpg?raw=true)

## task 2 - test result

```sql
SELECT

       t.status,       -- Статус транзакции
       P.name,         -- Название платежного провайдера
       C.iso_code,     -- Валюта
       Pc.bin_country, -- Страна по бину

       -- Тип тразакции
       -- если статус = 1, то REFUND или CHARGEBACK
       CASE WHEN r.refund_status = 1
           THEN 'REFUND'
           ELSE
               CASE WHEN cb.chb_status = 1
                    THEN 'CHARGEBACK'
               END
           END AS transaction_type

       -- Сумма ?

FROM transactions t
    LEFT JOIN "Currencies" C
        on t.currency_id = C.Id
    LEFT JOIN "Psp" P
        on t.psp_id = P."Id"
    LEFT JOIN "Payment_credentials" Pc
        on t.payment_credentials_id = Pc.id
    LEFT JOIN refunds r
        on t.order_id = r.order_id
    LEFT JOIN chargebacks cb
        on t.order_id = cb.order_id
```

![](https://github.com/BeefMILF/solidTestCase/blob/master/res/task2.jpg?raw=true)

## task 3 - test result

```sql
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
```

![](https://github.com/BeefMILF/solidTestCase/blob/master/res/task3.jpg?raw=true)

## task 4 - test result

*Overall 50 rows. Max ratio equals 0.04 while others just 0.02.*  

```sql
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
```

![](https://github.com/BeefMILF/solidTestCase/blob/master/res/task4.jpg?raw=true)
