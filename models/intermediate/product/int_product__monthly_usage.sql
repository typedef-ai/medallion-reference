with usage_events as (
    select * from {{ ref('stg_product__usage_events') }}
),

dates as (
    select * from {{ ref('util__dates') }}
),

monthly_usage as (
    select
        account_id,
        customer_id,
        date_trunc('month', event_date) as usage_month,
        count(distinct event_id) as total_events,
        count(distinct case when event_type = 'login' then event_id end) as login_events,
        count(distinct case when event_type = 'report_create' then event_id end) as report_events,
        count(distinct case when event_type = 'api_call' then event_id end) as api_events,
        count(distinct feature_name) as unique_features_used,
        sum(user_count) as total_user_sessions,
        sum(gb_processed) as total_gb_processed,
        sum(api_calls) as total_api_calls,
        max(event_date) as last_activity_date
    from usage_events
    group by 1, 2, 3
)

select * from monthly_usage
