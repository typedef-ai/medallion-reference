
  
    

create or replace transient table DEMO_AGENTS_DAVID.marts.dim_account
    
    
    
    as (

-- Account dimension table
select
    account_id,
    parent_account_id,
    account_name,
    geo,
    company_type,
    tier,
    billing_country
from DEMO_AGENTS_DAVID.staging.stg_sfdc__account
    )
;


  