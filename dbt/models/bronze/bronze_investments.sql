{{ config(
    materialized='incremental',
    unique_key='investment_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH source_data AS (
    SELECT
        investment_id,
        member_id,
        investment_option,
        units_held,
        unit_price,
        valuation_date,
        modified_date,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM
        {{ source('fivetran', 'raw_investments') }}
)

SELECT
    investment_id,
    member_id,
    investment_option,
    units_held,
    unit_price,
    valuation_date,
    modified_date,
    create_date,
    update_date
FROM
    source_data