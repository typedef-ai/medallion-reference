
  create or replace   view DEMO_AGENTS_DAVID.staging.stg_sfdc__account
  
  
  
  
  as (
    select
    cast(account_id as varchar) as account_id,
    cast(parent_account_id as varchar) as parent_account_id,
    cast(account_name as varchar) as account_name,
    cast(geo as varchar) as geo,
    cast(company_type as varchar) as company_type,
    cast(tier as varchar) as tier,
    cast(billing_country as varchar) as billing_country
from DEMO_AGENTS_DAVID.staging.sfdc_account
  );

