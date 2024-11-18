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