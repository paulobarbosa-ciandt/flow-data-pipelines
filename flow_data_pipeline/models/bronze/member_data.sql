{{ config(
    materialized='incremental',
    unique_key='member_id',
    on_schema_change='sync_all_columns'
) }}

with source_data as (
    select
        member_id,
        first_name,
        last_name,
        date_of_birth,
        contribution_type,
        withdrawal_reason,
        units_held,
        unit_price,
        current_timestamp() as create_date,
        current_timestamp() as update_date
    from
        parquet.`/mnt/flowdataefficiencydemo/fivetran/raw_members/*.parquet`
)

select * from source_data

{{ config(
    materialized='incremental',
    unique_key='member_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH source_data AS (
    SELECT
        member_id,
        first_name,
        last_name,
        date_of_birth,
        gender,
        address,
        phone_number,
        email,
        join_date,
        employer_id,
        modified_date,
        current_timestamp() AS create_date,
        current_timestamp() AS update_date
    FROM
        '{{ source('azure_blob_storage', 'raw_members') }}'
)

SELECT
    member_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    address,
    phone_number,
    email,
    join_date,
    employer_id,
    modified_date,
    create_date,
    update_date
FROM
    source_data

{% if is_incremental() %}
WHERE
    modified_date > (SELECT MAX(modified_date) FROM {{ this }})
{% endif %}