
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select event_id
from DEMO_AGENTS_DAVID.staging.stg_product__usage_events
where event_id is null



  
  
      
    ) dbt_internal_test