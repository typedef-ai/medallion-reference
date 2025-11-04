
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ticket_id
from DEMO_AGENTS_DAVID.staging.stg_support__tickets
where ticket_id is null



  
  
      
    ) dbt_internal_test