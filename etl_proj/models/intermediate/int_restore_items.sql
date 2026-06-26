{{ config(materialized="view")}}

SELECT
    transaction_id,
    CASE 
        -- Cheking if name is valid
        WHEN items NOT IN ('UNKNOWN', 'ERROR') then items

        -- If name is not valid, then restore base on unique price
        WHEN price_per_unit = '1.0' then 'Cookie'
        WHEN price_per_unit = '5.0' then 'Salad'
        WHEN price_per_unit = '1.5' then 'Tea'

        -- If name and price are not valid - then null
        ELSE null
    END as items,

    quantities,
    CASE
        WHEN items = 'Cake' then '3.0'
        WHEN items = 'Coffee' then '2.0'
        WHEN items = 'Cookie' then '1.0'
        WHEN items = 'Juice' then '3.0'
        WHEN items = 'Salad' then '5.0'
        WHEN items = 'Sandwich' then '4.0'
        WHEN items = 'Smoothie' then '4.0'
        WHEN items = 'Tea' then '1.5'
    END AS price_per_unit,
    
    total_spent,
    payment_method,
    location,
    transaction_date
FROM {{ ref('stg_cafe_sales')}}
WHERE NOT (
    items IN ('UNKNOWN', 'ERROR')
    AND (price_per_unit NOT IN ('1.0', '1.5', '5.0') OR price_per_unit is NULL)
)
