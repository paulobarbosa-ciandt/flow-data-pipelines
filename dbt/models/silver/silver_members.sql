{{ config(
    materialized='incremental',
    unique_key='member_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH source_data AS (
    SELECT
        m.member_id,
        CONCAT(UPPER(SUBSTRING(m.first_name, 1, 1)), LOWER(SUBSTRING(m.first_name, 2))) AS first_name,
        CONCAT(UPPER(SUBSTRING(m.last_name, 1, 1)), LOWER(SUBSTRING(m.last_name, 2))) AS last_name,
        m.date_of_birth,
        m.gender,
        m.join_date,
        m.employer_id,
        SUM(c.amount) - SUM(w.amount) AS account_balance,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM
        {{ source('bronze', 'bronze_members') }} AS m
        LEFT JOIN {{ source('bronze', 'bronze_contributions') }} AS c ON m.member_id = c.member_id
        LEFT JOIN {{ source('bronze', 'bronze_withdrawals') }} AS w ON m.member_id = w.member_id
    GROUP BY
        m.member_id, m.first_name, m.last_name, m.date_of_birth, m.gender, m.join_date, m.employer_id
)

SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    date_of_birth,
    gender,
    join_date,
    employer_id,
    account_balance,
    create_date,
    update_date
FROM
    source_data