{{
    config(
        materialized='table'
    )
}}

with monthly_usage as (
    select * from {{ ref('int_product__monthly_usage') }}
),

feature_adoption as (
    select
        account_id,
        customer_id,
        usage_month,
        count(distinct feature_name) as features_used,
        sum(feature_events) as total_feature_events
    from {{ ref('int_product__feature_adoption') }}
    group by 1, 2, 3
),

user_engagement as (
    select * from {{ ref('int_cs__user_engagement') }}
),

accounts as (
    select * from {{ ref('dim_account') }}
),

final as (
    select
        u.usage_month,
        u.account_id,
        u.customer_id,
        a.account_name,
        a.geo,
        a.company_type,
        a.tier,

        -- Usage metrics (measures)
        u.total_events,
        u.login_events,
        u.report_events,
        u.api_events,
        u.total_user_sessions,
        u.total_gb_processed,
        u.total_api_calls,

        -- Feature adoption (measures)
        u.unique_features_used,
        f.features_used as features_with_events,
        f.total_feature_events,

        -- Engagement metrics (measures)
        e.active_users,
        e.users_active_last_30d,
        e.dormant_users,
        e.engagement_rate_30d_pct,

        -- Dates (dimensions)
        u.last_activity_date,
        e.avg_days_since_last_login

    from monthly_usage u
    left join feature_adoption f
        on u.account_id = f.account_id
        and u.customer_id = f.customer_id
        and u.usage_month = f.usage_month
    left join user_engagement e
        on u.account_id = e.account_id
        and u.customer_id = e.customer_id
    left join accounts a
        on u.account_id = a.account_id
)

select * from final
