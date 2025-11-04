
  
    

create or replace transient table DEMO_AGENTS_DAVID.marts.fct_pipeline
    
    
    
    as (

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
from DEMO_AGENTS_DAVID.intermediate.int_pipeline_snapshot
    )
;


  