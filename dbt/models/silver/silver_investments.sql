{{ config(
    materialized='incremental',
    unique_key='investment_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH standardized_data AS (
    SELECT
        investment_id,
        member_id,
        CASE
            WHEN investment_option = 'option1' THEN 'Standardized Option 1'
            WHEN investment_option = 'option2' THEN 'Standardized Option 2'
            ELSE 'Other'
        END AS investment_option,
        units_held,
        unit_price,
        valuation_date,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM {{ source('bronze', 'bronze_investments') }}
),

validated_data AS (
    SELECT
        investment_id,
        member_id,
        investment_option,
        units_held,
        unit_price,
        valuation_date,
        create_date,
        update_date
    FROM standardized_data
    WHERE units_held > 0
      AND unit_price > 0
)

SELECT
    investment_id,
    member_id,
    investment_option,
    units_held,
    unit_price,
    valuation_date,
    create_date,
    update_date
FROM validated_data