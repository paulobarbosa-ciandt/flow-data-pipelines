{{ config(
    materialized='incremental',
    unique_key='contribution_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH source_data AS (
    SELECT
        contribution_id,
        member_id,
        contribution_date,
        amount,
        contribution_type,
        modified_date,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM
        {{ source('fivetran', 'raw_contributions') }}
)

SELECT
    contribution_id,
    member_id,
    contribution_date,
    amount,
    contribution_type,
    modified_date,
    create_date,
    update_date
FROM
    source_data