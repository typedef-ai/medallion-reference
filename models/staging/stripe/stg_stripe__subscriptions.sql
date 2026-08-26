select
    cast(subscription_id as string) as subscription_id,
    cast(license_id as string) as license_id,
    cast(status as string) as status,
    cast(current_period_start as date) as current_period_start,
    cast(current_period_end as date) as current_period_end,
    cast(edition as string) as edition,
    cast(customer_id as string) as customer_id
from {{ ref('stripe_subscriptions') }}
