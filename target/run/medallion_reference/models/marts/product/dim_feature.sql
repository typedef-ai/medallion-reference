
  
    

create or replace transient table DEMO_AGENTS_DAVID.marts.dim_feature
    
    
    
    as (

with usage_events as (
    select * from DEMO_AGENTS_DAVID.staging.stg_product__usage_events
),

feature_stats as (
    select
        feature_name,
        count(distinct account_id) as accounts_using_feature,
        count(distinct customer_id) as customers_using_feature,
        count(*) as total_events,
        sum(gb_processed) as total_gb_processed,
        sum(api_calls) as total_api_calls,
        min(event_date) as first_usage_date,
        max(event_date) as last_usage_date
    from usage_events
    group by 1
),

feature_categories as (
    select
        feature_name,
        case
            when feature_name in ('Data Export', 'Data Import', 'File Upload') then 'Data Management'
            when feature_name in ('Custom Reports', 'Report Builder', 'Dashboard View') then 'Reporting'
            when feature_name in ('Predictive Models', 'ML Pipeline') then 'Analytics'
            when feature_name in ('Alerts & Notifications', 'Email Notifications') then 'Alerts'
            when feature_name in ('User Management', 'Permissions') then 'Administration'
            else 'Other'
        end as feature_category,
        case
            when feature_name in ('Predictive Models', 'ML Pipeline', 'Report Builder') then 'Premium'
            else 'Standard'
        end as feature_tier
    from (select distinct feature_name from usage_events)
),

final as (
    select
        s.feature_name,
        c.feature_category,
        c.feature_tier,
        s.accounts_using_feature,
        s.customers_using_feature,
        s.total_events,
        s.total_gb_processed,
        s.total_api_calls,
        s.first_usage_date,
        s.last_usage_date,
        datediff('day', s.first_usage_date, s.last_usage_date) as days_in_use
    from feature_stats s
    left join feature_categories c
        on s.feature_name = c.feature_name
)

select * from final
    )
;


  