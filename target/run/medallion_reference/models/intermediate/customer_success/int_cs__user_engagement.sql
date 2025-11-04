
  create or replace   view DEMO_AGENTS_DAVID.intermediate.int_cs__user_engagement
  
  
  
  
  as (
    with user_licenses as (
    select * from DEMO_AGENTS_DAVID.staging.stg_product__user_licenses
),

usage_events as (
    select * from DEMO_AGENTS_DAVID.staging.stg_product__usage_events
),

dates as (
    select * from DEMO_AGENTS_DAVID.staging.util__dates
),

-- Calculate days since last login for each user
user_activity as (
    select
        ul.user_license_id,
        ul.account_id,
        ul.customer_id,
        ul.user_email,
        ul.user_role,
        ul.activated_date,
        ul.last_login_date,
        ul.status,
        datediff('day', ul.last_login_date, current_date) as days_since_last_login,
        datediff('day', ul.activated_date, current_date) as days_since_activation
    from user_licenses ul
),

-- Aggregate usage by account
account_engagement as (
    select
        account_id,
        customer_id,
        count(*) as total_users,
        count(case when status = 'active' then 1 end) as active_users,
        count(case when days_since_last_login <= 7 then 1 end) as users_active_last_7d,
        count(case when days_since_last_login <= 30 then 1 end) as users_active_last_30d,
        count(case when days_since_last_login > 90 then 1 end) as dormant_users,
        avg(days_since_last_login) as avg_days_since_last_login,
        count(case when user_role = 'Admin' then 1 end) as admin_users,
        count(case when user_role = 'Power User' then 1 end) as power_users,
        count(case when user_role = 'Viewer' then 1 end) as viewer_users
    from user_activity
    group by 1, 2
),

enriched as (
    select
        *,
        round(cast(users_active_last_30d as decimal) / nullif(active_users, 0) * 100, 2) as engagement_rate_30d_pct,
        round(cast(dormant_users as decimal) / nullif(total_users, 0) * 100, 2) as dormancy_rate_pct
    from account_engagement
)

select * from enriched
  );

