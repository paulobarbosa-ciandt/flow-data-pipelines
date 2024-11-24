{{ config(
    materialized='incremental',
    unique_key='withdrawal_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH standardized_data AS (
    SELECT
        withdrawal_id,
        member_id,
        withdrawal_date,
        amount,
        CASE
            WHEN withdrawal_reason = 'retirement' THEN 'retirement_withdrawal'
            WHEN withdrawal_reason = 'financial_hardship' THEN 'hardship_withdrawal'
            WHEN withdrawal_reason = 'death_benefit' THEN 'death_benefit_payment'
            WHEN withdrawal_reason = 'invalidity' THEN 'invalidity_payment'
            ELSE 'unknown'
        END AS withdrawal_reason,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM {{ source('bronze', 'bronze_withdrawals') }}
)

SELECT
    withdrawal_id,
    member_id,
    withdrawal_date,
    amount,
    withdrawal_reason,
    create_date,
    update_date
FROM standardized_data
WHERE amount > 0