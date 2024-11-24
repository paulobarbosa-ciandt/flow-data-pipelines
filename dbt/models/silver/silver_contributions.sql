{{ config(
    materialized='incremental',
    unique_key='contribution_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH standardized_data AS (
    SELECT
        contribution_id,
        member_id,
        contribution_date,
        amount,
        CASE
            WHEN contribution_type = 'employer' THEN 'employer_contribution'
            WHEN contribution_type = 'voluntary' THEN 'personal_contribution'
            WHEN contribution_type = 'salary_sacrifice' THEN 'salary_sacrifice'
            WHEN contribution_type = 'government_co_contribution' THEN 'government_contribution'
            ELSE 'unknown'
        END AS contribution_type,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM
        {{ source('bronze', 'bronze_contributions') }}
    WHERE
        amount > 0
)

SELECT
    contribution_id,
    member_id,
    contribution_date,
    amount,
    contribution_type,
    create_date,
    update_date
FROM
    standardized_data