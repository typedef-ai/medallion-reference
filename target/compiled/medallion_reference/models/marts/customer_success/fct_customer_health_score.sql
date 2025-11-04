

with arr_monthly as (
    select
        month_end as month,
        account_id,
        month_ending_arr as arr,
        lag(month_ending_arr) over (partition by account_id order by month_end) as prev_month_arr
    from DEMO_AGENTS_DAVID.marts.fct_arr_reporting_monthly
),

usage_monthly as (
    select
        usage_month as month,
        account_id,
        customer_id,
        total_events,
        unique_features_used,
        engagement_rate_30d_pct,
        dormant_users,
        active_users
    from DEMO_AGENTS_DAVID.marts.fct_product_usage_monthly
),

support_monthly as (
    select
        month,
        account_id,
        customer_id,
        total_tickets,
        high_priority_tickets,
        avg_satisfaction_score,
        satisfaction_rate_pct
    from DEMO_AGENTS_DAVID.marts.fct_support_metrics_monthly
),

accounts as (
    select * from DEMO_AGENTS_DAVID.marts.dim_account
),

health_scores as (
    select
        coalesce(a.month, u.month, s.month) as month,
        coalesce(a.account_id, u.account_id, s.account_id) as account_id,
        coalesce(u.customer_id, s.customer_id) as customer_id,

        -- Financial health (30 points)
        case
            when a.arr > a.prev_month_arr then 30
            when a.arr = a.prev_month_arr then 20
            else 10
        end as financial_health_score,

        -- Usage health (40 points)
        case
            when u.engagement_rate_30d_pct >= 75 then 40
            when u.engagement_rate_30d_pct >= 50 then 30
            when u.engagement_rate_30d_pct >= 25 then 20
            else 10
        end as usage_health_score,

        -- Support health (30 points)
        case
            when s.avg_satisfaction_score >= 4.0 and s.high_priority_tickets = 0 then 30
            when s.avg_satisfaction_score >= 3.5 and s.high_priority_tickets <= 2 then 20
            when s.avg_satisfaction_score >= 3.0 then 10
            else 0
        end as support_health_score,

        -- Raw metrics for analysis
        a.arr,
        a.prev_month_arr,
        u.total_events,
        u.unique_features_used,
        u.engagement_rate_30d_pct,
        u.dormant_users,
        u.active_users,
        s.total_tickets,
        s.high_priority_tickets,
        s.avg_satisfaction_score,
        s.satisfaction_rate_pct

    from arr_monthly a
    full outer join usage_monthly u
        on a.account_id = u.account_id
        and a.month = u.month
    full outer join support_monthly s
        on coalesce(a.account_id, u.account_id) = s.account_id
        and coalesce(a.month, u.month) = s.month
),

final as (
    select
        h.month,
        h.account_id,
        h.customer_id,
        a.account_name,
        a.geo,
        a.company_type,
        a.tier,

        -- Health scores (measures)
        h.financial_health_score,
        h.usage_health_score,
        h.support_health_score,
        h.financial_health_score + h.usage_health_score + h.support_health_score as total_health_score,

        -- Health tier (dimension)
        case
            when (h.financial_health_score + h.usage_health_score + h.support_health_score) >= 80 then 'Healthy'
            when (h.financial_health_score + h.usage_health_score + h.support_health_score) >= 60 then 'At Risk'
            else 'Critical'
        end as health_tier,

        -- Supporting metrics
        h.arr,
        h.prev_month_arr,
        h.arr - h.prev_month_arr as arr_change,
        h.total_events,
        h.unique_features_used,
        h.engagement_rate_30d_pct,
        h.dormant_users,
        h.active_users,
        h.total_tickets,
        h.high_priority_tickets,
        h.avg_satisfaction_score,
        h.satisfaction_rate_pct

    from health_scores h
    left join accounts a
        on h.account_id = a.account_id
)

select * from final