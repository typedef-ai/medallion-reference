
  create or replace   view DEMO_AGENTS_DAVID.staging.stg_stripe__subscriptions
  
  
  
  
  as (
    select
    cast(subscription_id as varchar) as subscription_id,
    cast(license_id as varchar) as license_id,
    cast(status as varchar) as status,
    cast(current_period_start as date) as current_period_start,
    cast(current_period_end as date) as current_period_end,
    cast(edition as varchar) as edition,
    cast(customer_id as varchar) as customer_id
from DEMO_AGENTS_DAVID.staging.stripe_subscriptions
  );

