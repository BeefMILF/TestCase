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