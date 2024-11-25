{% snapshot snapshot_silver_members %}

{{
  config(
    target_schema = 'gold',
    unique_key = 'member_id',
    strategy = 'timestamp',
    updated_at = 'update_date',
    invalidate_hard_deletes = True
  )
}}

SELECT
    member_id,
    full_name,
    date_of_birth,
    gender,
    join_date,
    employer_id,
    current_timestamp() AS create_date,
    current_timestamp() AS update_date
FROM {{ source('silver', 'silver_members') }}

{% endsnapshot %}