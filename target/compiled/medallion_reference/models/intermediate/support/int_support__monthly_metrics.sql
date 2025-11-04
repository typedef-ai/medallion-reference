with tickets as (
    select * from DEMO_AGENTS_DAVID.staging.stg_support__tickets
),

monthly_metrics as (
    select
        account_id,
        customer_id,
        date_trunc('month', created_date) as ticket_month,
        count(*) as total_tickets,
        count(case when priority = 'High' then 1 end) as high_priority_tickets,
        count(case when priority = 'Medium' then 1 end) as medium_priority_tickets,
        count(case when priority = 'Low' then 1 end) as low_priority_tickets,
        count(case when category = 'Bug Report' then 1 end) as bug_tickets,
        count(case when category = 'Feature Request' then 1 end) as feature_request_tickets,
        count(case when category = 'Training' then 1 end) as training_tickets,
        count(case when category = 'Billing' then 1 end) as billing_tickets,
        avg(resolution_time_hours) as avg_resolution_hours,
        avg(satisfaction_score) as avg_satisfaction_score,
        count(case when satisfaction_score >= 4 then 1 end) as satisfied_tickets,
        count(case when satisfaction_score <= 2 then 1 end) as dissatisfied_tickets
    from tickets
    group by 1, 2, 3
),

enriched as (
    select
        *,
        round(cast(satisfied_tickets as decimal) / nullif(total_tickets, 0) * 100, 2) as satisfaction_rate_pct,
        round(cast(high_priority_tickets as decimal) / nullif(total_tickets, 0) * 100, 2) as high_priority_rate_pct
    from monthly_metrics
)

select * from enriched