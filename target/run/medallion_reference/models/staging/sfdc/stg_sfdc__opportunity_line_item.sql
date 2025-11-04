
  create or replace   view DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity_line_item
  
  
  
  
  as (
    select
    cast(opportunity_line_item_id as varchar) as opportunity_line_item_id,
    cast(opportunity_id as varchar) as opportunity_id,
    cast(product_code as varchar) as product_code,
    cast(product_family as varchar) as product_family,
    cast(product_line_type as varchar) as product_line_type,
    cast(total_price as decimal(15,2)) as total_price,
    cast(quantity as int) as quantity,
    cast(start_date__c as date) as start_date__c,
    cast(end_date__c as date) as end_date__c
from DEMO_AGENTS_DAVID.staging.sfdc_opportunitylineitem
-- Filter out invalid date ranges per spec
where cast(end_date__c as date) > cast(start_date__c as date)
  );

