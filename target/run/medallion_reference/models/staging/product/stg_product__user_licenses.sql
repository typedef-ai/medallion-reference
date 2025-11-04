
  create or replace   view DEMO_AGENTS_DAVID.staging.stg_product__user_licenses
  
  
  
  
  as (
    with source as (
    select * from DEMO_AGENTS_DAVID.staging.user_licenses
),

cleaned as (
    select
        user_license_id,
        account_id,
        customer_id,
        user_email,
        user_role,
        cast(activated_date as date) as activated_date,
        cast(last_login_date as date) as last_login_date,
        status
    from source
)

select * from cleaned
  );

