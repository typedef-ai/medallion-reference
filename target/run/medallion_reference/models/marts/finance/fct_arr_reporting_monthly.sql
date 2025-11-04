
  
    

create or replace transient table DEMO_AGENTS_DAVID.marts.fct_arr_reporting_monthly
    
    
    
    as (

-- Monthly ARR reporting fact table
-- Uses parent-level aggregation for correct expansion categorization (Fix for Issue #3)
select
    deltas.account_id,
    deltas.month_end,
    deltas.month_ending_arr,
    deltas.new_arr,
    deltas.expansion_arr,
    deltas.resurrection_arr,
    deltas.contraction_arr,
    deltas.churn_arr,
    deltas.net_new_arr,
    acc.geo,
    acc.company_type,
    acc.tier,
    acc.billing_country
from DEMO_AGENTS_DAVID.intermediate.int_account_monthly_deltas deltas
left join DEMO_AGENTS_DAVID.staging.stg_sfdc__account acc
    on acc.account_id = deltas.account_id
    )
;


  