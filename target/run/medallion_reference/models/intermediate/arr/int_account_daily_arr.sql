
  
    

create or replace transient table DEMO_AGENTS_DAVID.intermediate.int_account_daily_arr
    
    
    
    as (-- Aggregate won ARR to account level by day
select
    acc.account_id,
    acc.parent_account_id,
    opp_daily.day,
    sum(opp_daily.won_arr) as total_arr
from DEMO_AGENTS_DAVID.intermediate.int_opp_daily_arr opp_daily
join DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity opp
    on opp.opportunity_id = opp_daily.opportunity_id
join DEMO_AGENTS_DAVID.staging.stg_sfdc__account acc
    on acc.account_id = opp.account_id
group by acc.account_id, acc.parent_account_id, opp_daily.day
    )
;


  