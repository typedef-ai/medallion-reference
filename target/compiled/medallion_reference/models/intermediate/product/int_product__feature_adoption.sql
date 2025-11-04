with usage_events as (
    select * from DEMO_AGENTS_DAVID.staging.stg_product__usage_events
),

user_licenses as (
    select * from DEMO_AGENTS_DAVID.staging.stg_product__user_licenses
),

account_license_counts as (
    select
        account_id,
        customer_id,
        count(*) as total_licenses,
        count(case when status = 'active' then 1 end) as active_licenses
    from user_licenses
    group by 1, 2
),

feature_usage as (
    select
        u.account_id,
        u.customer_id,
        u.feature_name,
        date_trunc('month', u.event_date) as usage_month,
        count(distinct u.event_id) as feature_events,
        count(distinct u.event_date) as days_with_usage,
        sum(u.user_count) as total_users_engaged,
        sum(u.gb_processed) as total_gb_processed,
        sum(u.api_calls) as total_api_calls
    from usage_events u
    group by 1, 2, 3, 4
),

enriched as (
    select
        f.*,
        l.total_licenses,
        l.active_licenses,
        round(cast(f.total_users_engaged as decimal) / nullif(l.active_licenses, 0), 2) as feature_penetration_rate
    from feature_usage f
    left join account_license_counts l
        on f.account_id = l.account_id
        and f.customer_id = l.customer_id
)

select * from enriched