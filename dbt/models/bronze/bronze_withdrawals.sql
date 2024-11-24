{{ config(
    materialized='incremental',
    unique_key='withdrawal_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH source_data AS (
    SELECT
        withdrawal_id,
        member_id,
        withdrawal_date,
        amount,
        withdrawal_reason,
        modified_date,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM
        {{ source('fivetran', 'raw_withdrawals') }}
)

SELECT
    withdrawal_id,
    member_id,
    withdrawal_date,
    amount,
    withdrawal_reason,
    modified_date,
    create_date,
    update_date
FROM
    source_data