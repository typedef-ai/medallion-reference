select
    cast(opportunity_id as varchar) as opportunity_id,
    cast(account_id as varchar) as account_id,
    cast(name as varchar) as name,
    cast(stage_name as varchar) as stage_name,
    cast(forecast_category as varchar) as forecast_category,
    cast(is_won as boolean) as is_won,
    cast(is_closed as boolean) as is_closed,
    cast(probability as int) as probability,
    cast(amount as decimal(15,2)) as amount,
    cast(type as varchar) as type,
    cast(license_start_date as date) as license_start_date,
    cast(license_end_date as date) as license_end_date,
    cast(created_date as date) as created_date,
    cast(close_date as date) as close_date,
    cast(owner_id as varchar) as owner_id
from DEMO_AGENTS_DAVID.staging.sfdc_opportunity