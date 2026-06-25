{{ config(materialized='view')}}


SELECT
    transaction_id,
    items,
    quantities,
    price_per_unit,
    total_spent,
    payment_method,
    location,
    transaction_date
FROM {{ source('bronze', 'raw_cafe_sales')}}
