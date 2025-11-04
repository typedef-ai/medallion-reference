

with support_metrics as (
    select * from DEMO_AGENTS_DAVID.intermediate.int_support__monthly_metrics
),

accounts as (
    select * from DEMO_AGENTS_DAVID.marts.dim_account
),

arr_reporting as (
    select
        month_end,
        account_id,
        month_ending_arr as arr
    from DEMO_AGENTS_DAVID.marts.fct_arr_reporting_monthly
),

final as (
    select
        s.ticket_month as month,
        s.account_id,
        s.customer_id,
        a.account_name,
        a.geo,
        a.company_type,
        a.tier,

        -- Ticket volume metrics (measures)
        s.total_tickets,
        s.high_priority_tickets,
        s.medium_priority_tickets,
        s.low_priority_tickets,

        -- Category breakdown (measures)
        s.bug_tickets,
        s.feature_request_tickets,
        s.training_tickets,
        s.billing_tickets,

        -- Resolution metrics (measures)
        s.avg_resolution_hours,
        s.satisfied_tickets,
        s.dissatisfied_tickets,

        -- Satisfaction metrics (measures)
        s.avg_satisfaction_score,
        s.satisfaction_rate_pct,
        s.high_priority_rate_pct,

        -- Context metrics
        arr.arr as current_arr,
        round(cast(s.total_tickets as decimal) / nullif(arr.arr, 0) * 1000, 2) as tickets_per_1k_arr

    from support_metrics s
    left join accounts a
        on s.account_id = a.account_id
    left join arr_reporting arr
        on s.account_id = arr.account_id
        and s.ticket_month = arr.month_end
)

select * from final