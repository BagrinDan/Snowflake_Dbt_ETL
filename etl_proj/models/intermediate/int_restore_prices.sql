{{ config(materialized="view") }}

WITH clean_types AS (
    SELECT
        transaction_id,
        items,
        TRY_TO_DOUBLE(price_per_unit) AS price_per_unit,
        TRY_TO_DOUBLE(quantities) AS quantities,
        TRY_TO_DOUBLE(total_spent) AS total_spent
    FROM {{ ref('int_restore_items') }}
    WHERE items NOT IN ('UNKNOWN', 'ERROR')
),

base AS (
    SELECT
        *,
        (CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END +
         CASE WHEN quantities IS NULL THEN 1 ELSE 0 END +
         CASE WHEN total_spent IS NULL THEN 1 ELSE 0 END) AS null_count
    FROM clean_types
),

restored AS (
    SELECT 
        transaction_id,
        items,

        CASE
            WHEN null_count >= 2 THEN NULL
            WHEN price_per_unit IS NULL THEN total_spent / NULLIF(quantities, 0)
            ELSE price_per_unit
        END AS price_per_unit,
        
        CASE
            WHEN null_count >= 2 THEN NULL
            WHEN quantities IS NULL THEN total_spent / NULLIF(price_per_unit, 0)
            ELSE quantities
        END AS quantities,

        CASE 
            WHEN null_count >= 2 THEN NULL
            WHEN total_spent IS NULL THEN price_per_unit * quantities
            ELSE total_spent
        END AS total_spent,

        null_count
    FROM base
)

SELECT
    transaction_id,
    items,
    price_per_unit,
    quantities,
    total_spent
FROM restored
WHERE null_count < 2