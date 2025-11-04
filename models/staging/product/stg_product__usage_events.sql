with source as (
    select * from {{ ref('product_usage_events') }}
),

cleaned as (
    select
        event_id,
        customer_id,
        account_id,
        cast(event_date as date) as event_date,
        event_type,
        user_count,
        gb_processed,
        api_calls,
        feature_name
    from source
)

select * from cleaned
