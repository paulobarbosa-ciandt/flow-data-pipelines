{{ config(
    materialized = 'incremental',
    unique_key = 'member_sk',
    incremental_strategy = 'merge',
    on_schema_change = 'sync_all_columns'
) }}

WITH snapshot_data AS (
    SELECT
        member_id,
        full_name,
        date_of_birth,
        gender,
        join_date,
        employer_id,
        create_date,
        update_date,
        dbt_valid_from AS effective_date,
        dbt_valid_to AS expiry_date,
        dbt_is_current AS is_active
    FROM {{ ref('snapshot_silver_members') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['member_id', 'effective_date']) }} AS member_sk,
    member_id,
    full_name,
    date_of_birth,
    gender,
    join_date,
    employer_id,
    create_date,
    update_date,
    effective_date,
    expiry_date,
    is_active
FROM snapshot_data