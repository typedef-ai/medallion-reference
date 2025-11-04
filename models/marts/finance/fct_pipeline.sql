{{
    config(
        materialized='table'
    )
}}

-- Pipeline fact table
select
    opportunity_id,
    account_id,
    stage_name,
    forecast_category,
    deal_type,
    close_month,
    arr,
    prob_weighted_arr,
    bookings
from {{ ref('int_pipeline_snapshot') }}
