with source as (
    select * from DEMO_AGENTS_DAVID.staging.support_tickets
),

cleaned as (
    select
        ticket_id,
        customer_id,
        account_id,
        cast(created_date as date) as created_date,
        cast(resolved_date as date) as resolved_date,
        priority,
        category,
        resolution_time_hours,
        satisfaction_score
    from source
)

select * from cleaned