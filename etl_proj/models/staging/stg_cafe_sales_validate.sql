{{ config(materialized='view')}}


SELECT
    transaction_id,
    items,
    TRY_CAST(quantities AS Integer) as quantities,
    TRY_CAST(price_per_unit AS FLOAT) as price_per_unit,
    TRY_CAST(total_spent AS FLOAT) as total_spent,
    payment_method,
    location,
    TRY_CAST(transaction_date AS DATE) as transaction_date
FROM {{source('bronze', 'raw_cafe_sales')}}