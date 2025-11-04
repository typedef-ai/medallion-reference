
  create or replace   view DEMO_AGENTS_DAVID.staging.stg_product__usage_events
  
  
  
  
  as (
    with source as (
    select * from DEMO_AGENTS_DAVID.staging.product_usage_events
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
  );

